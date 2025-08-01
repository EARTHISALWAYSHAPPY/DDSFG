onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Testbench/Ext_RESETn
add wave -noupdate /Testbench/ExtBtn
add wave -noupdate /Testbench/Ext_Clk
add wave -noupdate /Testbench/Ext_Rot_A
add wave -noupdate /Testbench/Ext_Rot_B
add wave -noupdate /Testbench/Ext_Btn_Rot_C
add wave -noupdate /Testbench/Dac_Clk
add wave -noupdate /Testbench/DDS_Out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
