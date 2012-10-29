library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
    Port ( CLK_66MHZ : in STD_LOGIC;
           USER_RESET : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (3 downto 0));
end Main;

architecture Behavioral of Main is
	component PWMModule is
		Port (
			clk : in STD_LOGIC;
			res : in STD_LOGIC;
			dutyCycle : in STD_LOGIC_VECTOR (7 downto 0);
			pwmOut : out STD_LOGIC
		);
	end component;
	
	component Counter is
		generic(
	 		width: integer := 1
		);
		Port (
			clk : in STD_LOGIC;
			res : in STD_LOGIC;
			cout : out STD_LOGIC_VECTOR (width - 1 downto 0)
		);
	end component;
	
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
	
	signal slowClk: std_logic;
	signal pwmDutyCycle: std_logic_vector (7 downto 0);
begin
	clockDivider1: ClockDivider generic map (
		divides => 26
	) port map (
		clk  => CLK_66MHZ,
		res   => USER_RESET,
		clk_out => slowClk
	);
	
	counter1: Counter generic map (
		width => 3
	) port map (
		clk => slowClk,
		res => USER_RESET,
		cout => pwmDutyCycle(7 downto 5)
	);
	
	pwmDutyCycle(4 downto 0) <= (others => '0');
	
	pwmModule1: PWMModule port map(
		clk => CLK_66MHZ,
		res => USER_RESET,
		dutyCycle => pwmDutyCycle,
		pwmOut => LED(2)
	);
	
	LED(0) <= '0';
	LED(1) <= '0';
	LED(3) <= '0';
end Behavioral;
