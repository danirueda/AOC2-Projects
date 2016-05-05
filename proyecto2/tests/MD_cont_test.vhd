-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY MD_cont_test IS
  END MD_cont_test;

  ARCHITECTURE behavior OF MD_cont_test IS 

component MD_cont is port (
		  CLK : in std_logic;
		  reset: in std_logic;
		  Bus_BURST: in std_logic;
		  Bus_WAIT: in std_logic;
		  Bus_WE: in std_logic;
		  Bus_RE: in std_logic;
		  Bus_addr : in std_logic_vector (31 downto 0); --Dir 
          Bus_data : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
          MD_Dout : out std_logic_vector (31 downto 0)		  -- salida de datos, para enviar al registro MDR (si el procesador quiere leer alguno de sus registros) o a la memoria de datos
		  );
end component;
	
		signal MD_Dout, Bus_data, Bus_addr: std_logic_vector (31 downto 0);  
		SIGNAL clk, reset, Bus_BURST, Bus_WAIT, Bus_WE, Bus_RE :  std_logic;
    
  -- Clock period definitions
   constant CLK_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
  controlador_MD: MD_cont port map (clk, reset, Bus_BURST, Bus_WAIT, Bus_WE, Bus_RE, Bus_addr, Bus_data, MD_Dout);

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
      -- probamos una lectura normal
      Bus_BURST <= '0';
      Bus_WAIT <= '0';
      Bus_WE <= '0';
      Bus_RE <= '1';
      Bus_addr <= X"20000000"; --fuera de rango debe ignorarlo
      Bus_data <= X"20000000";
      wait for CLK_period;
      Bus_addr <= X"00000008"; --en rango debe actualizar MD_Dout
      wait for CLK_period;
      -- probamos una escritura normal
      Bus_WE <= '1';
      Bus_RE <= '0'; 
      Bus_data <= X"12345678"; --se debe escribir este dato enla dir 8
      -- probamos una lectura en ráfaga
      wait for CLK_period;
      Bus_WE <= '0';
      Bus_RE <= '1';
      Bus_BURST <= '1';
      wait for CLK_period*4;
      Bus_WAIT <= '1';
      wait for CLK_period*4;
      Bus_WAIT <= '0';
      wait for CLK_period*2;
      Bus_WAIT <= '1';
      wait for CLK_period*3;
      Bus_WAIT <= '0';
      wait for CLK_period;
      Bus_BURST <= '0';
      -- probamos una escritura en ráfaga
      wait for CLK_period;
      Bus_data <= X"12345678"; 
      Bus_addr <= X"0000000C";
      Bus_WE <= '1';
      Bus_RE <= '0';
      Bus_BURST <= '1';
      wait for CLK_period*4;
      Bus_WAIT <= '1';
      wait for CLK_period*4;
      Bus_WAIT <= '0';
      wait for CLK_period*2;
      Bus_WAIT <= '1';
      wait for CLK_period*3;
      Bus_WAIT <= '0';
      wait for CLK_period;
      Bus_BURST <= '0';
      Bus_WE <= '0';
      wait;
   end process;

  END;
