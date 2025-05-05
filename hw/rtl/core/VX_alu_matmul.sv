// Copyright © 2019-2023
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`include "VX_define.vh"
`define ROWMAJOR(x, y) (x + y * int'($floor($sqrt(NUM_LANES))));

module VX_alu_matmul #(
    parameter `STRING INSTANCE_ID = "",
    // parameter BLOCK_IDX = 0,
    parameter NUM_LANES = 1
) (
    input wire              clk,
    input wire              reset,
    VX_execute_if.slave     execute_if,
    VX_commit_if.master     commit_if
);

    `UNUSED_SPARAM (INSTANCE_ID)
    localparam LANE_BITS      = `CLOG2(NUM_LANES);
    localparam LANE_WIDTH     = `UP(LANE_BITS);
    localparam PID_BITS       = `CLOG2(`NUM_THREADS / NUM_LANES);
    localparam PID_WIDTH      = `UP(PID_BITS);

    localparam SIDELENGTH     = $rtoi($floor($sqrt(NUM_LANES)));
    localparam INNERAXIS      = SIDELENGTH;

    `UNUSED_PARAM(LANE_BITS)
    `UNUSED_PARAM(LANE_WIDTH)

    `UNUSED_VAR (execute_if.data.rs3_data)

    reg [NUM_LANES-1:0][`XLEN-1:0] mat_mul_result;
    wire [NUM_LANES-1:0][`XLEN-1:0] mat_mul_result_r;

    wire [NUM_LANES-1:0][`XLEN-1:0] alu_in1 = execute_if.data.rs1_data;
    wire [NUM_LANES-1:0][`XLEN-1:0] alu_in2 = execute_if.data.rs2_data;

    // Multiply Units
    logic [SIDELENGTH * SIDELENGTH - 1: 0][INNERAXIS - 1 : 0][`XLEN - 1 : 0] product;

    // 1) Iterate through the output matrix
    for(genvar x = 0; x < int'($floor($sqrt(NUM_LANES))); x++) begin : g_alu_matmul_x
        for(genvar y = 0; y < int'($floor($sqrt(NUM_LANES))); y++) begin : g_alu_matmul_y

            int index = `ROWMAJOR(x, y);

            // 2) Iterate through the inner axis
            for(genvar j = 0; j < INNERAXIS; j++) begin : g_alu_matmul_j

                int a_index = `ROWMAJOR(j, y);
                int b_index = `ROWMAJOR(x, j);
                wire [`XLEN - 1:0] mul_in1 = alu_in1[a_index];//{is_signed_mul_a && execute_if.data.rs1_data[a_index][`XLEN-1], execute_if.data.rs1_data[a_index]};
                wire [`XLEN - 1:0] mul_in2 = alu_in2[b_index];//{is_signed_mul_b && execute_if.data.rs2_data[b_index][`XLEN-1], execute_if.data.rs2_data[b_index]};

                VX_multiplier #(
                    .A_WIDTH( `XLEN),
                    .B_WIDTH( `XLEN),
                    .R_WIDTH( `XLEN),
                    .SIGNED ( 1),
                    .LATENCY( `LATENCY_IMUL)
                ) multiply_modules (
                    .clk(clk),
                    .enable(execute_if.ready),
                    .dataa(mul_in1),
                    .datab(mul_in2),
                    .result(product[index][j])
                );
            end

            // 3) Create a pipelined reduction tree
            VX_reduce_tree_registered #(
                .DATAW_IN(`XLEN),
                .DATAW_OUT(`XLEN),
                .N(INNERAXIS),
                .OP( "+"),
                .INTERMEDIATE_REGISTERED(1),
                .OUTPUT_REGISTERED(1)
            ) addition_reduction (
                .clk(clk),
                .reset(reset),
                .enable(execute_if.ready),
                .data_in(product[index]),
                .data_out(mat_mul_result[index])
            );

        end
    end

    wire [`PC_BITS-1:0] PC_r;

    // I deleted some of the elastic buffer inputs, but later commented them out. If there are missing signals which aren't commented out and are deleted, refer to VX_alu_int
    // VX_elastic_buffer #(
    //     .DATAW (`UUID_WIDTH + `NW_WIDTH + NUM_LANES + `NR_BITS + 1 + PID_WIDTH + 1 + 1 + (NUM_LANES * `XLEN) + `PC_BITS /*+ `PC_BITS +  LANE_WIDTH*/)
    // ) rsp_buf (
    //     .clk      (clk),
    //     .reset    (reset),
    //     .valid_in (execute_if.valid), // input
    //     .ready_in (execute_if.ready), // output
    //     .data_in  ({execute_if.data.uuid, execute_if.data.wid, execute_if.data.tmask, execute_if.data.rd, execute_if.data.wb, execute_if.data.pid, execute_if.data.sop, execute_if.data.eop, mat_mul_result, execute_if.data.PC/*, cbr_dest, tid*/}),
    //     .data_out ({commit_if.data.uuid, commit_if.data.wid, commit_if.data.tmask, commit_if.data.rd, commit_if.data.wb, commit_if.data.pid, commit_if.data.sop, commit_if.data.eop, mat_mul_result_r, PC_r/*, cbr_dest_r, tid_r*/}),
    //     .valid_out (commit_if.valid), // input
    //     .ready_out (commit_if.ready)  // output
    // );

    // VX_pipe_buffer #(
    //     .DATAW (`UUID_WIDTH + `NW_WIDTH + NUM_LANES + `NR_BITS + 1 + PID_WIDTH + 1 + 1 + `PC_BITS),
    //     .DEPTH (`LATENCY_IMUL + $clog2(INNERAXIS)) // 4 cycles for the multiply and 2 cycles for addition if multiplying 2 4x4 matrix= 6 
    // ) pipe_buffer (
    //     .clk      (clk),
    //     .reset    (reset),
    //     .valid_in (execute_if.valid),
    //     .ready_in (execute_if.ready),
    //     .data_in  ({execute_if.data.uuid, execute_if.data.wid, execute_if.data.tmask, execute_if.data.rd, execute_if.data.wb, execute_if.data.pid, execute_if.data.sop, execute_if.data.eop, /*mat_mul_result,*/ execute_if.data.PC/*, cbr_dest, tid*/}),
    //     .data_out ({commit_if.data.uuid, commit_if.data.wid, commit_if.data.tmask, commit_if.data.rd, commit_if.data.wb, commit_if.data.pid, commit_if.data.sop, commit_if.data.eop, /*mat_mul_result_r,*/ PC_r/*, cbr_dest_r, tid_r*/}),
    //     .valid_out (commit_if.valid),
    //     .ready_out (commit_if.ready)
    // );

    // 4) Shift register to hold control signals in parallel with multiplier and adder
    VX_shift_register #(
        .DATAW (1 + `UUID_WIDTH + `NW_WIDTH + NUM_LANES + `NR_BITS + 1 + PID_WIDTH + 1 + 1 + `PC_BITS),
        .RESETW (1),
        .DEPTH (`LATENCY_IMUL + $clog2(INNERAXIS)) // 4 cycles for the multiply and 2 cycles for addition if multiplying 2 4x4 matrix= 6 
    ) shift_register_buf (
        .clk        (clk),
        .reset      (reset),
        .enable     (execute_if.ready),
        .data_in    ({execute_if.valid, execute_if.data.uuid, execute_if.data.wid, execute_if.data.tmask, execute_if.data.rd, execute_if.data.wb, execute_if.data.pid, execute_if.data.sop, execute_if.data.eop, /*mat_mul_result,*/ execute_if.data.PC /*, cbr_dest, tid*/}),
        .data_out   ({commit_if.valid, commit_if.data.uuid, commit_if.data.wid, commit_if.data.tmask, commit_if.data.rd, commit_if.data.wb, commit_if.data.pid, commit_if.data.sop, commit_if.data.eop, /*mat_mul_result_r,*/ PC_r/*, cbr_dest_r, tid_r*/})
    );

    // Only allow more inputs if the current output is read or if there is no output
    assign execute_if.ready = commit_if.valid ? commit_if.ready : 1'b1;

    assign mat_mul_result_r = mat_mul_result;

    for (genvar i = 0; i < NUM_LANES; ++i) begin : g_commit
        assign commit_if.data.data[i] =  mat_mul_result_r[i];
    end

    assign commit_if.data.PC = PC_r;

// `ifdef DBG_TRACE_PIPELINE
//     always @(posedge clk) begin
//         if (br_enable) begin
//             `TRACE(2, ("%t: %s branch: wid=%0d, PC=0x%0h, (#%0d)\n",
//                 $time, INSTANCE_ID, br_wid, {commit_if.data.PC, 1'b0}, commit_if.data.uuid))
//         end
//     end
// `endif

endmodule
