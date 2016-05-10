onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /uc_dma_test/U_control_DMA/clk
add wave -noupdate -label reset /uc_dma_test/U_control_DMA/reset
add wave -noupdate -label empezar /uc_dma_test/U_control_DMA/empezar
add wave -noupdate -label fin /uc_dma_test/U_control_DMA/fin
add wave -noupdate -label L_E /uc_dma_test/U_control_DMA/L_E
add wave -noupdate -label Bus_Req /uc_dma_test/U_control_DMA/Bus_Req
add wave -noupdate -expand -group Sincro -color Orange -label DMA_sync /uc_dma_test/U_control_DMA/DMA_sync
add wave -noupdate -expand -group Sincro -color Orange -label IO_sync /uc_dma_test/U_control_DMA/IO_sync
add wave -noupdate -label state /uc_dma_test/U_control_DMA/state
add wave -noupdate -label next_state /uc_dma_test/U_control_DMA/next_state
add wave -noupdate -label DMA_Burst /uc_dma_test/U_control_DMA/DMA_Burst
add wave -noupdate -expand -group IO -color Yellow -label DMA_IO_RE /uc_dma_test/U_control_DMA/DMA_IO_RE
add wave -noupdate -expand -group IO -color Yellow -label DMA_IO_WE /uc_dma_test/U_control_DMA/DMA_IO_WE
add wave -noupdate -expand -group MD -color White -label DMA_MD_RE /uc_dma_test/U_control_DMA/DMA_MD_RE
add wave -noupdate -expand -group MD -color White -label DMA_MD_WE /uc_dma_test/U_control_DMA/DMA_MD_WE
add wave -noupdate -label DMA_send_addr /uc_dma_test/U_control_DMA/DMA_send_addr
add wave -noupdate -label DMA_send_data /uc_dma_test/U_control_DMA/DMA_send_data
add wave -noupdate -label DMA_wait /uc_dma_test/U_control_DMA/DMA_wait
add wave -noupdate -label count_enable /uc_dma_test/U_control_DMA/count_enable
add wave -noupdate -label load_data /uc_dma_test/U_control_DMA/load_data
add wave -noupdate -label reset_count /uc_dma_test/U_control_DMA/reset_count
add wave -noupdate -label update_done /uc_dma_test/U_control_DMA/update_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {113 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {63 ns} {145 ns}
