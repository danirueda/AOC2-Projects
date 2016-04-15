onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/uut/clk
add wave -noupdate -label reset /testbench/uut/pc/reset
add wave -noupdate -label load /testbench/uut/pc/load
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/DIn0 /testbench/uut/muxPC/DIn0
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/DIn1 /testbench/uut/muxPC/DIn1
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/DIn2 /testbench/uut/muxPC/DIn2
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/DIn3 /testbench/uut/muxPC/DIn3
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/Dout /testbench/uut/muxPC/Dout
add wave -noupdate -expand -group MuxPC -color {Medium Aquamarine} -label muxPC/ctrl /testbench/uut/muxPC/ctrl
add wave -noupdate -expand -group Predictor -label predictor/validez /testbench/uut/predictor/validez
add wave -noupdate -expand -group Predictor -label predictor/prediccion /testbench/uut/predictor/prediccion
add wave -noupdate -expand -group Predictor -label predictor/branch_address_in /testbench/uut/predictor/branch_address_in
add wave -noupdate -expand -group Predictor -label predictor/branch_address_out /testbench/uut/predictor/branch_address_out
add wave -noupdate -expand -group Predictor -label predictor/PC4 /testbench/uut/predictor/PC4
add wave -noupdate -expand -group Predictor -label predictor/dirSalto /testbench/uut/predictor/dirSalto
add wave -noupdate -expand -group Predictor -label predictor/etiqueta /testbench/uut/predictor/etiqueta
add wave -noupdate -expand -group Predictor -label predictor/PC4_ID /testbench/uut/predictor/PC4_ID
add wave -noupdate -expand -group Predictor -label predictor/prediction_in /testbench/uut/predictor/prediction_in
add wave -noupdate -expand -group Predictor -label predictor/prediction_out /testbench/uut/predictor/prediction_out
add wave -noupdate -expand -group Predictor -label predictor/validez /testbench/uut/predictor/validez
add wave -noupdate -expand -group Predictor -label predictor/update /testbench/uut/predictor/update
add wave -noupdate -group pc -label pc/Din /testbench/uut/pc/Din
add wave -noupdate -group pc -label pc/Dout /testbench/uut/pc/Dout
add wave -noupdate -group Mem_I -label Mem_I/ADDR /testbench/uut/Mem_I/ADDR
add wave -noupdate -group Mem_I -label Mem_I/Dout /testbench/uut/Mem_I/Dout
add wave -noupdate -expand -group Banco_IF_ID -color Gold -label Banco_IF_ID/IR_in /testbench/uut/Banco_IF_ID/IR_in
add wave -noupdate -expand -group Banco_IF_ID -color Gold -label Banco_IF_ID/IR_ID /testbench/uut/Banco_IF_ID/IR_ID
add wave -noupdate -group BR -label BR/reg_file /testbench/uut/Register_bank/reg_file
add wave -noupdate -group BR -label BR/RA /testbench/uut/Register_bank/RA
add wave -noupdate -group BR -label BR/RB /testbench/uut/Register_bank/RB
add wave -noupdate -group BR -label BR/Update_Rs /testbench/uut/Register_bank/Update_Rs
add wave -noupdate -group BR -label BR/BusRS /testbench/uut/Register_bank/BusRS
add wave -noupdate -group BR -label BR/RS /testbench/uut/Register_bank/RS
add wave -noupdate -group BR -label BR/RW /testbench/uut/Register_bank/RW
add wave -noupdate -group BR -label BR/BusW /testbench/uut/Register_bank/BusW
add wave -noupdate -group BR -label BR/BusA /testbench/uut/Register_bank/BusA
add wave -noupdate -group BR -label BR/BusB /testbench/uut/Register_bank/BusB
add wave -noupdate -group BR -label BR/RegWrite /testbench/uut/Register_bank/RegWrite
add wave -noupdate -label sign_ext/inm_ext /testbench/uut/sign_ext/inm_ext
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/RegWrite_EX /testbench/uut/Banco_ID_EX/RegWrite_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/RegWrite_ID /testbench/uut/Banco_ID_EX/RegWrite_ID
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/Update_Rs_ID /testbench/uut/Banco_ID_EX/Update_Rs_ID
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/Update_Rs_EX /testbench/uut/Banco_ID_EX/Update_Rs_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/RS_ID /testbench/uut/Banco_ID_EX/RS_ID
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/RS_EX /testbench/uut/Banco_ID_EX/RS_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/busA_EX /testbench/uut/Banco_ID_EX/busA_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/busB_EX /testbench/uut/Banco_ID_EX/busB_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/inm_ext_EX /testbench/uut/Banco_ID_EX/inm_ext_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/ALUctrl_EX /testbench/uut/Banco_ID_EX/ALUctrl_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/Reg_Rt_EX /testbench/uut/Banco_ID_EX/Reg_Rt_EX
add wave -noupdate -group Banco_ID_EX -color Magenta -label Banco_ID_EX/Reg_Rd_EX /testbench/uut/Banco_ID_EX/Reg_Rd_EX
add wave -noupdate -label muxALU_src/ctrl /testbench/uut/muxALU_src/ctrl
add wave -noupdate -group ALU -label ALU_MIPs/ALUctrl /testbench/uut/ALU_MIPs/ALUctrl
add wave -noupdate -group ALU -label ALU_MIPs/Dout /testbench/uut/ALU_MIPs/Dout
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/RS_EX /testbench/uut/Banco_EX_MEM/RS_EX
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/RS_MEM /testbench/uut/Banco_EX_MEM/RS_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/ALU_out_MEM /testbench/uut/Banco_EX_MEM/ALU_out_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/MemWrite_MEM /testbench/uut/Banco_EX_MEM/MemWrite_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/MemRead_MEM /testbench/uut/Banco_EX_MEM/MemRead_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/MemtoReg_MEM /testbench/uut/Banco_EX_MEM/MemtoReg_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/RegWrite_MEM /testbench/uut/Banco_EX_MEM/RegWrite_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/BusB_MEM /testbench/uut/Banco_EX_MEM/BusB_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/RW_MEM /testbench/uut/Banco_EX_MEM/RW_MEM
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/Update_Rs_EX /testbench/uut/Banco_EX_MEM/Update_Rs_EX
add wave -noupdate -group Banco_EX_MEM -color Orange -label Banco_EX_MEM/Update_Rs_MEM /testbench/uut/Banco_EX_MEM/Update_Rs_MEM
add wave -noupdate -group Mem_D -label Mem_D/RAM /testbench/uut/Mem_D/RAM
add wave -noupdate -group Mem_D -label Mem_D/ADDR /testbench/uut/Mem_D/ADDR
add wave -noupdate -group Mem_D -label Mem_D/Din /testbench/uut/Mem_D/Din
add wave -noupdate -group Mem_D -label Mem_D/WE /testbench/uut/Mem_D/WE
add wave -noupdate -group Mem_D -label Mem_D/RE /testbench/uut/Mem_D/RE
add wave -noupdate -group Mem_D -label Mem_D/Dout /testbench/uut/Mem_D/Dout
add wave -noupdate -group Banco_MEM_WB -color {Medium Blue} -label Banco_MEM_WB/ALU_out_WB /testbench/uut/Banco_MEM_WB/ALU_out_WB
add wave -noupdate -group Banco_MEM_WB -color {Medium Blue} -label Banco_MEM_WB/MemtoReg_WB /testbench/uut/Banco_MEM_WB/MemtoReg_WB
add wave -noupdate -group Banco_MEM_WB -color {Medium Blue} -label Banco_MEM_WB/RegWrite_WB /testbench/uut/Banco_MEM_WB/RegWrite_WB
add wave -noupdate -group Banco_MEM_WB -color {Medium Blue} -label Banco_MEM_WB/RW_WB /testbench/uut/Banco_MEM_WB/RW_WB
add wave -noupdate -label mux_busW/ctrl /testbench/uut/mux_busW/ctrl
add wave -noupdate -label mux_busW/Dout /testbench/uut/mux_busW/Dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {402 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
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
WaveRestoreZoom {371 ns} {417 ns}
