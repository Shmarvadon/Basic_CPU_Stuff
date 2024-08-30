transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/lsu.v}
vlog -vlog01compat -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/system.v}
vlog -vlog01compat -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/memory.v}

vlog -vlog01compat -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 500 ns
