library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apperent_power_calc is 
port( 
	input_flag: in std_logic;	-- Used to trigger the first process 
	in_Vrms: in unsigned (11 downto 0); 
	in_Irms: in unsigned (11 downto 0); 
	apparent_power: out unsigned (11 downto 0) -- HAVE TO ADD 12 zeros 
);
end entity apperent_power_calc;
 
architecture behavioral of apperent_power_calc is 

signal I_times_V: unsigned(23 downto 0):= (others => '0'); -- Signal that hold the product of Irms * Vrms 

begin

	process(input_flag) --Creating a process so the program will run sequencialy instead of concurrently
	begin 
	if (input_flag'event and input_flag = '1') then --This process will trigger when the Irms and Vrms are inputted 
	I_times_V <= in_Vrms*in_Irms; 
	apparent_power <= I_times_V(23 downto 12); -- Because the output is too small, make sure to add 12 zeros after the binary value to see the correct output
	end if;

	end process;
end architecture behavioral;
	
