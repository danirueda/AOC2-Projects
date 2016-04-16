----------------------------------------------------------------------------------------------------------------------------
--Autor: Daniel Rueda Macías
--Company: Unizar
--Description: Predictor de saltos del MIPS segmentado que hace una prediccion dinamica en funcion de la prediccion anterior
----------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity branch_predictor is Port (
clk : in STD_LOGIC;
reset : in STD_LOGIC;
--Puerto de lectura
branch_address_out : out STD_LOGIC_VECTOR (31 downto 0); --direccion de salto
prediction_out : out STD_LOGIC; --prediccion correspondiente a la isntruccion actual
--Puerto de escritura
PC4 : in STD_LOGIC_VECTOR (7 downto 0); --PC de la instruccion que está en fetch (la actual)
PC4_ID: in STD_LOGIC_VECTOR (7 downto 0); --PC de la instruccion que se encuentra en ID
branch_address_in : in STD_LOGIC_VECTOR (31 downto 0); --direccion de salto completa
prediction_in : in STD_LOGIC; --indica que ocurrio la ultima vez ('0' no se salto, '1' si se salto)
update: in STD_LOGIC);--indica si hay que actualizar el registro
end branch_predictor;

architecture Behavioral of branch_predictor is
--Informacion a almacenar
signal etiqueta : STD_LOGIC_VECTOR (7 downto 0); --utilizaremos PC+4 como etiqueta
signal dirSalto : STD_LOGIC_VECTOR (31 downto 0); --almacenamos la direccion de salto completa
signal prediccion, validez : STD_LOGIC; --prediccion, indica que ocurrio la ultima vez ('0' no se salto, '1' si se salto)
--indica si el registro contiene un dato valido
	begin

		process(clk) --registro
			begin
			if (clk'event and clk = '1') then --cuando se produzca un cambio en clk
				if (reset = '1') then --si reseteamos el procesador
					validez <= '0';
					etiqueta <= "00000000";
					prediccion <= '0';
					dirSalto <= "00000000000000000000000000000000";
					--preguntar a si puedo poner todo a 0
				else
					if(update = '1') then
						etiqueta <= PC4_ID;
						dirSalto <= branch_address_in;
						prediccion <= prediction_in;
						validez <= '1'; --los datos son válidos 
					end if;
				end if;
			end if;
		end process;
		
		process(PC4, validez, prediccion) --comparador
			begin 
			if (PC4 = etiqueta AND validez = '1' AND prediccion = '1') then --si se cumple la condicion se salta
				prediction_out <= '1';
				branch_address_out <= dirSalto;
			else --en caso contrario no se salta
				prediction_out <= '0';
			end if;
		end process;
end Behavioral;