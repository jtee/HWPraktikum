library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package Types is

	function ternaryOp(condition: boolean; thenValue: integer; elseValue:integer) return integer;
	function ternaryOp(condition: boolean; thenValue: unsigned; elseValue:unsigned) return unsigned;
	function ternaryOp(condition: boolean; thenValue: signed; elseValue:signed) return signed;
	function ternaryOp(condition: boolean; thenValue: std_logic_vector; elseValue:std_logic_vector) return std_logic_vector;
	function ternaryOp(condition: boolean; thenValue: std_logic; elseValue:std_logic) return std_logic;

end;



package body Types is

	function ternaryOp(condition: boolean; thenValue: integer; elseValue:integer) return integer is
	begin
		if (condition) then
			return thenValue;
		else
			return elseValue;
		end if;
	end ternaryOp;
	function ternaryOp(condition: boolean; thenValue: unsigned; elseValue:unsigned) return unsigned is
	begin
		if (condition) then
			return thenValue;
		else
			return elseValue;
		end if;
	end ternaryOp;
	function ternaryOp(condition: boolean; thenValue: signed; elseValue:signed) return signed is
	begin
		if (condition) then
			return thenValue;
		else
			return elseValue;
		end if;
	end ternaryOp;
	function ternaryOp(condition: boolean; thenValue: std_logic_vector; elseValue:std_logic_vector) return std_logic_vector is
	begin
		if (condition) then
			return thenValue;
		else
			return elseValue;
		end if;
	end ternaryOp;
	function ternaryOp(condition: boolean; thenValue: std_logic; elseValue:std_logic) return std_logic is
	begin
		if (condition) then
			return thenValue;
		else
			return elseValue;
		end if;
	end ternaryOp;
end;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package ShiftOps is

	function srlUint(arg: unsigned; s:natural) return unsigned;

	function srlInt(arg: signed; s:natural) return signed;

	function srlNatural(arg: natural; s:natural) return natural;

	function srlInteger(arg: integer; s:natural) return integer;

	function srlBit(arg: std_logic; s:natural) return std_logic;

	function srlBitvector(arg: std_logic_vector; s:natural) return std_logic_vector;

	

	function sraUint(arg: unsigned; s:natural) return unsigned;

	function sraInt(arg: signed; s:natural) return signed;

	function sraNatural(arg: natural; s:natural) return natural;

	function sraInteger(arg: integer; s:natural) return integer;

	function sraBit(arg: std_logic; s:natural) return std_logic;
	function sraBitvector(arg: std_logic_vector; s:natural) return std_logic_vector;


	function sllUint(arg: unsigned; s:natural) return unsigned;

	function sllInt(arg: signed; s:natural) return signed;

	function sllNatural(arg: natural; s:natural) return natural;

	function sllInteger(arg: integer; s:natural) return integer;
	function sllBit(arg: std_logic; s:natural) return std_logic;
	function sllBitvector(arg: std_logic_vector; s:natural) return std_logic_vector;
		

end;

