----------------------------------------------------------------------------------
--
-- Description: Incluye la memoria de datos inicial, un bus y un periférico con un controlador DMA para mover datos de la memoria al periférico y viceversa 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
-- Memoria RAM de 128 palabras de 32 bits
entity MD_mas_I_O is port (
		  CLK : in std_logic;
		  reset: in std_logic; -- sólo resetea el controlador de DMA
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
          Din : in std_logic_vector (31 downto 0);--entrada de datos desde el Mips
          WE : in std_logic;		-- write enable	del MIPS
		  RE : in std_logic;		-- read enable del MIPS	
		  MEM_STALL: out std_logic; --señal de parada por riesgo estructural en la etapa MEM 	  
		  Dout : out std_logic_vector (31 downto 0)); --salida que puede leer el MIPS
end MD_mas_I_O;

architecture Behavioral of MD_mas_I_O is
-- Memoria de datos con su controlador de bus
component MD_cont is port (
		  CLK : in std_logic;
		  reset: in std_logic;
		  Bus_BURST: in std_logic;
		  Bus_WAIT: in std_logic;
		  Bus_WE: in std_logic;
		  Bus_RE: in std_logic;
		  Bus_addr : in std_logic_vector (31 downto 0); --Dir 
          Bus_data : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          MD_send_data: out std_logic; -- para enviar los datos al bus
          MD_Dout : out std_logic_vector (31 downto 0)		  -- salida de datos, para enviar al registro MDR (si el procesador quiere leer alguno de sus registros) o a la memoria de datos
		  );
end component;
-- Memoria del periférico. 128 bytes. Se lee y escribe byte a byte
component I_O_slave is port (
		  CLK : in std_logic;
		  reset : in  STD_LOGIC;
		  ADDR : in std_logic_vector (6 downto 0); --Dir 
          Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          WE : in std_logic;		-- write enable	
		  RE : in std_logic;		-- read enable	
		  DMA_sync : in std_logic;  
		  IO_sync: out std_logic; 
		  Dout : out std_logic_vector (31 downto 0));
end component;
--- DMA
component DMA_cont is port (
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
end component;

--señales del bus
signal Bus_addr:  std_logic_vector(31 downto 0); 
signal Bus_data:  std_logic_vector(31 downto 0); 
signal Bus_RE, Bus_WE, Bus_Wait, Bus_BURST, Bus_Req: std_logic;
--señales de MD
signal MD_Dout:  std_logic_vector(31 downto 0); 
signal MD_send_data: std_logic;
--señales de la IO
signal IO_Dout:  std_logic_vector(31 downto 0); 
-- señales arbitraje:
signal Mips_req: std_logic;
-- señales controlador Mips:
signal Mips_send_data, Mips_send_addr, M_Stall: std_logic;
-- señales de sincro DMA IO
signal IO_sync, DMA_sync: std_logic;
-- señales DMA:
signal DMA_addr_IO: std_logic_vector (6 downto 0);
signal DMA_addr:  std_logic_vector(31 downto 0); 
signal DMA_IO_out, DMA_bus_out : std_logic_vector (31 downto 0);
signal DMA_send_addr, DMA_send_data, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_Burst, DMA_wait: std_logic;


begin
------------------------------------------------------------------------------------------------
--   BUS
------------------------------------------------------------------------------------------------
-- Bus datos 
	Bus_data <= Din when Mips_send_data='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; -- Din son los datos que enviá el Mips. 
	Bus_data <= MD_Dout when MD_send_data ='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	Bus_data <= DMA_bus_out when (DMA_send_data ='1') else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	Bus_data <= X"00000000" when (Mips_send_data='0' and MD_send_data='0' and DMA_send_data='0') else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";--para que esté a cero cuando nadie vuelca nada
-- Bus addr 
	Bus_addr <= addr when Mips_send_addr='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; -- addr es la dir que enviá el Mips. 
	Bus_addr <= DMA_addr when (DMA_send_addr ='1') else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";	
	Bus_addr <= X"00000000" when (Mips_send_addr='0' and DMA_send_addr='0') else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";--para que esté a cero cuando nadie vuelca nada
-- control
	Bus_RE <= RE when Mips_send_addr='1' else 'Z'; -- RE es la señal de read enable del Mips. 
	Bus_RE <= DMA_MD_RE when (DMA_send_addr ='1') else 'Z';	
	Bus_RE <= '0' when (Mips_send_addr='0' and DMA_send_addr='0') else 'Z';--para que esté a cero cuando nadie vuelca nada

	Bus_WE <= WE when Mips_send_addr='1' else 'Z'; -- RE es la señal de write enable del Mips. 
	Bus_WE <= DMA_MD_WE when (DMA_send_addr ='1') else 'Z';	
	Bus_WE <= '0' when (Mips_send_addr='0' and DMA_send_addr='0') else 'Z';--para que esté a cero cuando nadie vuelca nada
	
	Bus_BURST <= DMA_Burst; -- la activa el DMA para trabajar en modo ráfaga
	
	Bus_Wait <= DMA_wait; --sólo el dma activa la señal de wait
	
	Bus_Req <= Mips_req; --sólo el mips activa la línea req
------------------------------------------------------------------------------------------------	
------------------------------------------------------------------------------------------------
-- Controlador del Mips (es combinacional)
------------------------------------------------------------------------------------------------
Mips_send_data <= '1' when (Bus_BURST='0' and WE='1') else '0'; --cuando el procesador quiere escribir y el bus está libre
Mips_send_addr <= '1' when (Bus_BURST='0' and Mips_req='1') else '0';--cuando el procesador quiere leer o escribir y el bus está libre
M_Stall <= Bus_BURST and Mips_req; --Si el mips quiere usar el bus y está ocupado en una ráfaga hay que parar el mips
Mem_Stall <= M_Stall;
Mips_req <= '1' when (WE='1' or RE='1') else '0'; --el controlador activa su solicitud cuando quiere usar el bus
Dout <= Bus_data when (RE='1') and (M_Stall = '0') else x"00000000";    -- el controlador envía el dato al Mips si este quería leer y el bus estaba disponible
------------------------------------------------------------------------------------------------	
-- Controlador de MD
------------------------------------------------------------------------------------------------
controlador_MD: MD_cont port map (clk, reset, Bus_BURST, Bus_WAIT, Bus_WE, Bus_RE, Bus_addr, Bus_data, MD_send_data, MD_Dout);
------------------------------------------------------------------------------------------------	 
-- DMA
------------------------------------------------------------------------------------------------
Controlador_DMA: DMA_cont port map ( clk, reset, bus_addr, Bus_data, Bus_WE, Bus_RE, Bus_Req, IO_sync, IO_Dout, DMA_send_data, DMA_send_addr, DMA_Burst, DMA_wait, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync, DMA_addr_IO, DMA_addr, DMA_IO_out, DMA_bus_out);
------------------------------------------------------------------------------------------------	   
------------------------------------------------------------------------------------------------	
-- memoria de datos IO: sólo se accede a ella a través del DMA
------------------------------------------------------------------------------------------------
 IO: I_O_slave PORT MAP (CLK => CLK, reset => reset, ADDR => DMA_addr_IO, Din => DMA_IO_out, WE => DMA_IO_WE, RE => DMA_IO_RE, DMA_sync => DMA_sync, IO_sync => IO_sync, Dout => IO_Dout);
------------------------------------------------------------------------------------------------	
end Behavioral;

