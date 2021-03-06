library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity real_power_component is 
port( 
	input_flag: in std_logic; --Using as process trigger 
	data_in    : in unsigned(44 downto 0):=(others => '0'); 
	data_out   : out unsigned(11 downto 0):=(others => '0');
	output_flag : out std_logic
	);
end entity;

architecture behavioral of real_power_component is 
	signal leftshifted_unsigned: unsigned(31 downto 0):=(others => '0'); --Putting the left shifted unsigned(32 bit) here
	signal zero:unsigned(44 downto 0):=(others => '0');
	signal flag: std_logic := '0';
begin
process(input_flag)
	begin 
	if (input_flag'event and input_flag = '1') then
	output_flag <= flag;
		if(data_in/= zero) then
		leftshifted_unsigned(24 downto 0)<= ( data_in(44 downto 20)); --When values too small, no output will be recorded. 
		end if;

		if (leftshifted_unsigned/= zero(31 downto 0)) then
		data_out <= leftshifted_unsigned(24 downto 13);
		leftshifted_unsigned <= zero(31 downto 0);
		flag <= '1';
		end if; 

		if ( flag = '1') then 
		flag <= '0';
		end if;

	end if;
	
	end process;
end architecture;