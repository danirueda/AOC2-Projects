----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:38:18 05/15/2014 
-- Design Name: 
-- Module Name:    UC_DMA - Behavioral 
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

entity UC_DMA is
     Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          empezar: in  STD_LOGIC;
          fin: in  STD_LOGIC; --
          L_E: in  STD_LOGIC;  -- 0 lees de MD y escribes en IO, 1 viceversa
          Bus_Req: in std_logic; -- solicitud del mips
		  IO_sync: in std_logic; -- señal de sincro con el periférico
		  update_done :out std_logic; --para actualizar el bit done al terminar una transferencia
		  DMA_send_data: out std_logic; -- envío de los datos al bus
		  DMA_send_addr: out std_logic; -- envío de la dirección al bus
		  DMA_Burst: out std_logic; -- señal de modo ráfaga la activa si le piden que transfiera más de 1 palabra
		  DMA_wait: out std_logic; -- señal de espera para la MD
		  reset_count: out std_logic; -- pone el contador a 0
		  count_enable: out std_logic; -- incrementa el contador 
		  load_data: out std_logic; -- carga una plabara de memoria o de IO
		  DMA_MD_RE: out std_logic; -- enable lectura mem
		  DMA_MD_WE: out std_logic; -- enable escritura mem
		  DMA_IO_RE: out std_logic; -- enable lectura IO
		  DMA_IO_WE: out std_logic; -- enable escritura IO
		  DMA_sync: out std_logic -- señal de sincro con el periférico
		  );
end UC_DMA;

architecture Behavioral of UC_DMA is
   type state_type is (inicio, sincro_leerIO, sincro_escribirIO, leerIO, escribirIO) ; 
   signal state, next_state : state_type; 
   
begin
 
 
-- registro de estado (en cada flanco actualiza el estado del controlador)
   SYNC_PROC: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (reset = '1') then
            state <= inicio;
         else
            state <= next_state;
         end if;        
      end if;
   end process;
 
--MEALY State-Machine - Outputs based on state and inputs
   OUTPUT_DECODE: process (state, empezar, fin, L_E, Bus_Req, IO_sync) --lista de sensibilidad
   begin  
       if (state = inicio) then -- si no piden nada no hacemos nada
          if (empezar = '1' and Bus_Req = '0' and L_E = '0') then
          	  update_done <= '0';
			  reset_count <= '1';
			  count_enable <= '0';
			  load_data <= '1';
			  DMA_MD_RE <= '1'; 
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '1'; 
			  DMA_Burst <= '0';
			  DMA_wait <= '0'; 
	          next_state <= sincro_escribirIO;
          elsif (empezar = '1' and L_E = '1') then
          	  update_done <= '0';
			  reset_count <= '1';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '1';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '1';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= sincro_leerIO;
          else
	          update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= inicio;
          end if;  	
       elsif (state = sincro_leerIO) then
			if (IO_sync = '0' and fin = '0') then
			  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '1';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '1';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= sincro_leerIO;
			elsif (IO_sync = '1') then
			  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '1';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '1';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '1';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= leerIO;
	        elsif (fin = '1') then
	          update_done <= '1';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= inicio;
			end if;
       elsif (state = sincro_escribirIO) then
       		if (IO_sync = '0' and fin = '0') then
       		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '1';
			  DMA_sync <= '1';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= sincro_escribirIO;
       		elsif (IO_sync = '1') then
       		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '1';
			  DMA_sync <= '1';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= escribirIO;
	        elsif (fin = '1') then
	          update_done <= '1';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= inicio; 
       		end if;
	   elsif (state = leerIO) then
	   		if (IO_sync = '1' or Bus_Req = '1') then
	   		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= leerIO;
	   		elsif (IO_sync = '0' and Bus_Req = '0') then 
	   		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '1';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '1';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '1';
			  DMA_send_addr <= '1';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= sincro_leerIO;
	   		end if;
	   elsif (state = escribirIO) then
	   		if (IO_sync = '1' or Bus_Req = '1') then
	   		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '0';
			  load_data <= '0';
			  DMA_MD_RE <= '0';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '0';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= escribirIO;
	   		elsif (IO_sync = '0' and Bus_Req = '0') then 
	   		  update_done <= '0';
			  reset_count <= '0';
			  count_enable <= '1';
			  load_data <= '1';
			  DMA_MD_RE <= '1';
			  DMA_MD_WE <= '0';
			  DMA_IO_RE <= '0';
			  DMA_IO_WE <= '0';
			  DMA_sync <= '0';
			  DMA_send_data <= '0';
			  DMA_send_addr <= '1';
			  DMA_Burst <= '0';
			  DMA_wait <= '0';
	          next_state <= sincro_escribirIO;
	   		end if;   
	   end if;
   end process;
 
   
end Behavioral;

