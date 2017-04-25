library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apperent_power_calc is 
port( 
	input_flag: in std_logic;	-- Used to trigger the first process 
	in_Vrms: in std_logic_vector (15 downto 0); 
	in_Irms: in std_logic_vector (15 downto 0);	
	apparent_power: out std_logic_vector(15 downto 0)


	);
end entity apperent_power_calc;
 
architecture behavioral of apperent_power_calc is 

signal I_rms_int: integer:= 0; -- Signal used to hold the bit vector that are transformed into an integer
signal V_rms_int: integer:= 0;
signal I_times_V: integer:= 0; -- Signal that hold the product of Irms * Vrms 

begin
-- need to get the V_rms calculations 

	V_rms_int <= to_integer(signed(in_Vrms)); -- Changing the std_logic_vector into a signed vector, and then making it an integer 
	I_rms_int <= to_integer(signed(in_Irms));

	process(input_flag) --Creating a process so the program will run sequencialy instead of concurrently
	begin 

	if (input_flag'event and input_flag = '1') then --This process will trigger when the Irms and Vrms are inputted 

	I_times_V <= I_rms_int*V_rms_int; -- Irms*Vrms, because we're turning the bit vectors into integers, we do not need to left shift it 16 bit to make sure 
					-- the output is a 16 bit value
	apparent_power <= std_logic_vector(to_unsigned(I_times_V, apparent_power'length)); -- Turning the integer into a 16 bit binary value 
	
	end if;

	end process;
end architecture behavioral;
	