package body ShiftOps is
  function sraBitvector(arg: std_logic_vector; s:natural) return std_logic_vector is
  begin
  	return std_logic_vector(sraUint(unsigned(arg),s));
  end sraBitvector;
  function srlBitvector(arg: std_logic_vector; s:natural) return std_logic_vector is
  begin
  	return std_logic_vector(srlUint(unsigned(arg),s));
  end srlBitvector;
  function sllBitvector(arg: std_logic_vector; s:natural) return std_logic_vector is
  begin
  	return std_logic_vector(sllUint(unsigned(arg),s));
  end sllBitvector;
  
  function sraBit(arg: std_logic; s:natural) return std_logic is
  begin
  	--The MSB is the bit itself, so it is returned
    return arg;
  end sraBit;
  function srlBit(arg: std_logic; s:natural) return std_logic is
  begin
  	if (s=0) then
  		return arg;
  	end if;
    return '0';
  end srlBit;
  function sllBit(arg: std_logic; s:natural) return std_logic is
  begin
  	if (s=0) then
  		return arg;
  	end if;
    return '0';
  end sllBit;
  
  function srlUint(arg: unsigned; s:natural) return unsigned is
  begin
    return SHIFT_RIGHT(arg,s);
  end srlUint;
  function sraUint(arg: unsigned; s:natural) return unsigned is
  begin
    return SHIFT_RIGHT(arg,s);
  end sraUint;
  function sllUint(arg: unsigned; s:natural) return unsigned is
  begin
    return SHIFT_LEFT(arg,s);
  end sllUint;
  
  function srlInt(arg: signed; s:natural) return signed is
  begin
    return SIGNED(SHIFT_RIGHT(UNSIGNED(ARG), s));
  end srlInt;
  function sraInt(arg: signed; s:natural) return signed is
  begin
    return SHIFT_RIGHT(arg,s);
  end sraInt;
  function sllInt(arg: signed; s:natural) return signed is
  begin
    return SHIFT_LEFT(arg,s);
  end sllInt;
  
  function srlInteger(arg: integer; s:natural) return integer is
  begin
    return to_integer(SHIFT_RIGHT(to_UNSIGNED(ARG,32), s));
  end srlInteger;
  function sraInteger(arg: integer; s:natural) return integer is
  begin
    return to_integer(SHIFT_RIGHT(to_SIGNED(arg,32),s));
  end sraInteger;
  function sllInteger(arg: integer; s:natural) return integer is
  begin
    return to_integer(SHIFT_LEFT(to_SIGNED(arg,32),s));
  end sllInteger;
  
  function srlNatural(arg: natural; s:natural) return natural is
  begin
    return to_integer(SHIFT_RIGHT(to_UNSIGNED(ARG,32), s));
  end srlNatural;
  function sraNatural(arg: natural; s:natural) return natural is
  begin
    return to_integer(SHIFT_RIGHT(to_UNSIGNED(arg,32),s));
  end sraNatural;
  function sllNatural(arg: natural; s:natural) return natural is
  begin
    return to_integer(SHIFT_LEFT(to_UNSIGNED(arg,32),s));
  end sllNatural;
end; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package Casts is

	function max (LEFT, RIGHT: INTEGER) return INTEGER ;

	function min (LEFT, RIGHT: INTEGER) return INTEGER ;
	function intToUint (ARG : signed) return unsigned;
	function intToBit (ARG : signed) return std_logic;
	function intToBitvector (ARG : signed) return std_logic_vector;
	function intToInteger (ARG : signed) return integer;
	function intToNatural (ARG : signed) return natural;
	function uintToInt (ARG : unsigned) return signed;
	function uintToBit (ARG : unsigned) return std_logic;
	function uintToBitvector (ARG : unsigned) return std_logic_vector;
	function uintToInteger (ARG : unsigned) return integer;
	function uintToNatural (ARG : unsigned) return natural;
	function bitToInt (ARG : std_logic) return signed;
	function bitToUint (ARG : std_logic) return unsigned;
	function bitToBitvector (ARG : std_logic) return std_logic_vector;
	function bitToInteger (ARG : std_logic) return integer;
	function bitToNatural (ARG : std_logic) return natural;

	
	function bitvectorToInt (ARG : std_logic_vector) return signed;
	function bitvectorToUint (ARG : std_logic_vector) return unsigned;
	function bitvectorToBit (ARG : std_logic_vector) return std_logic;
	function bitvectorToInteger (ARG : std_logic_vector) return integer;
	function bitvectorToNatural (ARG : std_logic_vector) return natural;

	

	function bitvectorToInt (ARG : unsigned) return signed;
	function bitvectorToUint (ARG : unsigned) return unsigned;
	function bitvectorToBit (ARG : unsigned) return std_logic;
	function bitvectorToInteger (ARG : unsigned) return integer;
	function bitvectorToNatural (ARG : unsigned) return natural;

	

	function bitvectorToInt (ARG : signed) return signed;
	function bitvectorToUint (ARG : signed) return unsigned;
	function bitvectorToBit (ARG : signed) return std_logic;
	function bitvectorToInteger (ARG : signed) return integer;
	function bitvectorToNatural (ARG : signed) return natural;

	
	function integerToInt (ARG : integer) return signed;
	function integerToUint (ARG : integer) return unsigned;
	function integerToBit (ARG : integer) return std_logic;
	function integerToBitvector (ARG : integer) return std_logic_vector;
	function integerToNatural (ARG : integer) return natural;
	function naturalToInt (ARG : natural) return signed;
	function naturalToUint (ARG : natural) return unsigned;
	function naturalToBit (ARG : natural) return std_logic;
	function naturalToBitvector (ARG : natural) return std_logic_vector;
	function naturalToInteger (ARG : natural) return integer;

	function strToUnsigned (S : string) return unsigned;
	--function strToSigned (S : string) return signed;
	function resizeSLV(S:std_logic_vector; NEWSIZE:natural) return std_logic_vector;
	
	function accessBits(S:std_logic_vector; beginRange: natural; endRange: natural) return std_logic_vector;
	function accessBits(S:signed; beginRange: natural; endRange: natural) return std_logic_vector;
	function accessBits(S:unsigned; beginRange: natural; endRange: natural) return std_logic_vector;
	--function accessBits(S:natural; beginRange: natural; endRange: natural) return std_logic_vector;
	function accessBits(S:integer; beginRange: natural; endRange: natural) return std_logic_vector;
	function accessBits(S:std_logic; beginRange: natural; endRange: natural) return std_logic_vector;
