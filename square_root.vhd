library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

--use IEEE.STD_LOGIC_unsigned.ALL;

entity squart is port( 
clock      : in std_logic;  
data_in    : in std_logic_vector(11 downto 0); 
data_out   : out std_logic_vector(11 downto 0)); 
end squart;

architecture sqrt of  squart is 

--package my_sqrt is 
--	function  sqrt_real  ( d : unsigned ) return unsigned;
--end my_sqrt;

--package body my_sqrt is

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



--end package body;
	signal holder: unsigned(31 downto 0):=(others => '0');
	signal holder_out: unsigned(15 downto 0):=(others => '0');
	signal twelve:unsigned(11 downto 0):=(others => '0');
	signal unsigned_to_vector: std_logic_vector(11 downto 0);
 begin
	
	holder(11 downto 0) <= unsigned(data_in);
	holder_out <= sqrt_real(holder);
	twelve <= holder_out(11 downto 0);
	unsigned_to_vector <= std_logic_vector((twelve));
	data_out <= unsigned_to_vector;
	

	--signal a : unsigned(31 downto 0) :="00000000000000000000000000110010";   --50
	--signal b : unsigned(15 downto 0) :=(others => '0');
	
--	begin

--	b <= sqrt_real ( a );  --function is "called" here.
end architecture sqrt; 


