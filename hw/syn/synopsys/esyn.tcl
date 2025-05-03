#set search_path		[concat /nethome/dshim8/Desktop/GTCAD-3DPKG-v3/example/tech/cln28hpm/2d_db/ /nethome/dshim8/Desktop/GTCAD-3DPKG-v3/example/tech/cln28hpm/2d_hard_db/ ../../rtl/ ../../rtl/interfaces ../../rtl/pipe_regs ../../rtl/shared_memory ../../rtl/cache ../../models/memory/cln28hpm/2d_hardmacro_db]
set search_path			[concat ../../rtl/ ../../rtl/interfaces ../../rtl/pipe_regs ../../rtl/shared_memory ../../rtl/cache ../../rtl/core ../../rtl/fpu ../../rtl/interfaces ../../rtl/libs ../../rtl/mem ../../models/memory/cln28hpm/2d_hardmacro_db]
set link_library		[concat ./NanGate_15nm_OCL.db]
set symbol_library		{}
set target_library		[concat ./NanGate_15nm_OCL.db]

# set verilog_files 	[ list VX_countones.v VX_priority_encoder_w_mask.v VX_dram_req_rsp_inter.v VX_cache_data_per_index.v VX_Cache_Bank.v VX_cache_data.v VX_d_cache.v VX_bank_valids.v VX_priority_encoder_sm.v VX_shared_memory.v VX_shared_memory_block.v VX_dmem_controller.v VX_generic_priority_encoder.v VX_generic_stack.v VX_join_inter.v VX_csr_wrapper.v VX_csr_req_inter.v VX_csr_wb_inter.v  VX_gpgpu_inst.v VX_gpu_inst_req_inter.v VX_wstall_inter.v VX_inst_exec_wb_inter.v VX_lsu.v VX_execute_unit.v VX_lsu_addr_gen.v VX_inst_multiplex.v VX_exec_unit_req_inter.v VX_lsu_req_inter.v VX_alu.v VX_back_end.v VX_gpr_stage.v VX_gpr_data_inter.v VX_csr_handler.v VX_decode.v VX_define.vh VX_config.vh VX_user_config.vh VX_scheduler.v VX_fetch.v VX_front_end.v VX_generic_register.v VX_gpr.v VX_gpr_wrapper.v VX_priority_encoder.v VX_warp_scheduler.v VX_writeback.v byte_enabled_simple_dual_port_ram.v VX_branch_response_inter.v VX_dcache_request_inter.v VX_dcache_response_inter.v VX_frE_to_bckE_req_inter.v VX_gpr_jal_inter.v VX_gpr_read_inter.v VX_icache_request_inter.v VX_icache_response_inter.v VX_inst_mem_wb_inter.v VX_inst_meta_inter.v VX_jal_response_inter.v VX_mem_req_inter.v VX_mw_wb_inter.v VX_warp_ctl_inter.v VX_wb_inter.v VX_d_e_reg.v VX_f_d_reg.v Vortex.v VX_cache_bank_valid.v \
#					]
# set verilog_files       [ list Vortex.sv VX_countones.sv VX_priority_encoder_w_mask.sv VX_dram_req_rsp_inter.sv cache_set.sv VX_Cache_Bank.sv VX_Cache_Block_DM.sv VX_cache_data.sv VX_d_cache.sv VX_generic_pc.sv VX_bank_valids.sv VX_priority_encoder_sm.sv VX_shared_memory.sv VX_shared_memory_block.sv VX_dmem_controller.sv VX_generic_priority_encoder.sv VX_generic_stack.sv VX_join_inter.sv VX_csr_wrapper.sv VX_csr_req_inter.sv VX_csr_wb_inter.sv  VX_gpgpu_inst.sv VX_gpu_inst_req_inter.sv VX_wstall_inter.sv VX_inst_exec_wb_inter.sv VX_lsu.sv VX_execute_unit.sv VX_lsu_addr_gen.sv VX_inst_multiplex.sv VX_exec_unit_req_inter.sv VX_lsu_req_inter.sv VX_alu.sv VX_back_end.sv VX_gpr_stage.sv VX_gpr_data_inter.sv VX_csr_handler.sv VX_decode.sv VX_define.vh VX_scheduler.sv VX_fetch.sv VX_front_end.sv VX_generic_register.sv VX_gpr.sv VX_gpr_wrapper.sv VX_one_counter.sv VX_priority_encoder.sv VX_warp_scheduler.sv VX_writeback.sv byte_enabled_simple_dual_port_ram.sv VX_branch_response_inter.sv VX_dcache_request_inter.sv VX_dcache_response_inter.sv VX_frE_to_bckE_req_inter.sv VX_gpr_jal_inter.sv VX_gpr_read_inter.sv VX_icache_request_inter.sv VX_icache_response_inter.sv VX_inst_mem_wb_inter.sv VX_inst_meta_inter.sv VX_jal_response_inter.sv VX_mem_req_inter.sv VX_mw_wb_inter.sv VX_warp_ctl_inter.sv VX_wb_inter.sv VX_d_e_reg.sv VX_f_d_reg.sv \
# 				    ]

