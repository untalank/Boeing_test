
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.STD_LOGIC_unsigned.ALL;
--use IEEE.std_logic_arith.all;
entity rms_calc is 

port( 
	input_flag : in std_logic; -- Used to trigger the first process 
	input_data: in signed (12 downto 0); -- 12 bit value input, either voltage or current -Change these to 12 bits 
	rms_amplitude: out unsigned(11 downto 0):= (others => '0'); -- 12 bit voltage or current RMS output -- in (mili Volts or miliAmps)
	output_flag: out std_logic:= '0' -- Flag that goes to 1 when the calculation is done 
	);

end entity rms_calc;
architecture behavioral of rms_calc is


component squart is port(  --Component that is called to calculate the square root 
flag      : in std_logic;
data_in    : in unsigned(44 downto 0); 
data_out   : out unsigned(11 downto 0); 
output_flag_component: out std_logic:= '0');
end component;



signal power: integer:=0; --unsigned(25 downto 0):=(others => '0'); -- Variable that holds the squared voltage or current data sample 

signal counter: integer:=0; -- Used to trigger the next process to finish the rest of the calculations 

signal summation: integer:=0;--unsigned(32 downto 0):=(others => '0'); -- Variable that holds the summed squared voltage and current data sample  

--signal summation_334: unsigned(32 downto 0):=(others => '0'); -- Variable that holds the summation before it get zeroed out 

signal multiply: unsigned(11 downto 0):= "110001000011"; ---- 1/334 (1/number of smaples)in binary that was Rigth shift 20 bits 

signal inside_sqrt:  unsigned(44 downto 0):=(others => '0'); -- Variable that is being passed to the component 

signal zero:unsigned(44 downto 0):=(others => '0'); -- Variable being used to zero out other variables 

constant one: integer:= 1; -- Constant for counter 


begin 

	sqrt_call: squart port map(input_flag,inside_sqrt,rms_amplitude,output_flag);
	process(input_flag) --Process that triggers every time there is a data input. 
	begin
	if (input_flag'event and input_flag = '1') then
		
		case counter is
				
		--when (333) =>
		--power <= input_data*input_data;	
		--summation_334 <= summation ; -- Summation will be passed before being zeored out 
		--summation <= zero(32 downto 0);
		--counter <= counter + 1;
		
		when (335) =>
		power <= to_integer(input_data*input_data);--Second Power 
		inside_sqrt <= to_unsigned(summation,33) * multiply; --Summation is 334 * 3139 
		summation <= power ;--First power 
		counter <=  2;
		when others => -- Case statement that repeats until the 333  is reached 
		power <= to_integer(input_data*input_data);
		summation <= summation + power; -- Running summation of the squared input voltage 
		counter <= counter + one; -- Counter that triggers the next process 
		inside_sqrt <= zero;
		end case;

	end if; 
	end process; 
	
end architecture behavioral;



	

	