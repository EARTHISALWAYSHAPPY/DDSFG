vlog -f Source.f
vlog -f Simulation.f

#---------------------------------------------------------------------------
#Directory path of (PC)

vsim -gui work.Testbench -L D:/Work/ElecEng/Y3/T1/Project_DDSFG/DDSFG_git/DDSFG/Simulation/Modelsim/GowinLibrary

#---------------------------------------------------------------------------
#Directory path of (Notebook)


#---------------------------------------------------------------------------

restart -force
do wave.do
run 20 ms
stop -force
wave zoom full -force