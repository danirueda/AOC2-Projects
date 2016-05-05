-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY MD_IO_test IS
  END MD_IO_test;

  ARCHITECTURE behavior OF MD_IO_test IS 

component MD_mas_I_O is port (
		  CLK : in std_logic;
		  reset: in std_logic; -- sólo resetea el controlador de DMA
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
          Din : in std_logic_vector (31 downto 0);--entrada de datos desde el Mips
          WE : in std_logic;		-- write enable	del MIPS
		  RE : in std_logic;		-- read enable del MIPS	
		  MEM_STALL: out std_logic; --señal de parada por riesgo estructural en la etapa MEM 	  
		  Dout : out std_logic_vector (31 downto 0)); --salida que puede leer el MIPS
end component;
		signal addr, Din, Dout: std_logic_vector (31 downto 0);  
		SIGNAL clk, reset, WE, RE, MEM_STALL :  std_logic;
    
  -- Clock period definitions
   constant CLK_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
 MD_IO: MD_mas_I_O port map ( clk, reset, addr, Din, WE, RE, MEM_STALL, Dout);

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
      Din <= x"01031415";
      we <= '1';
      re <= '0';
      addr<= x"00000200"; --escribo en el DMA (operación de lectura en memoria)
      wait for CLK_period;
	  we <= '0';
	  re <= '1'; --leo el contenido del DMA ( e impido que el DMA pueda acceder a la memoria)
	  wait for CLK_period*10;
	  re <= '0'; --dejo el bus libre
      wait for CLK_period*4;
      re <= '1'; --el mips intenta leer (se le debe ignorar)
	  wait for CLK_period*50;
      addr<= x"00000200"; --escribo en el DMA
      Din <= x"03040103"; --operación de escritura en memoria
      we <= '1';
      re <= '0'; 
      wait for CLK_period;
	  we <= '0';
	  re <= '1'; --leo el contenido del DMA ( e impido que el DMA pueda acceder a la memoria)
      wait for CLK_period*2;
	  re <= '0'; --dejo el bus libre
	  wait;
   end process;

  END;
