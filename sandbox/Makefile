all: sim

comp:
	vlog -sv -suppress 2223 -suppress 2286    +define+UVM_REPORT_DISABLE_FILE_LINE +define+UVM_REPORT_DISABLE_FILE_LINE $(TEST)

elab:
	vopt top    -o optimized_batch_top_tb
	vopt    +acc top    -o optimized_debug_top_tb

sim: comp elab
	vsim -c -sv_seed random "+UVM_TESTNAME=test_top" -permit_unmatched_virtual_intf "+notimingchecks" -suppress 8887 -solvefaildebug -solvefailtestcase -uvmcontrol=none -printsimstats -do " coverage save -onexit test_top.ucdb; set IterationLimit 140000; set NoQuitOnFinish 1;   run -all; quit -f;" optimized_batch_top_tb

sim_debug: comp elab
	#vsim -i    -sv_seed random +UVM_TESTNAME=test_top  -permit_unmatched_virtual_intf +notimingchecks -suppress 8887 -solvefaildebug -solvefailtestcase  -assertdebug -uvmcontrol=all +uvm_set_config_int=*,enable_transaction_viewing,1 -classdebug -title test_top -msgmode tran   -do " set NoQuitOnFinish 1; run 0; do wave.do "  optimized_debug_top_tb
	vsim -i    -sv_seed random +UVM_TESTNAME=test_top  -permit_unmatched_virtual_intf +notimingchecks -suppress 8887 -solvefaildebug -solvefailtestcase  -assertdebug -uvmcontrol=all +uvm_set_config_int=*,enable_transaction_viewing,1 -classdebug -title test_top -msgmode tran   -do " set NoQuitOnFinish 1; run 0; do wave.do "  optimized_debug_top_tb
