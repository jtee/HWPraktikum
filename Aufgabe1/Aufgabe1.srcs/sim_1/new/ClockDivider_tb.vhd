library ieee;
use ieee.std_logic_1164.all;

entity ClockDivider_tb is
end ClockDivider_tb;

architecture Behavioral of ClockDivider_tb IS 
	component ClockDivider
		generic(
	 		divides: integer := 26
		);
		Port(
			clk: in std_logic;
			res: in std_logic;
			clk_out: out std_logic
		);
	end component;

	-- Inputs
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	
	constant clk_period: time := 15 ns;
	
	-- Outputs
	signal clk_out: std_logic; 
begin 
	uut: ClockDivider port map (
		clk  => clk,
		res   => reset,
		clk_out => clk_out
	);

	clock_process :process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;

	stimuli: process
	begin
		reset <= '1';
		wait for clk_period * 2;
		reset <= '0';
        wait;
	end process;
end;