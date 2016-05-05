----------------------------------------------------------------------------------
-- Company: Unizar
-- Engineer: Daniel Rueda Macias
-- 
-- Create Date:    14:46:01 04/07/2014 
-- Design Name: 
-- Module Name:    Banco_ID - Behavioral 
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
----------------------------------------------------------------------------------
-- Description: Banco de registros que separa las etapas IF e ID. Almacena la instrucción en IR_ID y el PC+4 en PC4_ID
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Banco_ID is
 Port ( 	IR_in : in  STD_LOGIC_VECTOR (31 downto 0); -- instrucción leida en IF
         PC4_in:  in  STD_LOGIC_VECTOR (31 downto 0); -- PC+4 sumado en IF
         branch_address_out: in STD_LOGIC_VECTOR (31 downto 0);
         prediction_out_in: in STD_LOGIC;
			clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
         load : in  STD_LOGIC;
         IR_ID : out  STD_LOGIC_VECTOR (31 downto 0); -- instrucción en la etapa ID
         branch_address_out_ID: out STD_LOGIC_VECTOR (31 downto 0);
         prediction_out_ID: out STD_LOGIC;
         PC4_ID:  out  STD_LOGIC_VECTOR (31 downto 0)); -- PC+4 en la etapa ID
end Banco_ID;

architecture Behavioral of Banco_ID is

begin
SYNC_PROC: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (reset = '1') then
            IR_ID <= "00000000000000000000000000000000";
				PC4_ID <= "00000000000000000000000000000000";
            prediction_out_ID <= '0';
            branch_address_out_ID <= "00000000000000000000000000000000";
         else
            if (load='1') then 
					IR_ID <= IR_in;
					PC4_ID <= PC4_in;
               prediction_out_ID <= prediction_out_in;
               branch_address_out_ID <= branch_address_out;
				end if;	
         end if;        
      end if;
   end process;

end Behavioral;

