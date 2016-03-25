onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/uut/clk
add wave -noupdate -label reset /testbench/uut/pc/reset
add wave -noupdate -label load /testbench/uut/pc/load
add wave -noupdate -label pc/Din /testbench/uut/pc/Din
add wave -noupdate -label pc/Dout /testbench/uut/pc/Dout
add wave -noupdate -label Mem_I/Dout /testbench/uut/Mem_I/Dout
add wave -noupdate -color Gold -label Banco_IF_ID/IR_ID /testbench/uut/Banco_IF_ID/IR_ID
add wave -noupdate -color Gold -label Banco_IF_ID/PC4_ID /testbench/uut/Banco_IF_ID/PC4_ID
add wave -noupdate -label BR/RA /testbench/uut/Register_bank/RA
add wave -noupdate -label BR/RB /testbench/uut/Register_bank/RB
add wave -noupdate -label BR/RW /testbench/uut/Register_bank/RW
add wave -noupdate -label BR/BusW /testbench/uut/Register_bank/BusW
add wave -noupdate -label BR/BusA /testbench/uut/Register_bank/BusA
add wave -noupdate -label BR/BusB /testbench/uut/Register_bank/BusB
add wave -noupdate -label sign_ext/inm_ext /testbench/uut/sign_ext/inm_ext
add wave -noupdate -color Magenta -label Banco_ID_EX/busA_EX /testbench/uut/Banco_ID_EX/busA_EX
add wave -noupdate -color Magenta -label Banco_ID_EX/busB_EX /testbench/uut/Banco_ID_EX/busB_EX
add wave -noupdate -color Magenta -label Banco_ID_EX/inm_ext_EX /testbench/uut/Banco_ID_EX/inm_ext_EX
add wave -noupdate -color Magenta -label Banco_ID_EX/ALUctrl_EX /testbench/uut/Banco_ID_EX/ALUctrl_EX
add wave -noupdate -color Magenta -label Banco_ID_EX/Reg_Rt_EX /testbench/uut/Banco_ID_EX/Reg_Rt_EX
add wave -noupdate -color Magenta -label Banco_ID_EX/Reg_Rd_EX /testbench/uut/Banco_ID_EX/Reg_Rd_EX
add wave -noupdate -label muxALU_src/ctrl /testbench/uut/muxALU_src/ctrl
add wave -noupdate -label ALU_MIPs/ALUctrl /testbench/uut/ALU_MIPs/ALUctrl
add wave -noupdate -label ALU_MIPs/Dout /testbench/uut/ALU_MIPs/Dout
add wave -noupdate -color Orange -label Banco_EX_MEM/ALU_out_MEM /testbench/uut/Banco_EX_MEM/ALU_out_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/MemWrite_MEM /testbench/uut/Banco_EX_MEM/MemWrite_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/MemRead_MEM /testbench/uut/Banco_EX_MEM/MemRead_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/MemtoReg_MEM /testbench/uut/Banco_EX_MEM/MemtoReg_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/RegWrite_MEM /testbench/uut/Banco_EX_MEM/RegWrite_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/BusB_MEM /testbench/uut/Banco_EX_MEM/BusB_MEM
add wave -noupdate -color Orange -label Banco_EX_MEM/RW_MEM /testbench/uut/Banco_EX_MEM/RW_MEM
add wave -noupdate -label Mem_D/ADDR /testbench/uut/Mem_D/ADDR
add wave -noupdate -label Mem_D/Din /testbench/uut/Mem_D/Din
add wave -noupdate -label Mem_D/WE /testbench/uut/Mem_D/WE
add wave -noupdate -label Mem_D/RE /testbench/uut/Mem_D/RE
add wave -noupdate -label Mem_D/Dout /testbench/uut/Mem_D/Dout
add wave -noupdate -color {Medium Blue} -label Banco_MEM_WB/ALU_out_WB /testbench/uut/Banco_MEM_WB/ALU_out_WB
add wave -noupdate -color {Medium Blue} -label Banco_MEM_WB/MemtoReg_WB /testbench/uut/Banco_MEM_WB/MemtoReg_WB
add wave -noupdate -color {Medium Blue} -label Banco_MEM_WB/RegWrite_WB /testbench/uut/Banco_MEM_WB/RegWrite_WB
add wave -noupdate -color {Medium Blue} -label Banco_MEM_WB/RW_WB /testbench/uut/Banco_MEM_WB/RW_WB
add wave -noupdate -label mux_busW/ctrl /testbench/uut/mux_busW/ctrl
add wave -noupdate -label mux_busW/Dout /testbench/uut/mux_busW/Dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 254
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
WaveRestoreZoom {0 ns} {111 ns}
