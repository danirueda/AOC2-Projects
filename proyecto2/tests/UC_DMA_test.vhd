-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY UC_DMA_test IS
  END UC_DMA_test;

  ARCHITECTURE behavior OF UC_DMA_test IS 

  component UC_DMA is
    Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          empezar: in  STD_LOGIC;
          fin: in  STD_LOGIC; --
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
          SIGNAL clk, reset, empezar, fin, L_E, Bus_Req, IO_sync, update_done, DMA_send_data, DMA_send_addr, DMA_Burst, DMA_wait, reset_count, count_enable, load_data, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync :  std_logic;
    
  -- Clock period definitions
   constant CLK_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
  U_control_DMA: UC_DMA port map (clk, reset, empezar, fin, L_E, Bus_Req, IO_sync, update_done, DMA_send_data, DMA_send_addr, DMA_Burst, DMA_wait, reset_count, count_enable, load_data, DMA_MD_RE, DMA_MD_WE, DMA_IO_RE, DMA_IO_WE, DMA_sync);

-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
-- Este banco es sólo un ejemplo. Pensad si podéis mejorarlo.
-- La calidad del banco de pruebas, es decir que compruebe los casos representativos, se valorará en la nota
 stim_proc: process
   begin		
      reset <= '1';
      empezar <= '0';
      fin <= '1';
      L_E <= '0'; -- operación de lectura
      IO_sync <= '0';
      Bus_Req <= '1'; --bus ocupado
      wait for CLK_period*2;
	  reset <= '0';
	  wait for CLK_period;
	  empezar <= '1';
	  wait for CLK_period*2;
	  fin <= '0';
	  empezar <= '1';
	  wait for CLK_period*2;
	  Bus_Req <= '0'; --bus libre se realiza la 1ª lectura
	  wait for CLK_period*4;	  
	  Bus_Req <= '1'; --el mips pide el bus. Le ignoramos hasta que acabe la ráfaga
	  IO_sync <= '1'; -- el esclavo ha escrito el dato
	  wait for CLK_period*2;	  
	  IO_sync <= '0'; --el esclavo cierra el protocolo
	  wait for CLK_period*2;
	  IO_sync <= '1';-- el esclavo ha escrito el dato
	  wait for CLK_period;
	  fin <= '1';	  -- hemos terminado la transferencia
	  wait for CLK_period;
	  IO_sync <= '0'; -- se cierra la comunicación
	  wait for CLK_period;
	  fin <= '0';
	  empezar <= '1';
	  L_E <= '1';  -- operación de escritura
	  wait for CLK_period*2;
	  IO_sync <= '1';
	  Bus_Req <= '0'; --bus libre se realiza la 1ª escritura
	  wait for CLK_period*2;	  
	  IO_sync <= '0';
	  wait for CLK_period*2;
	  IO_sync <= '1';
	  Bus_Req <= '1'; --el mips pide el bus. Le ignoramos hasta que acabe la ráfaga
	  wait for CLK_period*2;	  
	  wait for CLK_period*2;	  
	  IO_sync <= '0';
	  fin <= '1';
	  wait;
   end process;

  END;
