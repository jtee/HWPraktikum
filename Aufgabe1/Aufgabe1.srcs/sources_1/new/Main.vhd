library ieee;
use ieee.std_logic_1164.all;

entity Main is
	Port(
		CLK_66MHZ: in std_logic;
		LED: out std_logic_vector (0 to 3);
		USER_RESET: in std_logic
	);
end Main;

architecture Behavioral of Main is
	component ClockDivider
		generic(
	 		divides: integer := 1
		);
		Port(
			clk: in std_logic;
			res: in std_logic;
			clk_out: out std_logic
		);
	end component;
begin
	clockDivider1: ClockDivider generic map (
		divides => 26
	) port map (
		clk  => CLK_66MHZ,
		res   => USER_RESET,
		clk_out => LED(2)
	);
	
	LED(0) <= '0';
	LED(1) <= '0';
	LED(3) <= '0';
end Behavioral;
