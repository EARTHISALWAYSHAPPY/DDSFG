vlog -f Source.f
vlog -f Simulation.f

restart -force
run -all
wave zoom full