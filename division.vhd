library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div is 
	
port( 
	numerator: unsigned(11 downto 0);
	denaminator: unsigned(11 downto 0);
	quotient: out unsigned(11 downto 0)
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

signal zero:unsigned(11 downto 0):=(others => '0');

	begin

--a <= unsigned(numerator);
--b <= unsigned(denaminator);


	process(numerator,denaminator)
	  begin 
	  	if (denaminator /= zero) then
			if(numerator/= zero) then
				quotient <= divide ( numerator , denaminator );  --function is "called" here.
			else 
				quotient <= zero;
			end if;
		else 
		quotient <= zero;
	  	end if;
	
	end process;

end architecture; 
