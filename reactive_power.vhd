library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reactive_power_calc is 

port( 
	input_flag: in std_logic;	
	in_real_power: in std_logic_vector (15 downto 0);
	in_apparent_power: in std_logic_vector (15 downto 0);	
	reactive_power: out std_logic_vector(15 downto 0)
	);
end entity reactive_power_calc;
 
architecture behavioral of reactive_power_calc is 

signal real_power_int : integer:= 0; -- Signal that hold the integer value of the real power input 
signal apparent_power_int: integer := 0;
signal real_squared: integer := 0;
signal apparent_squared: integer := 0;
signal multiply: integer := 0;
signal sqrt: integer := 0;

constant one: integer := 1;
constant two: integer := 2;

begin 
	process(input_flag)
	begin 
	if (rising_edge(input_flag))then --This process trigegrs when the variable is inputed 
	real_power_int <= to_integer(signed(in_real_power)); -- Turning the input data into an integer
	apparent_power_int <= to_integer(signed(in_apparent_power)); -- Turning the input data into an integer
	real_squared <= real_power_int ** two; --PWR ^2
	apparent_squared <= apparent_power_int ** two; -- APR ^2
	multiply <= real_squared * apparent_squared; -- PWR ^2 *  APR ^2 
	sqrt <= multiply ** (one/two); -- sqrt(multiply)
	reactive_power <= std_logic_vector(to_signed(sqrt, reactive_power'length)); -- Turning sqrt into 16 bit binary value 
	end if; 
	end process;
end behavioral;