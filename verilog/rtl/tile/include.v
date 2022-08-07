/////Define/////
`include       "/home/younis/caravel/caravel_user_project/verilog/rtl/include/dmbr_define.v"
`include       "/home/younis/caravel/caravel_user_project/verilog/rtl/include/jtag.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/sys.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/iop.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/network_define.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/define.tmp.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/l15.tmp.v" 
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/lsu.tmp.v" 
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/include/l2.tmp.v" 



/////Tile top level/////
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/config_regs.tmp.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/cpx_arbitrator.v"




/////DMBR/////

`include       "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/dmbr/dmbr.tmp.v"


/////RTAP/////

`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/rtap/rtap.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/rtap/rtap_ucb_receiver.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/rtap/rtap_ucb_transmitter.v"


/////MISCs/////

`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/synchronizer.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/valrdy_to_credit.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/credit_to_valrdy.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/ucb_bus_in.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/ucb_bus_out.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/swrvr_clib.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/clk_gating_latch.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/swrvr_dlib.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/u1.beh.v"
`include        "/home/younis/caravel/caravel_user_project/verilog/rtl/tile/MISCs/m1.beh.v"



/////dynamic_node/////

`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic_node_top.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_input_top_16.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_input_top_4.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_input_route_request_calc.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_input_control.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_output_top.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_output_datapath.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic/dynamic_output_control.v"

`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/components/bus_compare_equal.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/components/flip_bus.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/components/net_dff.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/components/one_of_eight.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/components/one_of_five.v"

`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/common/network_input_blk_multi_out.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/common/space_avail_top.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/dynamic_node/dynamic_node_top_wrap.v"


/////Core/////

`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/asu_riscv_multiplier.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/frontend_stage.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/decode_stage.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/issue_stage.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/execute_stage.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/commit_stage.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/instr_decoder.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/regfile.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/scoreboard_data_hazards.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/csr_regfile.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/csr.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/ALU.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/branch_unit.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/mem_wrap.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/mul_div.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/inst_mem.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/ROM.v" 
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_core.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_decipher_block.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_encipher_block.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_inv_sbox.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_key_mem.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_sbox.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/ctrl.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/aes_top.v"
`include 	"/home/younis/caravel/caravel_user_project/verilog/rtl/core/core.v"


/*/////l15/////


`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/common/bram_1r1w_wrapper.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/common/bram_1rw_wrapper.v"

`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_mshr.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_pipeline.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/rf_l15_mesi.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/rf_l15_wmt.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/rf_l15_lruarray.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/rf_l15_lrsc_flag.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_cpxencoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/pcx_buffer.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/pcx_decoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/noc1encoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/noc1buffer.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/noc3encoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/noc3buffer.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/noc2decoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/simplenocbuffer.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_hmc.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_home_encoder.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_csm.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_priority_encoder.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/common/flat_id_to_xy.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/common/xy_to_flat_id.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l15/l15_wrap.v"



/////l2/////

`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_data_(copy).v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_data_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_data_pgen.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_data_ecc.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_decoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_dir_(copy).v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_dir_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_encoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_mshr.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_mshr_decoder.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_mshr_wrap.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe1.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe1_buf_in.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe1_buf_out.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe1_ctrl.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe1_dpath.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe2.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe2_buf_in.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe2_ctrl.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_pipe2_dpath.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_state_(copy).tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_state_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_tag_(copy).v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_tag_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_smc.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_smc_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_config_regs.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_priority_encoder.tmp.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_broadcast_counter.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_broadcast_counter_wrap.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2_amo_alu.v"
`include        "/home/younis/caravel_tutorial/caravel_example/verilog/rtl/l2/l2.v"
*/



