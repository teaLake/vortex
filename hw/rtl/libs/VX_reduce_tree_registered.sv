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

`include "VX_platform.vh"

`TRACING_OFF
module VX_reduce_tree_registered #(
    parameter DATAW_IN   = 1,
    parameter DATAW_OUT  = DATAW_IN,
    parameter N          = 1,
    parameter `STRING OP = "+",
    parameter INTERMEDIATE_REGISTERED = 1,
    parameter OUTPUT_REGISTERED = 1
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [N-1:0][DATAW_IN-1:0] data_in,
    output logic [DATAW_OUT-1:0]      data_out
);
    if (N == 1) begin : g_passthru
        `UNUSED_VAR (clk);
        `UNUSED_VAR (enable);
        `UNUSED_VAR (reset);
        assign data_out = DATAW_OUT'(data_in[0]);
    end else begin : g_reduce
        localparam int N_A = N / 2;
        localparam int N_B = N - N_A;

        wire [N_A-1:0][DATAW_IN-1:0] in_A;
        wire [N_B-1:0][DATAW_IN-1:0] in_B;
        wire [DATAW_OUT-1:0] out_A, out_B;

        for (genvar i = 0; i < N_A; i++) begin : g_in_A
            assign in_A[i] = data_in[i];
        end

        for (genvar i = 0; i < N_B; i++) begin : g_in_B
            assign in_B[i] = data_in[N_A + i];
        end

        VX_reduce_tree_registered #(
            .DATAW_IN  (DATAW_IN),
            .DATAW_OUT (DATAW_OUT),
            .N  (N_A),
            .OP (OP),
            .INTERMEDIATE_REGISTERED(INTERMEDIATE_REGISTERED),
            .OUTPUT_REGISTERED(INTERMEDIATE_REGISTERED)
        ) reduce_A (
            .clk(clk),
            .reset(reset),
            .enable(enable),
            .data_in  (in_A),
            .data_out (out_A)
        );

        VX_reduce_tree_registered #(
            .DATAW_IN  (DATAW_IN),
            .DATAW_OUT (DATAW_OUT),
            .N  (N_B),
            .OP (OP),
            .INTERMEDIATE_REGISTERED(INTERMEDIATE_REGISTERED),
            .OUTPUT_REGISTERED(INTERMEDIATE_REGISTERED)
        ) reduce_B (
            .clk(clk),
            .reset(reset),
            .enable(enable),
            .data_in  (in_B),
            .data_out (out_B)
        );

        if(OUTPUT_REGISTERED != 1) begin : reduce_tree_decision
            `UNUSED_VAR (clk);
            `UNUSED_VAR (enable);
            `UNUSED_VAR (reset);
            if (OP == "+") begin : g_plus
                assign data_out = out_A + out_B;
            end else if (OP == "^") begin : g_xor
                assign data_out = out_A ^ out_B;
            end else if (OP == "&") begin : g_and
                assign data_out = out_A & out_B;
            end else if (OP == "|") begin : g_or
                assign data_out = out_A | out_B;
            end else begin : g_error
                `ERROR(("invalid parameter"));
            end
        end else begin : reduce_tree_decision_2
            if (OP == "+") begin : g_plus
                always @ (posedge clk) begin
                    if(reset) begin
                        data_out <= '0;
                    end else if(enable) begin
                        data_out <= out_A + out_B;
                    end else begin
                        data_out <= data_out;
                    end
                end

            end else if (OP == "^") begin : g_xor
                always @ (posedge clk) begin
                    if(reset) begin
                        data_out <= '0;
                    end else if(enable) begin
                        data_out <= out_A ^ out_B;
                    end else begin
                        data_out <= data_out;
                    end
                end

            end else if (OP == "&") begin : g_and
                always @ (posedge clk) begin
                    if(reset) begin
                        data_out <= '0;
                    end else if(enable) begin
                        data_out <= out_A & out_B;
                    end else begin
                        data_out <= data_out;
                    end
                end

            end else if (OP == "|") begin : g_or
                always @ (posedge clk) begin
                    if(reset) begin
                        data_out <= '0;
                    end else if(enable) begin
                        data_out <= out_A | out_B;
                    end else begin
                        data_out <= data_out;
                    end
                end
            end else begin : g_error
                `ERROR(("invalid parameter"));
            end
        end
    end

endmodule
`TRACING_ON
