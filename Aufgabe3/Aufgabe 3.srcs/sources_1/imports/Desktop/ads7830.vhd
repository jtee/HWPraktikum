library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADS7830 is
  generic (I2C_ADR	: std_logic_vector(6 downto 0) := "1001000"
	);
	port (
		SDA	: inout std_logic;
		SCL	: in  	std_logic
	);
end ADS7830;

architecture RTL of ADS7830 is

	constant CMD_WORD			: std_logic_vector(7 downto 0) := x"8C"; 
	constant MEM_WORD			: std_logic_vector(7 downto 0) := x"1A"; --x"9A";
	
	signal SDA_latched		: std_logic := '1';	
	signal start_or_stop	: std_logic; 	
	signal bitcnt					: unsigned(3 downto 0) := "1111";	-- counts the I2C bits from 7 downto 0, plus an ACK bit
	signal bit_DATA				: std_logic;
	signal bit_ACK				: std_logic;
	signal data_phase			: std_logic := '0';
	signal adr_phase			: std_logic;
	signal adr_match			: std_logic := '0'; 
	signal op_read				: std_logic := '0'; 
	signal mem						: std_logic_vector(7 downto 0) := MEM_WORD;
	signal op_write				: std_logic;
	signal mem_bit_low		: std_logic;
	signal SDA_assert_low	: std_logic;
	signal SDA_assert_ACK	: std_logic;
	signal SDA_low				: std_logic;
	signal adr_reg				: std_logic_vector(6 downto 0) := "0000000";	
	signal SDA_int				: std_logic;
	signal SCL_int				: std_logic;
	signal initialized		: std_logic := '0';
	signal SDA_edge				: std_logic;

begin

	-- for simulation only
	SDA_int <= '0' when SDA = '0' else '1';
	SCL_int <= '0' when SCL = '0' else '1';
  	
	-- We use two wires with a combinatorial loop to detect the start and stop conditions
	-- making sure these two wires don't get optimized away
	
	SDA_latched		<=	SDA_int     when (SCL_int = '0') else --((SCL_int = '0') or (start_or_stop = '1')) else 
										SDA_latched;			 
	
	SDA_edge			<=	SDA_int xor SDA_latched;

	start_or_stop	<= '0'				when (SCL_int = '0') else 
	                 SDA_edge;
									 
	bit_ACK		<= bitcnt(3);			-- the ACK bit is the 9th bit sent
	bit_DATA	<= not bit_ACK;	  
	
	bitcounter: process (SCL_int, start_or_stop)
	begin
		if (start_or_stop = '1') then
			bitcnt				<= x"7";			-- the bit 7 is received first
			data_phase		<= '0';
		elsif (SCL_int'event and SCL_int = '0') then
			if (bit_ACK = '1') then
				bitcnt			<= x"7";
				data_phase	<= '1';
			else
				bitcnt	<= bitcnt - 1; 
			end if;
		end if;
	end process;

	adr_phase	<= not data_phase;

	op_write	<= not op_read;
	
	regs: process (SCL_int, start_or_stop)
	  variable cmd_reg : std_logic_vector(7 downto 0) := x"00";	
	begin
		if (start_or_stop = '1') then
		  adr_match <= '0';
			op_read   <= '0';
		elsif (SCL_int'event and SCL_int = '1') then
			if (adr_phase = '1') then
				if (bitcnt > "000") then
				  adr_reg <= adr_reg(5 downto 0) & SDA_int;
				else 
					op_read <= SDA_int;
					if (adr_reg = I2C_ADR(6 downto 0)) then
						adr_match <= '1';
					end if;	
				end if;				
			end if;
			if (data_phase='1' and adr_match = '1') then
				if (op_write='1' and initialized='0') then
					if (bitcnt >= "000") then
						cmd_reg := cmd_reg(6 downto 0) & SDA_int;
					end if;
					if (bitcnt = "000" and cmd_reg = CMD_WORD) then	
					  initialized <= '1';
					end if;
				end if;	
			end if;		
		end if;
	end process;
	
	mem_bit_low			<= not mem(to_integer(bitcnt(2 downto 0)));
	SDA_assert_low	<= adr_match and bit_DATA and data_phase and op_read and mem_bit_low and initialized; 
	SDA_assert_ACK	<= adr_match and bit_ACK  and (adr_phase or  op_write);
	SDA_low					<= SDA_assert_low or SDA_assert_ACK;

	SDA   					<= '0' when (SDA_low = '1') else 'Z';

end RTL;
