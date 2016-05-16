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


entity DMA_cont is port (
		  CLK : in std_logic;
		  reset: in std_logic;
		  Bus_addr : in std_logic_vector (31 downto 0); --Dir 
          Bus_data : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          Bus_WE : in std_logic;		-- write enable	del bus
		  Bus_RE : in std_logic;		-- read enable	del bus	  
		  Bus_Req: in std_logic;        -- solicitud del mips
		  IO_sync: in std_logic; -- señal de sincro del periférico
		  DMA_IO_in : in std_logic_vector (31 downto 0);--entrada de datos desde el periférico
		  DMA_send_data: out std_logic; -- envío de los datos al bus
		  DMA_send_addr: out std_logic; -- envío de la dirección al bus
		  DMA_Burst: out std_logic; -- señal de modo ráfaga la activa si le piden que transfiera más de 1 palabra
		  DMA_wait: out std_logic; -- señal de espera para la MD
		  DMA_MD_RE: out std_logic; -- enable lectura para el bus
		  DMA_MD_WE: out std_logic; -- enable escritura para el bus
		  DMA_IO_RE: out std_logic; -- enable lectura IO
		  DMA_IO_WE: out std_logic; -- enable escritura IO
		  DMA_sync: out std_logic; -- señal de sincro con el periférico
		  DMA_addr_IO : out std_logic_vector (6 downto 0); -- dirección para el periferico
		  DMA_addr : out std_logic_vector (31 downto 0); -- dirección para el bus
		  DMA_IO_out : out std_logic_vector (31 downto 0); --datos enviados al periférico
		  DMA_bus_out : out std_logic_vector (31 downto 0)		  -- salida de datos para el bus
		  );
end DMA_cont;

architecture Behavioral of DMA_cont is

--Unidad de control del DMA
component UC_DMA is
    Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          empezar: in  STD_LOGIC;
          fin: in  STD_LOGIC;
          robo: in STD_LOGIC;
          L_E: in  STD_LOGIC;  -- 0 lectura de memoria, 1 escritura en memoria
          Bus_Req: in std_logic;        -- solicitud del mips
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
end component;

