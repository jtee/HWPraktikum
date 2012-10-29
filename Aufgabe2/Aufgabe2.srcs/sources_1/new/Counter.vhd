library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Counter is
	generic(
 		width: integer := 1
	);
	Port ( clk : in STD_LOGIC;
           res : in STD_LOGIC;
           cout : out STD_LOGIC_VECTOR (width - 1 downto 0)
	);
end Counter;

architecture Behavioral of Counter is
	signal counter: std_logic_vector (width - 1 downto 0);
begin
	count: process(res, clk) begin
		if (res = '1') then
			counter <= (others => '0');
		elsif rising_edge(clk) then
			counter <= std_logic_vector(unsigned(counter) + 1);
		end if;
	end process;

	cout <= counter;
end Behavioral;
