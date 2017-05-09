library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.std_logic_signed.all;

entity power_factor_calc is 

port( 
	input_flag: in std_logic;	
	in_real_power: in unsigned (11 downto 0):=(others => '0') ;
	in_apparent_power: in unsigned (11 downto 0):=(others => '0');	
	power_factor: out unsigned(11 downto 0):=(others => '0')
	);

---------------------------------------------------------------------------------------------------------
function  divide  (a : UNSIGNED; b : UNSIGNED) return UNSIGNED is
variable a1 : unsigned(a'length-1 downto 0):=a;
variable b1 : unsigned(b'length-1 downto 0):=b;
variable p1 : unsigned(b'length downto 0):= (others => '0');
variable i : integer:=0;

begin
for i in 0 to b'length-1 loop
p1(b'length-1 downto 1) := p1(b'length-2 downto 0);
p1(0) := a1(a'length-1);
a1(a'length-1 downto 1) := a1(a'length-2 downto 0);
p1 := p1-b1;
if(p1(b'length-1) ='1') then
a1(0) :='0';
p1 := p1+b1;
else
a1(0) :='1';
end if;
end loop;
return a1;

end divide;
----------------------------------------------------------------------------------------------------------

end entity power_factor_calc;
 


architecture behavioral of power_factor_calc is 

--Create a signal that identifies if inductive or capacitive

--signal real_power_int : integer:= 0;
--signal  apparent_power_int: integer := 0;
--signal LC: integer:= 0; -- changes if inductive or capacitive 
--signal multiply: integer :=0;
-- signal conatant_num: integer:= 32768; -- 2^16
--signal lead_or_lag: integer:= 0;
--signal vector: std_logic_vector(15 downto 0):=(others => '0');

signal zero:unsigned(11 downto 0):=(others => '0');

--signal real_power_uns: unsigned(15 downto 0) :=(others => '0');
--signal apparent_power_uns: unsigned(15 downto 0) :=(others => '0');
--signal a : unsigned(15 downto 0) :=(others => '0');
--signal b : unsigned(15 downto 0) :=(others => '0');
--signal c : unsigned(15 downto 0) :=(others => '0');


begin

	--real_power_int <= to_integer(signed(in_real_power)); -- Turning the input data into an integer
	--apparent_power_int <= to_integer(signed(in_apparent_power)); -- Turning the input data into an integer


	--real_power_uns <= unsigned(in_real_power);
	--apparent_power_uns <= unsigned(in_apparent_power);
	
	--a <= real_power_uns;
	--b <= apparent_power_uns;



	--process(input_flag)
	process(in_real_power,in_apparent_power)
	begin 
  	--if rising_edge(input_flag) then
	if ( in_apparent_power /= zero) then 
		if (in_real_power /= zero) then 
			power_factor <= divide ( in_real_power , in_apparent_power ); -- Calling function 
		else 
			power_factor <= zero;
		end if;
	else
	power_factor <= zero;

	--multiply <= real_power_int / apparent_power_int; -- 2^16 is used to right shift for binary math, however, because 
							--  in_real_power and in_apparent_power is turned into integer, we dont have to shift it 
	--vector <= std_logic_vector((c));
	end if;
	


-- how to find if its capacitive or inductive, why add 1 or 0
	--if (lead_or_lag = 0) then -- Changing the 15 bit value to 1 for capcitive 0 for inductive
	--vector(15) <='1';
	--else 
	--vector(15) <='0'; 
	--end if;
	--power_factor <= vector;
	end process;
end architecture behavioral;

