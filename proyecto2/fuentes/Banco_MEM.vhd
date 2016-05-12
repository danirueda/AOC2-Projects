----------------------------------------------------------------------------------
-- Company: Unizar
-- Engineer: Daniel Rueda Macias
-- 
-- Create Date:    15:28:20 04/07/2014 
-- Design Name: 
-- Module Name:    Banco_MEM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Banco_MEM is
Port ( 	ALU_out_EX : in  STD_LOGIC_VECTOR (31 downto 0); 
			ALU_out_MEM : out  STD_LOGIC_VECTOR (31 downto 0); -- instrucci�n leida en IF
         clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
         load : in  STD_LOGIC;
			MemWrite_EX : in  STD_LOGIC;
         MemRead_EX : in  STD_LOGIC;
         MemtoReg_EX : in  STD_LOGIC;
         RegWrite_EX : in  STD_LOGIC;
			MemWrite_MEM : out  STD_LOGIC;
         MemRead_MEM : out  STD_LOGIC;
         MemtoReg_MEM : out  STD_LOGIC;
         RegWrite_MEM : out  STD_LOGIC;
         BusB_EX: in  STD_LOGIC_VECTOR (31 downto 0); -- para los store
			BusB_MEM: out  STD_LOGIC_VECTOR (31 downto 0); -- para los store
			RS_EX : in STD_LOGIC_VECTOR (4 downto 0);
			RS_MEM : out STD_LOGIC_VECTOR (4 downto 0);
			Update_Rs_EX : in STD_LOGIC;
			Update_Rs_MEM : out STD_LOGIC;
			RW_EX : in  STD_LOGIC_VECTOR (4 downto 0); -- registro destino de la escritura
         RW_MEM : out  STD_LOGIC_VECTOR (4 downto 0); -- PC+4 en la etapa ID
         op_code_EX : in STD_LOGIC_VECTOR (5 downto 0);
		   op_code_MEM : out STD_LOGIC_VECTOR (5 downto 0));
end Banco_MEM;

architecture Behavioral of Banco_MEM is

begin
SYNC_PROC: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (reset = '1') then
            ALU_out_MEM <= "00000000000000000000000000000000";
				BUSB_MEM <= "00000000000000000000000000000000";
				RW_MEM <= "00000";
				MemWrite_MEM <= '0';
				MemRead_MEM <= '0';
				MemtoReg_MEM <= '0';
				RegWrite_MEM <= '0';
				RS_MEM <= "00000";
				Update_Rs_MEM <= '0';
				op_code_MEM <= "000000";
         else
            if (load='1') then 
					ALU_out_MEM <= ALU_out_EX;
					BUSB_MEM <= BUSB_EX;
					RW_MEM <= RW_EX;
					MemWrite_MEM <= MemWrite_EX;
					MemRead_MEM <= MemRead_EX;
					MemtoReg_MEM <= MemtoReg_EX;
					RegWrite_MEM <= RegWrite_EX;
					RS_MEM <= RS_EX;
					Update_Rs_MEM <= Update_Rs_EX;
					op_code_MEM <= op_code_EX;
				end if;	
         end if;        
      end if;
   end process;

end Behavioral;

