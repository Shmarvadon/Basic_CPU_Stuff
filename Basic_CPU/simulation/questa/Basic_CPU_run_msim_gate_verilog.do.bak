transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Basic_CPU.vo}

vlog -vlog01compat -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/testbench.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 500 ns
