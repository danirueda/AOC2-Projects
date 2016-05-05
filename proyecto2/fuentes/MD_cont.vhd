----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:11 04/04/2014 
-- Design Name: 
-- Module Name:    DMA - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity MD_cont is port (
		  CLK : in std_logic;
		  reset: in std_logic;
		  Bus_BURST: in std_logic;
		  Bus_WAIT: in std_logic;
		  Bus_WE: in std_logic;
		  Bus_RE: in std_logic;
		  Bus_addr : in std_logic_vector (31 downto 0); --Dir 
          Bus_data : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          MD_send_data: out std_logic; -- para enviar los datos al bus
          MD_Dout : out std_logic_vector (31 downto 0)		  -- salida de datos
		  );
end MD_cont;

architecture Behavioral of MD_cont is

component counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           count_enable : in  STD_LOGIC;
           load : in  STD_LOGIC;
           D_in  : in  STD_LOGIC_VECTOR (7 downto 0);
		   count : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

-- misma memoria que en el proyecto anterior
component RAM_128_32 is port (
		  CLK : in std_logic;
		  enable: in std_logic; --solo se lee o escribe si enable está activado
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
        Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
        WE : in std_logic;		-- write enable	
		  RE : in std_logic;		-- read enable		  
		  Dout : out std_logic_vector (31 downto 0));
end component;

signal MEM_WE, contar, resetear_cuenta,MD_enable: std_logic;
signal addr_burst, addr_bus:  STD_LOGIC_VECTOR (6 downto 0);
signal cuenta_palabras:  STD_LOGIC_VECTOR (7 downto 0);
signal MD_addr: STD_LOGIC_VECTOR (31 downto 0);

begin
-- el controlador activa la señal de enable si la dirección en el bus está en el rango de la memoria MD (X"00000000"-X"000001FF")
MD_enable <= '1' when Bus_addr(31 downto 9) = "00000000000000000000000" else '0'; 
MD_send_data <='1' when ((MD_enable='1') AND (Bus_RE='1')) else '0'; -- si la dirección está en rango y es una lectura se carga el dato de MD en el bus
---------------------------------------------------------------------------
-- calculo direcciones 
-- el contador cuenta mientras burst esté activo, wait sea 0 y la dirección pertenezca a la memoria. 
contar <= '1' when (Bus_wait='0' and Bus_BURST='1' and MD_enable='1') else '0';
--Si se desactiva la señal de burst la cuenta vuelve a 0 al ciclo siguiente. Para que este esquema funcione Burst debe estar un ciclo a 0 entre dos ráfagas. En este sistema esto siempre se cumple.
resetear_cuenta <= Not(Bus_BURST);
cont_palabras: counter port map (clk => clk, reset => reset, count_enable => contar , load=> resetear_cuenta, D_in => "00000000", count => cuenta_palabras);
addr_bus <= Bus_addr(8 downto 2);
addr_burst <= addr_bus + cuenta_palabras(6 downto 0);
-- sólo asignamos los bits que se usan. El resto se quedan a 0.
MD_addr(8 downto 2) <= addr_burst when Bus_BURST='1' else addr_bus; --si es una operación de ráfaga sumamos las palabras que llevemos. Sino usamos la dirección del bus
MD_addr(1 downto 0) <= "00";
MD_addr(31 downto 9) <= "00000000000000000000000";
---------------------------------------------------------------------------
-- Memoria de datos original 
MEM_WE <= Bus_WE and not(Bus_Wait); --evitamos escribir basura
MD: RAM_128_32 PORT MAP (CLK => CLK, enable => MD_enable, ADDR => MD_addr, Din => Bus_data, WE =>  MEM_WE, RE => Bus_RE, Dout => MD_Dout);


end Behavioral;