--Se utiliza como almacenamient intermedio en las comunicaciones entre MD o IO.
--En él se guarda el dato leído hasta que se pueda escribir su destino.
component reg8 is
    Port ( Din : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
           load : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

--Registro de control del DMA
--Bits 31 a 24: Control
--Bits 23 a 16: Número de palabras de 32 bits a transferir
--Bits 15 a 8: Dirección del periférico
--Bits 7 a 0: Dirección de memoria de datos
------------------------------------------------------------------------------------
--Bits de control
--Done (31): Indica que se ha terminado la transferencia anterior. LO ACTUALIZA EL DMA al terminar una transferencia
--L/E (25): Indica si la operación es lectura o escritura. Si vale 0 se lee en MD y se escrive en la IO, y si vale 1 viceversa.
--Start (24): Indica que hay que realizar una transferencia. Sólo se hace caso si Done=0.
component reg32 is
    Port ( Din : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
           load : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--Contador
component counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           count_enable : in  STD_LOGIC;
           load : in  STD_LOGIC;
           D_in  : in  STD_LOGIC_VECTOR (7 downto 0);
		   count : out  STD_LOGIC_VECTOR (7 downto 0));
end component;



signal load_reg_control, load_reg_DMA, count_enable, reset_count, empezar, load_data, update_done, bit7_control_in, fin, L_E, robo, DMA_send_data_slave, DMA_send_data_master: std_logic;
signal Dout_reg_control, Dout_num_palabras, palabra_inicial_MD, cuenta_palabras, palabra_inicial_IO, palabra_MD, control_in:  STD_LOGIC_VECTOR (7 downto 0);
signal reg_DMA, reg_data_in, reg_datos_DMA : STD_LOGIC_VECTOR (31 downto 0);

begin
--------------------------------------------------------------------------------------------
-- Registro de control (es un registro de 32 pero lo hacemos con 4 registros de 8)
--------------------------------------------------------------------------------------------
-- actualización del bit Done
load_reg_control <= update_done or load_reg_DMA; -- update control se activa para poner el bit done a 1

control_in <= Bus_data(31 downto 24) when update_done='0' else '1'&Dout_reg_control(6 downto 0); -- Si activamos update_done es que queremos indicar que hemos terminado poniendo un 1 en el bit 7 y mantener el resto

-- interfaz con el MIPS
 load_reg_DMA <= '1' when ((Bus_addr = x"00000200") AND (BUS_WE = '1')) else '0'; -- escribimos en el registro si el mips indica su dirección en un store 

-- registros
control: reg8 port map (Din => control_in, clk => clk, reset => reset, load => load_reg_control, Dout => Dout_reg_control);
 
num_palabras: reg8 port map (Din => Bus_data(23 downto 16), clk => clk, reset => reset, load => load_reg_DMA, Dout => Dout_num_palabras);
 
addr_IO: reg8 port map (Din => Bus_data(15 downto 8), clk => clk, reset => reset, load => load_reg_DMA, Dout => palabra_inicial_IO);

addr_MD: reg8 port map (Din => Bus_data(7 downto 0), clk => clk, reset => reset, load => load_reg_DMA, Dout => palabra_inicial_MD);

-- reg_DMA son los 4 registros de 8 bits juntos
 reg_DMA <= Dout_reg_control&Dout_num_palabras&palabra_inicial_IO&palabra_inicial_MD;

--------------------------------------------------------------------------------------------
 -- calculo direcciones 
 
 cont_palabras: counter port map (clk => clk, reset => reset, count_enable => count_enable, load=> reset_count, D_in => "00000000", count => cuenta_palabras);
 
 DMA_addr_IO <= palabra_inicial_IO(6 downto 0) + cuenta_palabras(6 downto 0); -- dirección para el periferico

 palabra_MD <= (palabra_inicial_MD + cuenta_palabras) when robo = '1' else palabra_inicial_MD;

 DMA_Addr <= "0000000000000000000000"&palabra_MD&"00"; -- Dirección de la MD
 --------------------------------------------------------------------------------------------
 -- detección del fin
 
fin <= '1' when cuenta_palabras = Dout_num_palabras else '0';
--------------------------------------------------------------------------------------------
  -- registro de datos
 reg_data_in <= DMA_IO_in when L_E= '1' else Bus_data;
 reg_data: reg32 port map (Din => reg_data_in, clk => clk, reset => reset, load => load_data, Dout => reg_datos_DMA);
 --------------------------------------------------------------------------------------------
 -- UC
 empezar <= reg_DMA(24) and not reg_DMA(31); --empezamos si el bit de empezar está activo y el de done esta a 0
 L_E <= reg_DMA(25); --indica si es lectura (0) o escritura(1) en MD
 robo <= reg_DMA(26); --Damos valor a la señal de robo de ciclo

 UC: UC_DMA port map ( clk, reset, empezar, fin, robo, L_E, Bus_Req, IO_sync, update_done, DMA_send_data_master, DMA_send_addr, DMA_Burst, DMA_wait, reset_count, count_enable, load_data, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync);
 --------------------------------------------------------------------------------------------
  --Salidas de datos
  --salida para la IO  
  DMA_IO_out <= reg_datos_DMA; 
  --salida para el bus
  DMA_bus_out <= 	reg_DMA when (Bus_addr = x"00000200") else reg_datos_DMA;

  -- señal send_data: el dma envía datos al bus si lo ordena su Unidad de control (DMA_send_data_master), o si el Mips se los pide(DMA_send_data_slave)
 DMA_send_data <= DMA_send_data_slave or DMA_send_data_master;
 -- si el mips indica la dirección x"00000200" en una operación de lectura hay que mandar el dato
 DMA_send_data_slave <= '1' when (Bus_addr = x"00000200")and (Bus_RE='1') else '0';
	
end Behavioral;

