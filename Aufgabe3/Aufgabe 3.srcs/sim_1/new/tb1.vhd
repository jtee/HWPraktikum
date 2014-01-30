library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb1 is
end tb1;

architecture Behavioral of tb1 is	
	-- Inputs
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	signal LEDout: std_logic_vector(0 to 3);
	
	signal t1: std_logic;
	signal t2: std_logic;
	
	-- Outputs
	signal sda: std_logic;
	signal scl: std_logic;

	constant clk_period: time := 15 ns; 
begin
	sda <= 'H';
	scl <= 'H';

	uut: entity work.LEDController port map (
			CLK_66MHZ => clk,
			USER_RESET => reset,
	
	        SDA => sda,
	        SCL => scl,
	        
	        LED => LEDout,
	        
	        T1 => t1,
	        T2 => t2
	);
	
	adc: entity work.ads7830 port map(sda, scl);

	clock_process :process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;

	stimuli: process begin
		reset <= '1';
		wait for clk_period * 2;
		reset <= '0';
        wait;
	end process;
end Behavioral;
