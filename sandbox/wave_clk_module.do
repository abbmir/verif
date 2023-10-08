onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/DUT/FREQ
add wave -noupdate /top/DUT/PHASE
add wave -noupdate /top/DUT/DUTY
add wave -noupdate /top/DUT/clock
add wave -noupdate /top/DUT/clk_per
add wave -noupdate /top/DUT/dly
add wave -noupdate /top/DUT/clk_on
add wave -noupdate /top/DUT/clk_off
add wave -noupdate /top/DUT/start_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {105 us}
