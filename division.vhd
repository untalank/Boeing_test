library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div is 
	
port( clk: in std_logic;
	numerator: std_logic_vector(15 downto 0);
	denaminator: std_logic_vector(15 downto 0);
	quotient: out std_logic_vector(15 downto 0)
	);




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

end entity;

architecture behavioral of div is 
--constant const_val       : unsigned(14 downto 0) := to_unsigned(1927,15);
--signal val_in              : unsigned(7 downto 0);
--signal valIn_x_const_val   : unsigned(22 downto 0);
--signal val_out             : unsigned(7 downto 0);
--begin
--process(clk)
--  	begin 
--  	if rising_edge(clk) then
  -- ONLY TRUNCATION
--  		valIn_x_const_val <= val_in * const_val;
--  		val_out           <= valIn_x_const_val(22 downto 15);
 -- ROUNDING
--  		valIn_x_const_val <= val_in * const_val + (2**14);
--  		val_out           <= valIn_x_const_val(22 downto 15);
--  	end if;
--	quotient <= std_logic_vector(val_out);
--end process; 

signal a : unsigned(15 downto 0);-- :="10011100";
signal b : unsigned(15 downto 0);-- :="00001010";
signal c : unsigned(15 downto 0) :=(others => '0');


begin

a <= unsigned(numerator);
b <= unsigned(denaminator);


process(clk)
  	begin 
  	if rising_edge(clk) then
	c <= divide ( a , b );  --function is "called" here.
	end if;
	quotient <= std_logic_vector(c);
end process;

end architecture; 
