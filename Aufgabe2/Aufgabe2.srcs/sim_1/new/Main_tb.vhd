library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main_tb is
end Main_tb;

architecture Behavioral of Main_tb is
	component Main
		Port (
			CLK_66MHZ : in STD_LOGIC;
			USER_RESET : in STD_LOGIC;
			LED : out STD_LOGIC_VECTOR (3 downto 0)
		);
	end component;
	
	-- Inputs
	signal clk66: std_logic := '0';
	signal reset: std_logic := '0';

	constant clk66_period: time := 15 ns;

	-- Outputs
	signal ledOut: std_logic_vector (3 downto 0); 
begin
	uut: Main port map (
		CLK_66MHZ  => clk66,
		USER_RESET   => reset,
		LED => ledOut
	);

	clock66_process :process
	begin
		clk66 <= '0';
		wait for clk66_period / 2;
		clk66 <= '1';
		wait for clk66_period / 2;
	end process;

	stimuli: process
	begin
		reset <= '1';
		wait for clk66_period * 2;
		reset <= '0';
        wait;
	end process;
end Behavioral;