set verilog_files       [list VX_alu_unit.sv VX_config.vh VX_define.vh VX_gpu_pkg.sv VX_platform.vh VX_scope.vh VX_socket.sv VX_types.vh \
                        VX_branch_ctl_if.sv VX_commit_if.sv VX_dcr_bus_if.sv VX_decode_sched_if.sv VX_execute_if.sv VX_ibuffer_if.sv \
                        VX_sched_csr_if.sv VX_scoreboard_if.sv VX_writeback_if.sv VX_commit_csr_if.sv VX_commit_sched_if.sv VX_decode_if.sv \
                        VX_dispatch_if.sv VX_fetch_if.sv VX_operands_if.sv VX_schedule_if.sv VX_warp_ctl_if.sv \
                        VX_alu_int.sv VX_alu_muldiv.sv VX_alu_unit.sv VX_gather_unit.sv VX_pe_switch.sv VX_dispatch_unit.sv \
                        VX_allocator.sv        VX_bits_remove.sv     VX_elastic_adapter.sv  VX_lzc.sv               VX_mux.sv             VX_pipe_register.sv     VX_rr_arbiter.sv      VX_skid_buffer.sv    VX_stream_unpack.sv \
                        VX_bypass_buffer.sv   VX_elastic_buffer.sv   VX_matrix_arbiter.sv    VX_onehot_encoder.sv  VX_placeholder.sv       VX_scan.sv \
                        VX_avs_adapter.sv      VX_cyclic_arbiter.sv  VX_fifo_queue.sv       VX_mem_bank_adapter.sv  VX_onehot_mux.sv      VX_popcount.sv          VX_scope_switch.sv    VX_stream_arb.sv     VX_toggle_buffer.sv \
                        VX_axi_adapter.sv      VX_demux.sv           VX_find_first.sv       VX_mem_coalescer.sv     VX_onehot_shift.sv    VX_priority_arbiter.sv  VX_scope_tap.sv       VX_stream_buffer.sv  VX_transpose.sv \
                        VX_axi_write_ack.sv    VX_divider.sv         VX_generic_arbiter.sv  VX_mem_data_adapter.sv  VX_pending_size.sv    VX_priority_encoder.sv  VX_serial_div.sv \
                        VX_bits_concat.sv      VX_dp_ram.sv          VX_index_buffer.sv     VX_mem_scheduler.sv     VX_pe_serializer.sv   VX_reduce_tree.sv       VX_serial_mul.sv      VX_stream_pack.sv \
                        VX_bits_insert.sv      VX_edge_trigger.sv    VX_index_queue.sv      VX_multiplier.sv        VX_pipe_buffer.sv     VX_reset_relay.sv       VX_shift_register.sv  VX_stream_switch.sv \
                    ]

set top_level VX_alu_unit
analyze -format sverilog $verilog_files
#analyze -format sverilog -error=LINT-66 $verilog_files
elaborate VX_alu_unit
link

set clk_freq 0.4
set clk_period [expr 1000.0 / $clk_freq / 1.0]
create_clock [get_ports clk] -period $clk_period
set_max_fanout 20 [get_ports clk]
set_ideal_network [get_ports clk]

set_max_fanout 20 [get_ports reset]
set_false_path -from [get_ports reset]
all_high_fanout -net -threshold 20

# set_register_merging Vortex FALSE
# set compile_seqmap_propagate_constants false
# set compile_seqmap_propagate_high_effort false

check_design
compile_ultra -no_autoungroup
ungroup -all -flatten
uniquify

define_name_rules verilog -remove_internal_net_bus -remove_port_bus
change_names -rule verilog -hierarchy

report_qor 
report_area
report_hierarchy
report_cell
report_reference
report_port
report_power

write -hierarchy -format verilog -output Vortex.netlist.v
remove_ideal_network [get_ports clk]
set_propagated_clock [get_ports clk]
write_sdc -version 1.9 Vortex.sdc
write_file -format ddc -output Vortex.ddc
exit