end;
package body Casts is

  function MAX (LEFT, RIGHT: INTEGER) return INTEGER is
  begin
    if LEFT > RIGHT then return LEFT;
    else return RIGHT;
    end if;
  end MAX;

  function MIN (LEFT, RIGHT: INTEGER) return INTEGER is
  begin
    if LEFT < RIGHT then return LEFT;
    else return RIGHT;
    end if;
  end MIN;


	function intToUint (ARG : signed) return unsigned is
	begin
		return unsigned(ARG);
	end;
	function intToBit (ARG : signed) return std_logic is
	begin
		if (ARG/=0) then
			return '1';
		else
			return '0';
		end if;
	end;
	function intToBitvector (ARG : signed) return std_logic_vector is
	begin
		return std_logic_vector(ARG);
	end;
	function intToInteger (ARG : signed) return integer is
	begin
		return to_integer(ARG);
	end;
	function uintToInt (ARG : unsigned) return signed is
	begin
		return signed(ARG);
	end;
	function uintToBit (ARG : unsigned) return std_logic is
	begin
		if (ARG/=0) then
			return '1';
		else
			return '0';
		end if;
	end;
	function uintToBitvector (ARG : unsigned) return std_logic_vector is
	begin
		return std_logic_vector(ARG);
	end;
	function uintToInteger (ARG : unsigned) return integer is
	begin
		return to_integer(signed(ARG));
	end;
	function bitToInt (ARG : std_logic) return signed is
	begin
		if (ARG/='0') then
			return to_signed(1,2);
		else
			return to_signed(0,2);
		end if;
	end;
	function bitToUint (ARG : std_logic) return unsigned is
	begin
		if (ARG/='0') then
			return to_unsigned(1,2);
		else
			return to_unsigned(0,2);
		end if;
	end;
	function bitToBitvector (ARG : std_logic) return std_logic_vector is

		variable res: std_logic_vector(0 downto 0);
	begin
		res(0):=ARG;
		return res;
	end;
	function bitToInteger (ARG : std_logic) return integer is
	begin
		if (ARG/='0') then
			return 1;
		else
			return 0;
		end if;
	end;
	
	
	function bitvectorToInt (ARG : std_logic_vector) return signed is
	begin
		return signed(ARG);
	end;
	function bitvectorToUint (ARG : std_logic_vector) return unsigned is
	begin
		return unsigned(ARG);
	end;
	function bitvectorToBit (ARG : std_logic_vector) return std_logic is
	begin
		if (ARG/=(ARG'range=>'0')) then
			return '1';
		else
			return '0';
		end if;
	end;
	function bitvectorToInteger (ARG : std_logic_vector) return integer is
	begin
		return to_integer(signed(ARG));
	end;
	
	function bitvectorToInt (ARG : signed) return signed is
	begin
		return ARG;
	end;
	function bitvectorToUint (ARG : signed) return unsigned is
	begin
		return unsigned(ARG);
	end;
	function bitvectorToBit (ARG : signed) return std_logic is
	begin
		if (ARG/=(ARG'range=>'0')) then
			return '1';
		else
			return '0';
		end if;
	end;
	function bitvectorToInteger (ARG : signed) return integer is
	begin
		return to_integer(signed(ARG));
	end;
	
	function bitvectorToInt (ARG : unsigned) return signed is
	begin
		return signed(ARG);
	end;
	function bitvectorToUint (ARG : unsigned) return unsigned is
	begin
		return ARG;
	end;
	function bitvectorToBit (ARG : unsigned) return std_logic is
	begin
		if (ARG/=(ARG'range=>'0')) then
			return '1';
		else
			return '0';
		end if;
	end;
	function bitvectorToInteger (ARG : unsigned) return integer is
	begin
		return to_integer(signed(ARG));
	end;
	
	function integerToInt (ARG : integer) return signed is
	begin
		return to_signed(ARG,32);
	end;
	function integerToUint (ARG : integer) return unsigned is
	begin
		return to_unsigned(ARG,32);
	end;
	function integerToBit (ARG : integer) return std_logic is
	begin
		if (ARG/=0) then
			return '1';
		else
			return '0';
		end if;
	end;
	function integerToBitvector (ARG : integer) return std_logic_vector is
	begin
		return std_logic_vector(to_signed(ARG,32));
	end;

	function intToNatural (ARG : signed) return natural is
	begin
		return to_integer(unsigned(ARG));
	end;
	function uintToNatural (ARG : unsigned) return natural is
	begin
		return to_integer(ARG);
	end;
	function bitToNatural (ARG : std_logic) return natural is
	begin
		if (ARG/='0') then
			return 1;
		else
			return 0;
		end if;
	end;
	function bitvectorToNatural (ARG : std_logic_vector) return natural is
	begin
		return to_integer(unsigned(ARG));
	end;
	function bitvectorToNatural (ARG : unsigned) return natural is
	begin
		return to_integer(ARG);
	end;
	function bitvectorToNatural (ARG : signed) return natural is
	begin
		return to_integer(unsigned(ARG));
	end;
	function integerToNatural (ARG : integer) return natural is
	begin
		return ARG;
	end;
	function naturalToInt (ARG : natural) return signed is
	begin
		return to_signed(ARG,32);
	end;
	function naturalToUint (ARG : natural) return unsigned is
	begin
		return to_unsigned(ARG,32);
	end;
	function naturalToBit (ARG : natural) return std_logic is
	begin
		if (ARG/=0) then
			return '1';
		else
			return '0';
		end if;
	end;
	function naturalToBitvector (ARG : natural) return std_logic_vector is
	begin
		return std_logic_vector(to_unsigned(ARG,32));
	end;
	function naturalToInteger (ARG : natural) return integer is
	begin
		return ARG;
	end;

	function strToUnsigned (S : string) return unsigned is
		variable ret : unsigned(S'right - 1 downto 0);
	begin
		for i in S'range loop
			if S(i) = '1' then
				ret(S'right - i) := '1';
			else
				ret(S'right - i) := '0';
			end if;
		end loop;
		return ret;
	end;
-- 	function strToSigned (S : string) return signed is
-- 		variable ret : signed(S'right - 1 downto 0);
-- 	begin
-- 		for i in S'range loop
-- 			if S(i) = '1' then
-- 				ret(S'right - i) := '1';
-- 			else
-- 				ret(S'right - i) := '0';
-- 			end if;
-- 		end loop;
-- 		if S(S'left)='-' then
-- 			return -ret;
-- 		else
-- 			return ret;
-- 		end if;
-- 	end;

	function resizeSLV(S:std_logic_vector; NEWSIZE:natural) return std_logic_vector is
	begin
		return std_logic_vector(resize(unsigned(S),NEWSIZE));
	end;
	
	function accessBits(S:std_logic_vector; beginRange: natural; endRange: natural) return std_logic_vector is
	begin
		if (beginRange=endRange) then
			return S(beginRange downto beginRange);
		elsif (beginRange>endRange) then
			return S(beginRange downto endRange);
		else
			return S(beginRange to endRange);
		end if;
	end;
	
	function accessBits(S:signed; beginRange: natural; endRange: natural) return std_logic_vector is
	begin
		return accessBits(std_logic_vector(S),beginRange,endRange);
	end;
	function accessBits(S:unsigned; beginRange: natural; endRange: natural) return std_logic_vector is
	begin
		return accessBits(std_logic_vector(S),beginRange,endRange);
	end;
--	function accessBits(S:natural; beginRange: natural; endRange: natural) return std_logic_vector is
--	begin
--		return accessBits(std_logic_vector(S),beginRange,endRange);
--	end;
	function accessBits(S:integer; beginRange: natural; endRange: natural) return std_logic_vector is
	begin
		return accessBits(integerToBitvector(S),beginRange,endRange);
	end;
	function accessBits(S:std_logic; beginRange: natural; endRange: natural) return std_logic_vector is
	begin

		assert(beginRange=0);

		assert(endRange=0);
		return bitToBitvector(S);
	end;
	
end;
