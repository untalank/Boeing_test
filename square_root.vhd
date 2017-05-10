library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_unsigned.ALL;

entity squart is port( 
clock      : in std_logic;  
data_in    : in unsigned(44 downto 0):=(others => '0'); 
data_out   : out unsigned(11 downto 0):=(others => '0')
	);

end entity squart;

architecture sqrt of  squart is 

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

 
	signal leftshifted_unsigned: unsigned(31 downto 0):=(others => '0'); --Putting the left shifted unsigned(32 bit) here
	signal zero:unsigned(44 downto 0):=(others => '0');
	signal sqrt_output: unsigned(15 downto 0):=(others => '0'); -- Holder for the output of sqrt function 
	signal count: integer:=0;
begin
	process(clock)
	begin 
	if rising_edge(clock) then
	
		if(data_in/= zero) then
		leftshifted_unsigned(24 downto 0) <= ( data_in(44 downto 20));	
		end if;

		if (leftshifted_unsigned/= zero(31 downto 0)) then
		sqrt_output <= sqrt_real(leftshifted_unsigned);
		count<=2;
		leftshifted_unsigned <= zero(31 downto 0);
		end if; 

		if (sqrt_output /= zero( 15 downto 0)) then 
		data_out <= sqrt_output(11 downto 0); -- Changing the integer into 12 bit 
		sqrt_output <= zero(15 downto 0);
		end if;
		
		else 
		null;

	end if;

	end process;

end architecture;



