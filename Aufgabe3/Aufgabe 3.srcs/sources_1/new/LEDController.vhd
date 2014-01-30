library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LEDController is
	Port (
		CLK_66MHZ: in std_logic;
		USER_RESET: in std_logic;

        SDA: inout std_logic;
        SCL: inout std_logic;
        
        LED: out std_logic_vector (0 to 3);
        
        T1: in std_logic;
        T2: in std_logic
	);
end LEDController;

architecture Behavioral of LEDController is
	type states is (addressWrite, addressWriteWait, addressRead, addressReadWait, command, commandWait, read, readWait);

	signal i2c_start 		: std_logic; 
	signal i2c_stop 		: std_logic; 
	signal i2c_read 		: std_logic; 
	signal i2c_write 		: std_logic; 
	signal i2c_ack_in 	: std_logic; 
	signal i2c_cmd_ack 	: std_logic; 
	signal i2c_ack_out 	: std_logic; 
	signal i2c_busy 		: std_logic; 
	signal i2c_al 			: std_logic; 
	signal i2c_scl_i 		: std_logic; 
	signal i2c_scl_o 		: std_logic; 
	signal i2c_scl_oen 	: std_logic; 
	signal i2c_sda_i 		: std_logic; 
	signal i2c_sda_o 		: std_logic; 
	signal i2c_sda_oen 	: std_logic; 
	signal i2c_din 			: std_logic_vector(7 downto 0); 
	signal i2c_dout 		: std_logic_vector(7 downto 0);
	signal dutyCycle		: std_logic_vector(7 downto 0);
	signal state			: states;	
	
	signal clk: std_logic;
	signal reset: std_logic;
begin
	clk <= CLK_66MHZ;
	reset <= USER_RESET;
	
	--sda <= 'H';
	--scl <= 'H';
	
	pwm : entity work.PWMModule port map (clk, reset, dutyCycle, LED(0));
		
	LED(1) <= '0';
	LED(2) <= '0';
	LED(3) <= '0';
	
	--T1 <= 'Z';
	--T2 <= 'Z';

	i2c_controller: entity work.i2c_master_byte_ctrl 
		port map (
				clk 			=> clk,
				rst 			=> reset,
				nReset 		=> '1',
				ena 			=> '1',
				clk_cnt 	=> X"0020",
				start 		=> i2c_start,
				stop 			=> i2c_stop,
				read 			=> i2c_read,
				write 		=> i2c_write,
				ack_in 		=> i2c_ack_in,
				din 			=> i2c_din,
				cmd_ack 	=> i2c_cmd_ack,
				ack_out 	=> i2c_ack_out,
				i2c_busy 	=> i2c_busy,
				i2c_al 		=> i2c_al,
				dout 			=> i2c_dout,
				scl_i 		=> i2c_scl_i,
				scl_o 		=> i2c_scl_o,
				scl_oen 	=> i2c_scl_oen,
				sda_i 		=> i2c_sda_i,
				sda_o 		=> i2c_sda_o,
				sda_oen 	=> i2c_sda_oen
			);
 	
 	
 	
  	tristate_Lines : process (i2c_scl_oen, i2c_scl_o, scl, i2c_sda_oen, i2c_sda_o, sda) is
 		begin
 			if (i2c_scl_oen = '0') then
 				scl <= i2c_scl_o;
 			else
 				scl <= 'Z';
 			end if;
 			i2c_scl_i <= scl;
 			if (i2c_sda_oen = '0') then
 				sda <= i2c_sda_o;
 			else
 				sda <= 'Z';
 			end if;
 			i2c_sda_i <= sda;
 		end process tristate_Lines;
 		
 	transitions : process (clk, reset) is
 		begin
 			if reset = '1' then
 				state <= addressWrite;
 				dutyCycle <= (others => '0');
 				i2c_start <= '0'; 
 				i2c_stop <= '0'; 
 				i2c_read <= '0'; 
 				i2c_write <= '0'; 
 				i2c_ack_in <= '1';
 				i2c_din <= (others => '0'); 
 			elsif rising_edge(clk) then
 				case state is
 					when addressWrite =>
 						i2c_din <= "10010000";
 						i2c_start <= '1';
 						i2c_write <= '1';
 						state <= addressWriteWait;
 					when addressWriteWait =>
 						i2c_write <= '0';
 						i2c_start <= '0';
 						if (i2c_cmd_ack = '1') then
 							state <= command;
 						end if;
 					when command =>
 						i2c_din <= "10001100";
 						--i2c_start <= '1';
 						i2c_write <= '1';
 						state <= commandWait;
 					when commandWait =>
  						i2c_write <= '0';
  						--i2c_start <= '0';
 						if (i2c_cmd_ack = '1') then
 					 		state <= addressRead;
 					 	end if;
 					when addressRead =>
 						i2c_din <= "10010001";
 						i2c_start <= '1';
 						i2c_write <= '1';
 						state <= addressReadWait;
 					when addressReadWait =>
 	 					i2c_write <= '0';
 	 					i2c_start <= '0';
 					 	if (i2c_cmd_ack = '1') then
 					 		state <= read;
 					 	end if;
 					when read =>
 						i2c_read <= '1';
 						i2c_stop <= '1';
 						--i2c_start <= '1';
 						state <= readWait;
 					when readWait =>
 						i2c_read <= '0';
 						--i2c_start <= '0';
 						if (i2c_cmd_ack = '1') then
 							state <= addressWrite;
 							dutyCycle <= i2c_dout;
 							i2c_stop <= '0';
 						end if;
 				end case;
 			end if;
 		end process;
end Behavioral;
