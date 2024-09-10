transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/system.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/memory.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/lsu.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/cpu.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/alu.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/regs.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/pfcu.sv}

vlog -sv -work work +incdir+C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU {C:/Users/harve/Documents/Basic_CPU_Stuff/Basic_CPU/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 200 ns
