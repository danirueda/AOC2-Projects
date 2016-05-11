onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /dma_test/my_DMA/reg_data/clk
add wave -noupdate -label reset /dma_test/my_DMA/reg_data/reset
add wave -noupdate -group regControl -label Din /dma_test/my_DMA/control/Din
add wave -noupdate -group regControl -label Dout /dma_test/my_DMA/control/Dout
add wave -noupdate -group regControl -label load /dma_test/my_DMA/control/load
add wave -noupdate -group numPalabras -label Din /dma_test/my_DMA/num_palabras/Din
add wave -noupdate -group numPalabras -label Dout /dma_test/my_DMA/num_palabras/Dout
add wave -noupdate -group numPalabras -label load /dma_test/my_DMA/num_palabras/load
add wave -noupdate -group RegData -label Din /dma_test/my_DMA/reg_data/Din
add wave -noupdate -group RegData -label Dout /dma_test/my_DMA/reg_data/Dout
add wave -noupdate -group RegData -label load /dma_test/my_DMA/reg_data/load
add wave -noupdate -group UC_DMA -label empezar /dma_test/my_DMA/UC/empezar
add wave -noupdate -group UC_DMA -label fin /dma_test/my_DMA/UC/fin
add wave -noupdate -group UC_DMA -color Orange -label IO_sync /dma_test/my_DMA/UC/IO_sync
add wave -noupdate -group UC_DMA -color Orange -label DMA_sync /dma_test/my_DMA/UC/DMA_sync
add wave -noupdate -group UC_DMA -label L_E /dma_test/my_DMA/UC/L_E
add wave -noupdate -group UC_DMA -label Bus_Req /dma_test/my_DMA/UC/Bus_Req
add wave -noupdate -group UC_DMA -label state /dma_test/my_DMA/UC/state
add wave -noupdate -group UC_DMA -label next_state /dma_test/my_DMA/UC/next_state
add wave -noupdate -group UC_DMA -color White -label DMA_send_data /dma_test/my_DMA/UC/DMA_send_data
add wave -noupdate -group UC_DMA -color White -label DMA_send_addr /dma_test/my_DMA/UC/DMA_send_addr
add wave -noupdate -group UC_DMA -label DMA_Burst /dma_test/my_DMA/UC/DMA_Burst
add wave -noupdate -group UC_DMA -label DMA_wait /dma_test/my_DMA/UC/DMA_wait
add wave -noupdate -group UC_DMA -color Gold -label DMA_IO_RE /dma_test/my_DMA/UC/DMA_IO_RE
add wave -noupdate -group UC_DMA -color Gold -label DMA_IO_WE /dma_test/my_DMA/UC/DMA_IO_WE
add wave -noupdate -group UC_DMA -color Cyan -label DMA_MD_RE /dma_test/my_DMA/UC/DMA_MD_RE
add wave -noupdate -group UC_DMA -color Cyan -label DMA_MD_WE /dma_test/my_DMA/UC/DMA_MD_WE
add wave -noupdate -group UC_DMA -label reset_count /dma_test/my_DMA/UC/reset_count
add wave -noupdate -group UC_DMA -label count_enable /dma_test/my_DMA/UC/count_enable
add wave -noupdate -group UC_DMA -label load_data /dma_test/my_DMA/UC/load_data
add wave -noupdate -group UC_DMA -label update_done /dma_test/my_DMA/UC/update_done
add wave -noupdate -group cont_palabras -label load /dma_test/my_DMA/cont_palabras/load
add wave -noupdate -group cont_palabras -label int_count /dma_test/my_DMA/cont_palabras/int_count
add wave -noupdate -group cont_palabras -color Magenta -label count_enable /dma_test/my_DMA/cont_palabras/count_enable
add wave -noupdate -group cont_palabras -color Magenta -label count /dma_test/my_DMA/cont_palabras/count
add wave -noupdate -group addr_IO -label Din /dma_test/my_DMA/addr_IO/Din
add wave -noupdate -group addr_IO -label Dout /dma_test/my_DMA/addr_IO/Dout
add wave -noupdate -group addr_IO -label load /dma_test/my_DMA/addr_IO/load
add wave -noupdate -expand -group addr_MD -label Din /dma_test/my_DMA/addr_MD/Din
add wave -noupdate -expand -group addr_MD -label Dout /dma_test/my_DMA/addr_MD/Dout
add wave -noupdate -expand -group addr_MD -label load /dma_test/my_DMA/addr_MD/load
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
WaveRestoreZoom {0 ns} {126 ns}
