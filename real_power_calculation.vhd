library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity real_power_calc is 
port( 
	input_flag: in std_logic; --Using as process trigger 
	Voltage_in: in unsigned(11 downto 0); -- Voltage input coming from ADC IP
	Current_in: in unsigned(11 downto 0); -- Current input coming from ADC IP 
	Real_power:  out unsigned(11 downto 0) -- Real power coming out of the function 
	);
end entity;
architecture behavioral of real_power_calc is 
	--signal voltage: integer:= 0; -- Signals used to hold the voltage input that was changed 
	--signal current: integer:= 0;
	--signal multiplier_1: integer:= 0; -- 
	--signal power: integer:= 0; -- 
	--signal div: integer:= 0; --
	--signal mult_2: integer:= 0;
	--signal mult_const_power:integer:= 0;
	--signal n_counter: integer:=0;
	--signal multiplier_sum: integer:= 0;
	--constant data_sample_number: integer:=5051;
	constant one: integer:= 1;
	--constant two: integer:=2;
	--constant ten: integer:=10;

	signal counter: integer:=0;
	signal power: unsigned(23 downto 0):= (others => '0');
	signal zero:unsigned(40 downto 0):=(others => '0');
	signal summation: unsigned(36 downto 0):=(others => '0');
	signal summation_5050: unsigned(36 downto 0):=(others => '0');

	signal multiply: unsigned(3 downto 0):= "1101"; ---- 1/5050 (1/number of smaples)in binary that was Rigth shift 16 bits 

	signal inside_sqrt:  unsigned(40 downto 0):=(others => '0');

	component real_power_component is 
	port( 
		input_flag: in std_logic; --Using as process trigger 
		data_in    : in unsigned(40 downto 0):=(others => '0'); 
		data_out   : out unsigned(11 downto 0):=(others => '0')
		);
end component;



begin 
	--voltage <= to_integer(signed(Voltage_in)); --Turning the bit vectors into integers 
	--current <= to_integer(signed(Current_in));
	--power <= two ** ten; --2^10 this multiplier scaling factor to make it 16 bit	


	component_real_power: real_power_component port map (input_flag,inside_sqrt,Real_power);
	process(input_flag) -- Using a process so it will go down the line instead of running cuncurently 
	begin
	if (rising_edge(input_flag)) then --Testing to make sure the calculation run every

		case counter is
				
		when (5049) =>	
		summation_5050 <= summation ;
		summation <= zero(36 downto 0);
		counter <= counter + 1;
		
		when (5050) =>
		counter <= 0;
		summation <= summation + power; -- first input  
		inside_sqrt <= summation_5050 * multiply; -- Multiplying the total summation with 13 

		when others => -- If statement that repeats until the number of samples is reached 
		
		--power <= input_sample*input_sample; --Squaring the input sample 
		power <= Voltage_in*Current_in;
		summation <= summation + power; -- Running summation of the squared input voltage 
		counter <= counter + one; -- Counter that triggers the next process 
		inside_sqrt <= zero; --restting inside_sqrt when it leaves 5050 case
		end case;






	
--		if (n_counter < data_sample_number) then 	
--			multiplier_sum <= voltage * current;
--			n_counter <= n_counter + 1; -- Counter that trigegrs the next process 
--		end if ;
--	end if;
--	end process;
--	process(n_counter) -- Process that triggers after the summation is complete 
--	begin
--	if(n_counter = 5050) then	
--	multiplier_1 <= data_sample_number*power; -- N * 2^10 
--	div <= one / multiplier_1; -- 1 / (N*2^10)  
--	mult_2 <= voltage * current; -- Getting the power for the specific data input  Vi * Ii
--	mult_const_power <= mult_2 * div;
--	Real_power <= std_logic_vector(to_signed(mult_const_power, Real_power'length)); --Turning the integer into a 16 bit binary value
--	
	end if;
	end process;
end architecture behavioral; 
	
	
