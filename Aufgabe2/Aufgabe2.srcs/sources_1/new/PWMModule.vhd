library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWMModule is
    Port ( clk : in STD_LOGIC;
           res : in STD_LOGIC;
           dutyCycle : in STD_LOGIC_VECTOR (7 downto 0);
           pwmOut : out STD_LOGIC);
end PWMModule;

architecture Behavioral of PWMModule is
	signal pwmCounter: std_logic_vector (7 downto 0);
	signal tmp: std_logic;
begin
	pwmCount: process(clk, res) begin
		if (res = '1') then
			pwmCounter <= (others => '0');
			tmp <= '0';
		elsif rising_edge(clk) then
			pwmCounter <= std_logic_vector(unsigned(pwmCounter) + 1);
			
			if (pwmCounter < dutyCycle) then
				tmp <= '1';
			else
				tmp <= '0';
			end if;
		end if;
	end process;
	
	pwmOut <= tmp;
end Behavioral;
