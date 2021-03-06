library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_unsigned.ALL;

entity squart is port( 
flag      : in std_logic;  
data_in    : in unsigned(44 downto 0):=(others => '0'); 
data_out   : out unsigned(11 downto 0):=(others => '0');
output_flag_component: out std_logic := '0'
	);

end entity squart;

architecture sqrt of  squart is 
------------------------------------------------------------------------------------------------------------
------Function that does the square root. Takes in a 32 bit unsigned, and outputs a 15 bit unsigned.--------
------------------------------------------------------------------------------------------------------------
	function  sqrt_real  ( d : unsigned ) return unsigned is
	variable a : unsigned(31 downto 0):=d;  --original input.
	variable q : unsigned(15 downto 0):=(others => '0');  --result.
	variable left,right,r : unsigned(17 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
	variable i : integer:=0;
	variable x: std_logic_vector(15 downto 0);
--
	begin
		for i in 0 to 15 loop
		right(0):='1';
		right(1):=r(17);
		right(17 downto 2):=q;
		left(1 downto 0):=a(31 downto 30);
		left(17 downto 2):=r(15 downto 0);
		a(31 downto 2):=a(29 downto 0);  --shifting by 2 bit.
		if ( r(17) = '1') then
			r := left + right;
		else
			r := left - right;
		end if;
		q(15 downto 1) := q(14 downto 0);
		q(0) := not r(17); 
		end loop;	
		return q;

	end function sqrt_real;

 -----------------------------------------------------------------------------------
	
	signal leftshifted_unsigned: unsigned(31 downto 0):=(others => '0'); --Putting the left shifted unsigned(32 bit) here
	signal zero:unsigned(44 downto 0):=(others => '0'); -- Used to reset signals 
	signal sqrt_output: unsigned(15 downto 0):=(others => '0'); -- Holder for the output of sqrt function 
	signal out_flag: std_logic:='0';

begin
	process(flag) -- Everytime there is data_in 
	begin 
	if (flag'event and flag = '1') then -- Used for simmulation 
	output_flag_component <= out_flag;
		if(data_in/= zero) then
		leftshifted_unsigned(24 downto 0) <= ( data_in(44 downto 20));	--Left shifts in order to compinsate for the 20 right shift from 1/334 
		end if;

		if (leftshifted_unsigned/= zero(31 downto 0)) then
		sqrt_output <= sqrt_real(leftshifted_unsigned); --Calling the square root function here
		leftshifted_unsigned <= zero(31 downto 0); --Reset 
		end if; 

		if (sqrt_output /= zero( 15 downto 0)) then 
		data_out <= sqrt_output(11 downto 0); -- Shifting the variable to a 12 bit unsigned as the output of rms 
		sqrt_output <= zero(15 downto 0); --Reset
		out_flag <= '1'; --Out_flag turns 1 when done
		end if;
		
		if(out_flag = '1') then
		out_flag <= '0'; -- Reset
		
		end if;
		

	end if;

	end process;

end architecture;



