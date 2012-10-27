library Ieee;
use Ieee.std_logic_1164.all;

entity ClockDivider is
	generic(
 		divides: integer := 1
	);
	Port(
		clk: in std_logic;
		res: in std_logic;
		clk_out: out std_logic
	);
end ClockDivider;

architecture Behavioral of ClockDivider is
	signal tmp: std_logic;
	signal counter: integer range 0 to 2**(divides-1)-1 := 0;
begin
	divider: process(res, clk) begin
		if (res = '1') then
			tmp <= '0';
			counter <= 0;
		elsif rising_edge(clk) then
			if (counter = 2**(divides-1)-1) then
				tmp <= NOT(tmp);
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	clk_out <= tmp;
end;