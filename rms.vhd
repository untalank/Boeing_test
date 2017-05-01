library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.std_logic_signed.all;
entity rms_calc is 

port( 
	input_flag : in std_logic; -- Used to trigger the first process 
	input_data: in std_logic_vector (11 downto 0); -- 13 bit value input, either voltage or current -Change these to 12 bits 
	rms_amplitude: out std_logic_vector(11 downto 0) -- 16 bit voltage or current RMS output --Change these to 12 bits 
	);

	


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                          Creating the function for sqrt 
	function  sqrt_real  ( d : unsigned ) return unsigned is
	variable a : unsigned(31 downto 0):=d;  --original input.
	variable q : unsigned(15 downto 0):=(others => '0');  --result.
	variable left,right,r : unsigned(17 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
	variable i : integer:=0;
	variable x: std_logic_vector(15 downto 0);
--
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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




end entity rms_calc;
architecture behavioral of rms_calc is
signal input_sample: integer:=0; -- Signal that holds the bit vector that was transformed into an integer
signal inside_sqrt: integer:=0;
signal power: integer := 0; -- Variable that holds the squared voltage or current data sample 
signal counter: integer:=0; -- Used to trigger the next process to finish the rest of the calculations 

signal unsigned_inside_sqrt: unsigned(31 downto 0):=(others => '0'); -- Used to change the integer inside the sqrt to an unsigned 32 bit
signal leftshifted_unsigned: unsigned(31 downto 0):=(others => '0'); --Putting the left shifted unsigned(32 bit) here


signal sqrt_output: unsigned(15 downto 0):=(others => '0'); -- Holder for the output of sqrt function 



signal place_holder_vector: std_logic_vector(11 downto 0):=(others => '0'); --Changing the sqrt_output into a std_logic_vector


signal twelve_out: unsigned (11 downto 0):=(others => '0');




signal summation: integer:= 0; -- Variable that holds the summed squared voltage and current data sample  
constant multiply: integer:= 13; ---- 1/5050 (1/number of smaples)in binary that was Rigth shift 16 bits 
constant number_of_samples: integer := 5051;
constant one: integer:= 1;
constant two: integer:=2;






begin 
	input_sample <= to_integer(unsigned(input_data)); -- Turning the input data into an integer
	process(input_flag) --Process that triggers every time there is a data input. 
	begin
	if rising_edge(input_flag) then
		if (counter < number_of_samples) then -- If statement that repeats until the number of samples is reached 
		power <= input_sample**two; --Squaring the input sample 
		summation <= summation + power; -- Running summation of the squared input voltage 
		counter <= counter + one; -- Counter that triggers the next process 
		end if;
	end if;
	end process;
	process(counter) --Process that triggers after the summation is done
	begin
	if (counter = 5050) then

	inside_sqrt <= summation * multiply; -- Multiplying the total summation with 13 
	
	unsigned_inside_sqrt <= to_unsigned(inside_sqrt,unsigned_inside_sqrt'length);

	leftshifted_unsigned(15 downto 0) <= unsigned_inside_sqrt(31 downto 16); -- Putting the leftshifted binary value inside leftshifted_unsigned for the sqrt function
	
	sqrt_output <= sqrt_real(leftshifted_unsigned);
	
	twelve_out <= sqrt_output(11 downto 0);

	place_holder_vector <= std_logic_vector(twelve_out); -- Changing the integer into 12 bit std_logic_vector
	


	rms_amplitude<= place_holder_vector;
	end if; 
end process; 
end architecture behavioral;
















--	rms_amplitude <= std_logic_vector(to_signed(inside_sqrt, rms_amplitude'length));

		--rms_amplitude <= std_logic_vector(to_signed(inside_sqrt, rms_amplitude'length));
	--vector <= place_holder_vector(31 downto 15);	
	--rms_amplitude<= vector;
	


-- signal number_of_samples: std_logic;

--signal numerator: 

--signal	sig_process: std_logic; -- Using as process trigger 
--signal samples_integer: integer;
--signal one_over_n: integer; 
--signal summation: integer;

--signal rms: integer;




     --   signal numerator: signed(15 downto 0);
     --   signal denominator: signed(15 downto 0);
	--signal result: float(6 downto -9);
   -- subtype float16 is float(6 downto -9);
   -- signal numerator_float: float16;
   -- signal denominator_float: float16;


 	--
	--one_over_n <= one / samples_integer; --1/N
	
	--process (one_over_n)
	--begi
	--for i in 1 to 5050 loop    -- Creating the summation of di^2 this wont work  
	--summation <= summation + Voltage_sample ** two;
	--end loop;
	--end process; 
	
	
	
	--inside_sqrt <= one_over_n * summation**2;
	
	---sqrt_of_Voltage <= math_real.sqrt(inside_sqrt);
	--sqrt_of_Voltage <= inside_sqrt ** (one/two);
	
	--rms <= eight * sqrt_of_Voltage;
	--ex <= one/two;
	--rms <= 4 **ex;


  --  numerator_float <= to_float(numerator, numerator_float);
--    denominator_float <= to_float(denominator, denominator_float);
 --   result <= numerator_float / denominator_float;







	--rms_amplitude <= std_logic_vector(to_signed(result, rms_amplitude'length));

	


	
	

	