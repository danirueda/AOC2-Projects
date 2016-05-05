-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY DMA_test IS
  END DMA_test;

  ARCHITECTURE behavior OF DMA_test IS 

  -- DMA
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

		signal DMA_addr_IO : std_logic_vector (6 downto 0);
        signal Bus_addr, Bus_data, DMA_addr, DMA_IO_out, DMA_bus_out , DMA_IO_in: std_logic_vector (31 downto 0);  
		SIGNAL clk, reset, Bus_WE, Bus_RE, Bus_Req, IO_sync, DMA_send_data, DMA_send_addr, DMA_Burst,DMA_wait,DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync :  std_logic;
    
  -- Clock period definitions
   constant CLK_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
 my_DMA: DMA_cont port map ( clk, reset, Bus_addr, Bus_data, Bus_WE, Bus_RE, Bus_Req, IO_sync, DMA_IO_in, DMA_send_data, DMA_send_addr, DMA_Burst, DMA_wait, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync, DMA_addr_IO, DMA_addr, DMA_IO_out, DMA_bus_out);

-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
-- Este banco es sólo un ejemplo. Pensad si podéis mejorarlo.
-- La calidad del banco de pruebas: es decir que compruebe los casos representativos se valorará en la nota
 stim_proc: process
   begin		
      reset <= '1';
      wait for CLK_period;
      reset <= '0';
      Bus_data <= x"01020800";--movemos dos palabras de IO a MD
      Bus_WE <= '1';
      Bus_RE <= 'Z';
      Bus_addr<= x"00000200";
	  Bus_Req <= '1';--el mips está usando el bus
	  IO_sync <= '0';
	  DMA_IO_in <= x"00000000";
      wait for CLK_period;
	  Bus_WE <= 'Z';
	  wait for CLK_period*2;
	  Bus_Req <= '0'; -- se libera el bus
	  wait for CLK_period*2;	  
	  IO_sync <= '1'; --la IO da la palabra
	  DMA_IO_in <= x"abcdabcd";
	  wait for CLK_period*2;	  
	  IO_sync <= '0';
	  wait for CLK_period*2;
	  Bus_Req <= '1';--el mips quiere usar el bus (le ignoramos)
	  wait for CLK_period*2;	  
	  IO_sync <= '1';
	  wait for CLK_period*2;
	  IO_sync <= '0'; --se cierra la segunda operación con la IO
	  wait for CLK_period*5;
	  Bus_data <= x"03020103";
	  Bus_WE <= '1';
	  wait for CLK_period;
	  Bus_WE <= 'Z';
	  wait for CLK_period*2;
	  Bus_Req <= '0'; -- se libera el bus
	  wait for CLK_period*2;	  
	  IO_sync <= '1';
	  wait for CLK_period*2;	  
	  IO_sync <= '0';
	  wait for CLK_period*2;
	  IO_sync <= '1';
	  wait for CLK_period*2;
	  IO_sync <= '0';
	  wait for CLK_period*5;
      wait;
   end process;

  END;
