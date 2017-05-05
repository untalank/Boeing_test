library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity real_power_component is 
port( 
	input_flag: in std_logic; --Using as process trigger 
	data_in    : in unsigned(40 downto 0):=(others => '0'); 
	data_out   : out unsigned(11 downto 0):=(others => '0')
	);
end entity;

architecture behavioral of real_power_component is 
	signal leftshifted_unsigned: unsigned(31 downto 0):=(others => '0'); --Putting the left shifted unsigned(32 bit) here
	signal zero:unsigned(40 downto 0):=(others => '0');

begin
process(input_flag)
	begin 
	if rising_edge(input_flag) then
	
		if(data_in/= zero) then
		leftshifted_unsigned(24 downto 0)<= ( data_in(40 downto 16));
		
		end if;

		if (leftshifted_unsigned/= zero(31 downto 0)) then
		data_out <= leftshifted_unsigned(11 downto 0);
		leftshifted_unsigned <= zero(31 downto 0);
		end if; 

		else 
		null;

	end if;
	
	
	end process;
end architecture;