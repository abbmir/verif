onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/reset_n
add wave -noupdate /top/cache_mem
add wave -noupdate /top/cache_miss
add wave -noupdate /top/main_mem_rd
add wave -noupdate /top/cache_rd
add wave -noupdate /top/rd_addr
add wave -noupdate /top/main_mem_rd_addr
add wave -noupdate /top/random_vector
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {0 ns} {10500 ns}
