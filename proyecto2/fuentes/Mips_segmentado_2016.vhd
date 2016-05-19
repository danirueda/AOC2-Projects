----------------------------------------------------------------------------------
-- Company: Unizar
-- Engineer: Daniel Rueda Macias
-- Description: Mips segmentado tal y como lo hemos estudiado en clase. Sus características son:
-- Saltos 1-retardados
-- instrucciones aritméticas, LW, SW y BEQ
-- MI y MD de 128 palabras de 32 bits
-- Registro de salida de 32 bits mapeado en la dirección FFFFFFFF. Si haces un SW en esa dirección se escribe en este registro y no en la memoria
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPs_segmentado is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  output : out  STD_LOGIC_VECTOR (31 downto 0));
end MIPs_segmentado;

architecture Behavioral of MIPs_segmentado is
component reg32 is
    Port ( Din : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
		   reset : in  STD_LOGIC;
           load : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
---------------------------------------------------------------
-- Predictor de saltos
component branch_predictor is
 Port ( 	clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
 			-- Puerto de lectura se accede con los 8 bits menos significativos de PC+4 sumado en IF
			PC4 : in  STD_LOGIC_VECTOR (7 downto 0);  
			branch_address_out : out  STD_LOGIC_VECTOR (31 downto 0); -- dirección de salto
			prediction_out : out  STD_LOGIC; -- indica si hay que saltar a la dirección de salto (1) o no (0)
         	-- Puerto de escritura se envía PC+4, la dirección de salto y la predicción, y se activa la señal update_prediction
			PC4_ID:  in  STD_LOGIC_VECTOR (7 downto 0); -- Etiqueta: 8 bits menos significativos del PC+4 de la etapa ID
			prediction_in : in  STD_LOGIC; -- predicción
			branch_address_in : in  STD_LOGIC_VECTOR (31 downto 0); -- dirección de salto
       		update:  in  STD_LOGIC); -- da la orden de actualizar la información del predictor
end component;
--------------------------------------------------------------
component adder32 is
    Port ( Din0 : in  STD_LOGIC_VECTOR (31 downto 0);
           Din1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux2_1 is
  Port (   DIn0 : in  STD_LOGIC_VECTOR (31 downto 0);
           DIn1 : in  STD_LOGIC_VECTOR (31 downto 0);
		   ctrl : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux4_32bits is --mux del pc
Port (   --Entradas
     DIn0 : in  STD_LOGIC_VECTOR (31 downto 0);
         DIn1 : in  STD_LOGIC_VECTOR (31 downto 0);
         DIn2 : in STD_LOGIC_VECTOR (31 downto 0);
         DIn3 : in STD_LOGIC_VECTOR (31 downto 0);
     ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
     --Salidas
         Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MD_mas_I_O is port (
		  CLK : in std_logic;
          reset: in std_logic; -- sólo resetea el controlador de DMA
          ADDR : in std_logic_vector (31 downto 0); --Dir 
          Din : in std_logic_vector (31 downto 0);--entrada de datos desde el Mips
          WE : in std_logic;        -- write enable del MIPS
          RE : in std_logic;        -- read enable del MIPS 
          MEM_STALL: out std_logic; --señal de parada por riesgo estructural en la etapa MEM      
          Dout : out std_logic_vector (31 downto 0)); --salida que puede leer el MIPS
end component;

component memoriaRAM_I is port (
		  CLK : in std_logic;
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
          Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          WE : in std_logic;		-- write enable	
		  RE : in std_logic;		-- read enable		  
		  Dout : out std_logic_vector (31 downto 0));
end component;

component Banco_ID is
 Port (  IR_in : in  STD_LOGIC_VECTOR (31 downto 0); -- instrucción leida en IF
         PC4_in:  in  STD_LOGIC_VECTOR (31 downto 0); -- PC+4 sumado en IF
         branch_address_out: in STD_LOGIC_VECTOR (31 downto 0);
         prediction_out_in: in STD_LOGIC;
		 clk : in  STD_LOGIC;
		 reset : in  STD_LOGIC;
         load : in  STD_LOGIC;
         prediction_out_ID: out STD_LOGIC;
         branch_address_out_ID: out STD_LOGIC_VECTOR (31 downto 0);
         IR_ID : out  STD_LOGIC_VECTOR (31 downto 0); -- instrucción en la etapa ID
         PC4_ID:  out  STD_LOGIC_VECTOR (31 downto 0)); -- PC+4 en la etapa ID
end component;

COMPONENT BReg
    PORT(
         clk : IN  std_logic;
		 reset : in  STD_LOGIC;
         RA : IN  std_logic_vector(4 downto 0);
         RB : IN  std_logic_vector(4 downto 0);
         RW : IN  std_logic_vector(4 downto 0);
         BusW : IN  std_logic_vector(31 downto 0);
         RS : in std_logic_vector (4 downto 0); --Dir para el puerto de escritura de RS en las pre-incremento
         BusRS : in std_logic_vector (31 downto 0);--entrada de datos para las instrucciones pre-incremento
         RegWrite : IN  std_logic;
         Update_Rs : in std_logic;--senial de control para la escritura de RS en las instrucciones pre-incremento
         BusA : OUT  std_logic_vector(31 downto 0);
         BusB : OUT  std_logic_vector(31 downto 0)
        );
END COMPONENT;

component Ext_signo is
    Port ( inm : in  STD_LOGIC_VECTOR (15 downto 0);
           inm_ext : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component two_bits_shifter is
    Port ( Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component UC is
    Port ( IR_op_code : in  STD_LOGIC_VECTOR (5 downto 0);
           Branch : out  STD_LOGIC;
           RegDst : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           Update_Rs : out STD_LOGIC);
end component;

COMPONENT Banco_EX
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         load : IN  std_logic;
         busA : IN  std_logic_vector(31 downto 0);
         busB : IN  std_logic_vector(31 downto 0);
         busA_EX : OUT  std_logic_vector(31 downto 0);
         busB_EX : OUT  std_logic_vector(31 downto 0);
		 inm_ext: IN  std_logic_vector(31 downto 0);
		 inm_ext_EX: OUT  std_logic_vector(31 downto 0);
         RegDst_ID : IN  std_logic;
         ALUSrc_ID : IN  std_logic;
         MemWrite_ID : IN  std_logic;
         MemRead_ID : IN  std_logic;
         MemtoReg_ID : IN  std_logic;
         RegWrite_ID : IN  std_logic;
         RegDst_EX : OUT  std_logic;
         ALUSrc_EX : OUT  std_logic;
         MemWrite_EX : OUT  std_logic;
         MemRead_EX : OUT  std_logic;
         MemtoReg_EX : OUT  std_logic;
         RegWrite_EX : OUT  std_logic;
		 ALUctrl_ID: in STD_LOGIC_VECTOR (2 downto 0);
		 ALUctrl_EX: out STD_LOGIC_VECTOR (2 downto 0);
         RS_ID : in STD_LOGIC_VECTOR (4 downto 0);
         RS_EX : out STD_LOGIC_VECTOR (4 downto 0);
         Update_Rs_ID : in STD_LOGIC;
         Update_Rs_EX : out STD_LOGIC;
         Reg_Rt_ID : IN  std_logic_vector(4 downto 0);
         Reg_Rd_ID : IN  std_logic_vector(4 downto 0);
         Reg_Rt_EX : OUT  std_logic_vector(4 downto 0);
         Reg_Rd_EX : OUT  std_logic_vector(4 downto 0);
         op_code_ID : in STD_LOGIC_VECTOR (5 downto 0);
         op_code_EX : out STD_LOGIC_VECTOR (5 downto 0)
        );
    END COMPONENT;

    COMPONENT ALU
    PORT(
         DA : IN  std_logic_vector(31 downto 0);
         DB : IN  std_logic_vector(31 downto 0);
         ALUctrl : IN  std_logic_vector(2 downto 0);
         Dout : OUT  std_logic_vector(31 downto 0)
               );
    END COMPONENT;
	 
	 component mux2_5bits is
		  Port (   DIn0 : in  STD_LOGIC_VECTOR (4 downto 0);
				   DIn1 : in  STD_LOGIC_VECTOR (4 downto 0);
				   ctrl : in  STD_LOGIC;
				   Dout : out  STD_LOGIC_VECTOR (4 downto 0));
		end component;
	
COMPONENT Banco_MEM
    PORT(
         ALU_out_EX : IN  std_logic_vector(31 downto 0);
         ALU_out_MEM : OUT  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         load : IN  std_logic;
         MemWrite_EX : IN  std_logic;
         MemRead_EX : IN  std_logic;
         MemtoReg_EX : IN  std_logic;
         RegWrite_EX : IN  std_logic;
         MemWrite_MEM : OUT  std_logic;
         MemRead_MEM : OUT  std_logic;
         MemtoReg_MEM : OUT  std_logic;
         RegWrite_MEM : OUT  std_logic;
         BusB_EX : IN  std_logic_vector(31 downto 0);
         BusB_MEM : OUT  std_logic_vector(31 downto 0);
         RS_EX : in STD_LOGIC_VECTOR (4 downto 0);
         RS_MEM : out STD_LOGIC_VECTOR (4 downto 0);
         Update_Rs_EX : in STD_LOGIC;
         Update_Rs_MEM : out STD_LOGIC;
         RW_EX : IN  std_logic_vector(4 downto 0);
         RW_MEM : OUT  std_logic_vector(4 downto 0);
         op_code_EX : in STD_LOGIC_VECTOR (5 downto 0);
         op_code_MEM : out STD_LOGIC_VECTOR (5 downto 0)
        );
    END COMPONENT;
 
    COMPONENT Banco_WB
    PORT(
         ALU_out_MEM : IN  std_logic_vector(31 downto 0);
         ALU_out_WB : OUT  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         MDR : OUT  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         load : IN  std_logic;
         MemtoReg_MEM : IN  std_logic;
         RegWrite_MEM : IN  std_logic;
         MemtoReg_WB : OUT  std_logic;
         RegWrite_WB : OUT  std_logic;
         RW_MEM : IN  std_logic_vector(4 downto 0);
         RW_WB : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT; 

signal load_PC, salto, RegWrite_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB, Z, Branch, RegDst_ID, RegDst_EX, ALUSrc_ID, ALUSrc_EX: std_logic;
signal MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB, MemWrite_ID, MemWrite_EX, MemWrite_MEM, MemRead_ID, MemRead_EX, MemRead_MEM, MEM_STALL: std_logic;
signal Update_Rs_ID, Update_Rs_EX, Update_Rs_MEM: std_logic;
signal PC_in, PC_out, four, PC4, Dirsalto_ID, IR_in, IR_ID, PC4_ID, inm_ext_EX, Mux_out : std_logic_vector(31 downto 0);
signal BusW, BusA, BusB, BusA_EX, BusB_EX, BusB_MEM, inm_ext, inm_ext_x4, ALU_out_EX, ALU_out_MEM, ALU_out_WB, Mem_out, MDR : std_logic_vector(31 downto 0);
signal RW_EX, RW_MEM, RW_WB, Reg_Rd_EX, Reg_Rt_EX, RS_EX, RS_MEM: std_logic_vector(4 downto 0);
signal ALUctrl_ID, ALUctrl_EX : std_logic_vector(2 downto 0);
signal riesgo_rs_ex, riesgo_rs_mem, riesgo_rs_pre, riesgo_rt_ex, riesgo_rt_mem, riesgo_rt_pre, riesgo_datos: std_logic; --Seniales para controlar los riesgos de datos
signal riesgo_bus, riesgo_lw, riesgo_sw, riesgo_lw_pre, riesgo_sw_pre : std_logic;
signal op_code_ID, op_code_EX, op_code_MEM : std_logic_vector(31 downto 26);
signal prediction_out, prediction_in, update_predictor, prediction_out_ID: std_logic;
signal branch_address_in, branch_address_out, branch_address_out_ID, instruction_in: std_logic_vector(31 downto 0); --seniales para el predictor
signal controlMuxPC: STD_LOGIC_VECTOR (1 downto 0);
signal error_saltos, error_salto_noSalto, error_noSalto_salto, hayError: std_logic; --errores en el predictor
signal load_ID_EX, load_EX_MEM : std_logic;
signal RegWrite_to_WB, Update_Rs: std_logic;
begin
pc: reg32 port map (Din => PC_in, clk => clk, reset => reset, load => load_PC, Dout => PC_out);
------------------------------------------------------------------------------------
--Control de las señales de load
load_PC <= '1' when (riesgo_datos = '0' and riesgo_bus = '0') else '0'; --PC avanza si no hay riesgos ni de datos ni de bus, si los hay para.
load_ID_EX <= '1' when (riesgo_bus = '0') else '0';
load_EX_MEM <= '1' when (riesgo_bus = '0') else '0';
------------------------------------------------------------------------------------
four <= "00000000000000000000000000000100";

adder_4: adder32 port map (Din0 => PC_out, Din1 => four, Dout => PC4);
------------------------------------------------------------------------------------
-- Predictor de saltos
update_predictor <= '1' when (prediction_out_ID /= salto) else '0';

predictor: branch_predictor port map (clk => clk, reset => reset ,PC4 => PC4(9 downto 2) , PC4_ID => PC4_ID(9 downto 2),
    branch_address_in => branch_address_in, prediction_in => salto, prediction_out => prediction_out, 
    branch_address_out => branch_address_out, update => update_predictor);
------------------------------------------------------------------------------------

muxPC: mux4_32bits port map (DIn0 => PC4, DIn1 => branch_address_out, DIn2 => PC4_ID, DIn3 => Dirsalto_ID, ctrl => controlMuxPC, Dout => PC_in);

--Casos de error
error_noSalto_salto <= '1' when (prediction_out_ID = '0' and salto = '1') else '0';  --que en F me digan que no salte y en D me digan que salte
error_salto_noSalto <= '1' when (prediction_out_ID = '1' and salto = '0') else '0'; --que en F me digan que salte y en D que no salte
error_saltos <= '1' when (prediction_out_ID = '1' and salto = '1' and Dirsalto_ID /= branch_address_out_ID) else '0'; --que en F me digan que salto, que en D me digan que salto y que las direcciones de salto no coincidan

hayError <= '1' when (error_noSalto_salto = '1' or error_salto_noSalto = '1' or error_noSalto_salto = '1') else '0';

controlMuxPC <= "00" when (prediction_out = '0' and hayError = '0') else 
"01" when (prediction_out = '1' and hayError = '0') else 
"10" when (error_salto_noSalto = '1') else
"11" when (error_noSalto_salto = '1' or error_saltos = '1');

branch_address_in <= Dirsalto_ID when (error_noSalto_salto = '1' or error_saltos = '1') else PC4_ID;



Mem_I: memoriaRAM_I PORT MAP (CLK => CLK, ADDR => PC_out, Din => "00000000000000000000000000000000", WE => '0', RE => '1', Dout => IR_in);


instruction_in <= "00000000000000000000000000000000" when (update_predictor = '1') else IR_in; --si hay fallo del predictor metemos nops
--El banco sigue sacando datos si load_PC no ha parado
Banco_IF_ID: Banco_ID port map (IR_in => instruction_in, PC4_in => PC4, clk => clk, reset => reset, load => load_PC, IR_ID => IR_ID, PC4_ID => PC4_ID,
    prediction_out_in => prediction_out,  prediction_out_ID => prediction_out_ID, branch_address_out_ID => branch_address_out_ID, branch_address_out => branch_address_out);

------------------------------------------Etapa ID-------------------------------------------------------------------

Register_bank: BReg PORT MAP (clk => clk, reset => reset, RA => IR_ID(25 downto 21), RB => IR_ID(20 downto 16), RW => RW_WB, BusW => BusW, 
									RegWrite => RegWrite_WB, BusA => BusA, BusB => BusB, RS => RS_MEM, BusRS => ALU_out_MEM, Update_Rs => Update_Rs);
-------------------------------------------------------------------------------------
sign_ext: Ext_signo port map (inm => IR_ID(15 downto 0), inm_ext => inm_ext);

two_bits_shift: two_bits_shifter	port map (Din => inm_ext, Dout => inm_ext_x4);

adder_dir: adder32 port map (Din0 => inm_ext_x4, Din1 => PC4_ID, Dout => Dirsalto_ID);

Z <= '1' when (busA=busB) else '0';

------------------------gestión de la parada en ID-----------------------------------
--Gestión de riesgos de datos

--riesgos en rs
riesgo_rs_ex <= '1' when (RegWrite_EX = '1' AND RW_EX = IR_ID(25 downto 21)) else '0';
riesgo_rs_mem <= '1' when (RegWrite_MEM = '1' AND RW_MEM = IR_ID(25 downto 21)) else '0';
riesgo_rs_pre <= '1' when (Update_Rs_EX = '1' AND RS_EX = IR_ID(25 downto 21)) else '0';

--riesgos en rt
riesgo_rt_ex <= '1' when (RegWrite_EX = '1' AND RW_EX = IR_ID(20 downto 16) and not(IR_ID(31 downto 26)="000010") and not(IR_ID(31 downto 26)="000110")) else '0';
riesgo_rt_mem <= '1' when (RegWrite_MEM = '1' AND RW_MEM = IR_ID(20 downto 16) and not(IR_ID(31 downto 26)="000010") and not(IR_ID(31 downto 26)="000110")) else '0';
riesgo_rt_pre <= '1' when (Update_Rs_EX = '1' AND RS_EX = IR_ID(20 downto 16) and not(IR_ID(31 downto 26)="000010") and not(IR_ID(31 downto 26)="000110")) else '0';

riesgo_datos <= '1' when (riesgo_rs_ex = '1' OR riesgo_rs_mem = '1' OR riesgo_rs_pre = '1' OR riesgo_rt_ex = '1' OR
riesgo_rt_mem = '1' OR riesgo_rt_pre = '1') AND IR_ID(31 downto 26) /= "000000"  else '0'; --se activan riesgos si hay algun riesgo y la instruccion no es un NOP



op_code_ID <= "000000" when riesgo_datos = '1' else IR_ID(31 downto 26);




UC_seg: UC port map (IR_op_code => op_code_ID, Branch => Branch, RegDst => RegDst_ID,  ALUSrc => ALUSrc_ID, MemWrite => MemWrite_ID,  
							MemRead => MemRead_ID, MemtoReg => MemtoReg_ID, RegWrite => RegWrite_ID, Update_Rs => Update_Rs_ID);


salto <= Branch AND Z; 				
-- si la operación es aritmética (es decir: IR_ID(31 downto 26)= "000001") miro el campo funct
-- como sólo hay 4 operaciones en la alu, basta con los bits menos significativos del campo func de la instrucción	
-- si no es aritmética le damos el valor de la suma (000)
ALUctrl_ID <= IR_ID(2 downto 0) when IR_ID(31 downto 26)= "000001" else "000"; 
-- hay que añadir los campos necesarios a los registros intermedios
Banco_ID_EX: Banco_EX PORT MAP ( clk => clk, reset => reset, load => load_ID_EX, busA => busA, busB => busB, busA_EX => busA_EX, busB_EX => busB_EX,
											RegDst_ID => RegDst_ID, ALUSrc_ID => ALUSrc_ID, MemWrite_ID => MemWrite_ID, MemRead_ID => MemRead_ID,
											MemtoReg_ID => MemtoReg_ID, RegWrite_ID => RegWrite_ID, RegDst_EX => RegDst_EX, ALUSrc_EX => ALUSrc_EX,
											MemWrite_EX => MemWrite_EX, MemRead_EX => MemRead_EX, MemtoReg_EX => MemtoReg_EX, RegWrite_EX => RegWrite_EX,
											ALUctrl_ID => ALUctrl_ID, ALUctrl_EX => ALUctrl_EX, inm_ext => inm_ext, inm_ext_EX=> inm_ext_EX,
											Reg_Rt_ID => IR_ID(20 downto 16), Reg_Rd_ID => IR_ID(15 downto 11), Reg_Rt_EX => Reg_Rt_EX, Reg_Rd_EX => Reg_Rd_EX,
                      RS_ID => IR_ID(25 downto 21), RS_EX => RS_EX, Update_Rs_ID => Update_Rs_ID, Update_Rs_EX => Update_Rs_EX, op_code_ID => op_code_ID, op_code_EX => op_code_EX);			
							
--
------------------------------------------Etapa EX-------------------------------------------------------------------
--

muxALU_src: mux2_1 port map (Din0 => busB_EX, DIn1 => inm_ext_EX, ctrl => ALUSrc_EX, Dout => Mux_out);

ALU_MIPs: ALU PORT MAP ( DA => BusA_EX, DB => Mux_out, ALUctrl => ALUctrl_EX, Dout => ALU_out_EX);

mux_dst: mux2_5bits port map (Din0 => Reg_Rt_EX, DIn1 => Reg_Rd_EX, ctrl => RegDst_EX, Dout => RW_EX);

Banco_EX_MEM: Banco_MEM PORT MAP ( ALU_out_EX => ALU_out_EX, ALU_out_MEM => ALU_out_MEM, clk => clk, reset => reset, load => load_EX_MEM, MemWrite_EX => MemWrite_EX,
												MemRead_EX => MemRead_EX, MemtoReg_EX => MemtoReg_EX, RegWrite_EX => RegWrite_EX, MemWrite_MEM => MemWrite_MEM, MemRead_MEM => MemRead_MEM,
												MemtoReg_MEM => MemtoReg_MEM, RegWrite_MEM => RegWrite_MEM, BusB_EX => BusB_EX, BusB_MEM => BusB_MEM, RW_EX => RW_EX, RW_MEM => RW_MEM,
                        RS_EX => RS_EX, RS_MEM => RS_MEM, Update_Rs_EX => Update_Rs_EX, Update_Rs_MEM => Update_Rs_MEM, op_code_EX => op_code_EX, op_code_MEM => op_code_MEM);
--
------------------------------------------Etapa MEM-------------------------------------------------------------------
--

--Riesgos de bus
riesgo_lw <= '1' when (MEM_STALL = '1' and op_code_MEM = "000010") else '0'; --Si mem_stall está a 1 y la instrucción en MEM es un LW
riesgo_sw <= '1' when (MEM_STALL = '1' and op_code_MEM = "000011") else '0'; --Si mem_stall está a 1 y la instrucción en MEM es un SW
riesgo_lw_pre <= '1' when (MEM_STALL = '1' and op_code_MEM = "000110") else '0'; --Si mem_stall está a 1 y la instrucción en MEM es un LW_pre
riesgo_sw_pre <= '1' when (MEM_STALL = '1' and op_code_MEM = "000111") else '0'; --Si mem_stall está a 1 y la instrucción en MEM es un SW_pre

--Si se activa alguno de los riesgos anteriores se activa el riesgo_bus.
riesgo_bus <= '1' when (riesgo_lw = '1' or riesgo_sw = '1' or riesgo_lw_pre = '1' or riesgo_sw_pre = '1') else '0';

RegWrite_to_WB <= '0' when (riesgo_bus = '1') else RegWrite_MEM;
Update_Rs <= '0' when (riesgo_bus = '1') else Update_Rs_MEM;

MD_IO: MD_mas_I_O PORT MAP (CLK => CLK, ADDR => ALU_out_MEM, Din => BusB_MEM, WE => MemWrite_MEM, RE => MemRead_MEM, MEM_STALL => MEM_STALL,
 Dout => Mem_out, reset => reset);

Banco_MEM_WB: Banco_WB PORT MAP ( ALU_out_MEM => ALU_out_MEM, ALU_out_WB => ALU_out_WB, Mem_out => Mem_out, MDR => MDR, clk => clk, reset => reset, load => '1', MemtoReg_MEM => MemtoReg_MEM, RegWrite_MEM => RegWrite_to_WB, 
											MemtoReg_WB => MemtoReg_WB, RegWrite_WB => RegWrite_WB, RW_MEM => RW_MEM, RW_WB => RW_WB);
mux_busW: mux2_1 port map (Din0 => ALU_out_WB, DIn1 => MDR, ctrl => MemtoReg_WB, Dout => busW);


--
--------------------------------------Etapa WB--------------------------------------------------------------------
--
output <= IR_ID;
end Behavioral;

