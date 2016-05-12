onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/uut/pc/clk
add wave -noupdate -label reset /testbench/uut/pc/reset
add wave -noupdate -expand -group {Banco IF/ID} -label IR_in /testbench/uut/Banco_IF_ID/IR_in
add wave -noupdate -expand -group {Banco IF/ID} -label IR_ID /testbench/uut/Banco_IF_ID/IR_ID
add wave -noupdate -group {Banco EX/MEM} -label op_code_EX /testbench/uut/Banco_EX_MEM/op_code_EX
add wave -noupdate -group {Banco EX/MEM} -label op_code_MEM /testbench/uut/Banco_EX_MEM/op_code_MEM
add wave -noupdate -label Register_bank/reg_file /testbench/uut/Register_bank/reg_file
add wave -noupdate -label MEM_STALL /testbench/uut/MD_IO/MEM_STALL
add wave -noupdate -group Bus -color Magenta -label Bus_data /testbench/uut/MD_IO/Controlador_DMA/Bus_data
add wave -noupdate -group Bus -color {Medium Orchid} -label Bus_addr /testbench/uut/MD_IO/Controlador_DMA/Bus_addr
add wave -noupdate -group MD_cont -label Bus_BURST /testbench/uut/MD_IO/controlador_MD/Bus_BURST
add wave -noupdate -group MD_cont -label Bus_RE /testbench/uut/MD_IO/controlador_MD/Bus_RE
add wave -noupdate -group MD_cont -label Bus_WAIT /testbench/uut/MD_IO/controlador_MD/Bus_WAIT
add wave -noupdate -group MD_cont -label Bus_WE /testbench/uut/MD_IO/controlador_MD/Bus_WE
add wave -noupdate -group MD_cont -color {Medium Orchid} -label Bus_addr /testbench/uut/MD_IO/controlador_MD/Bus_addr
add wave -noupdate -group MD_cont -color Magenta -label Bus_data /testbench/uut/MD_IO/controlador_MD/Bus_data
add wave -noupdate -group MD_cont -label MD_send_data /testbench/uut/MD_IO/controlador_MD/MD_send_data
add wave -noupdate -group MD_cont -label cuenta_palabras /testbench/uut/MD_IO/controlador_MD/cuenta_palabras
add wave -noupdate -group MD -label ADDR /testbench/uut/MD_IO/controlador_MD/MD/ADDR
add wave -noupdate -group MD -label RAM /testbench/uut/MD_IO/controlador_MD/MD/RAM
add wave -noupdate -group MD -label Dout /testbench/uut/MD_IO/controlador_MD/MD/Dout
add wave -noupdate -group MD -label RE /testbench/uut/MD_IO/controlador_MD/MD/RE
add wave -noupdate -group MD -label WE /testbench/uut/MD_IO/controlador_MD/MD/WE
add wave -noupdate -group UC_DMA -label empezar /testbench/uut/MD_IO/Controlador_DMA/UC/empezar
add wave -noupdate -group UC_DMA -label fin /testbench/uut/MD_IO/Controlador_DMA/UC/fin
add wave -noupdate -group UC_DMA -label Bus_Req /testbench/uut/MD_IO/Controlador_DMA/UC/Bus_Req
add wave -noupdate -group UC_DMA -label L_E /testbench/uut/MD_IO/Controlador_DMA/UC/L_E
add wave -noupdate -group UC_DMA -label state /testbench/uut/MD_IO/Controlador_DMA/UC/state
add wave -noupdate -group UC_DMA -label next_state /testbench/uut/MD_IO/Controlador_DMA/UC/next_state
add wave -noupdate -group UC_DMA -label DMA_Burst /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_Burst
add wave -noupdate -group UC_DMA -label DMA_IO_RE /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_IO_RE
add wave -noupdate -group UC_DMA -label DMA_IO_WE /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_IO_WE
add wave -noupdate -group UC_DMA -label DMA_MD_RE /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_MD_RE
add wave -noupdate -group UC_DMA -label DMA_MD_WE /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_MD_WE
add wave -noupdate -group UC_DMA -label DMA_send_addr /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_send_addr
add wave -noupdate -group UC_DMA -label DMA_send_data /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_send_data
add wave -noupdate -group UC_DMA -color {Orange Red} -label DMA_sync /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_sync
add wave -noupdate -group UC_DMA -color {Orange Red} -label IO_sync /testbench/uut/MD_IO/Controlador_DMA/UC/IO_sync
add wave -noupdate -group UC_DMA -label DMA_wait /testbench/uut/MD_IO/Controlador_DMA/UC/DMA_wait
add wave -noupdate -group UC_DMA -label count_enable /testbench/uut/MD_IO/Controlador_DMA/UC/count_enable
add wave -noupdate -group UC_DMA -label load_data /testbench/uut/MD_IO/Controlador_DMA/UC/load_data
add wave -noupdate -group UC_DMA -label reset_count /testbench/uut/MD_IO/Controlador_DMA/UC/reset_count
add wave -noupdate -group UC_DMA -label update_done /testbench/uut/MD_IO/Controlador_DMA/UC/update_done
add wave -noupdate -group InfoTransferDMA -label DMA/num_palabras/Dout /testbench/uut/MD_IO/Controlador_DMA/num_palabras/Dout
add wave -noupdate -group InfoTransferDMA -label addr_IO/Dout /testbench/uut/MD_IO/Controlador_DMA/addr_IO/Dout
add wave -noupdate -group InfoTransferDMA -label addr_MD/Dout /testbench/uut/MD_IO/Controlador_DMA/addr_MD/Dout
add wave -noupdate -group InfoTransferDMA -label DMA/cont_palabras/count /testbench/uut/MD_IO/Controlador_DMA/cont_palabras/count
add wave -noupdate -group InfoTransferDMA -label DMA/control/Dout /testbench/uut/MD_IO/Controlador_DMA/control/Dout
add wave -noupdate -expand -group DMA/reg_data -label Dout /testbench/uut/MD_IO/Controlador_DMA/reg_data/Dout
add wave -noupdate -expand -group DMA/reg_data -label load /testbench/uut/MD_IO/Controlador_DMA/reg_data/load
add wave -noupdate -group IO -label ADDR /testbench/uut/MD_IO/IO/ADDR
add wave -noupdate -group IO -color {Orange Red} -label DMA_sync /testbench/uut/MD_IO/IO/DMA_sync
add wave -noupdate -group IO -color {Orange Red} -label IO_sync /testbench/uut/MD_IO/IO/IO_sync
add wave -noupdate -group IO -label RAM /testbench/uut/MD_IO/IO/RAM
add wave -noupdate -group IO -label RE /testbench/uut/MD_IO/IO/RE
add wave -noupdate -group IO -label WE /testbench/uut/MD_IO/IO/WE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {489 ns} 0}
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
WaveRestoreZoom {491 ns} {564 ns}
