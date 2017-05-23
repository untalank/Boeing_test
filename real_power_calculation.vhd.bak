library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity real_power_calc is 
port( 
	input_flag: in std_logic; --Using as process trigger 
	Voltage_in: in std_logic_vector(12 downto 0); -- Voltage input coming from ADC IP
	Current_in: in std_logic_vector(12 downto 0); -- Current input coming from ADC IP 
	Real_power:  out unsigned(11 downto 0); -- Real power coming out of the function NEED TO BE ADJUSTED 13 BITS  (ADD 13 ZEROS AFTER THE VALUE) (In uW) 
	flag_out: out std_logic --Variables that turns 1 when calculations is done
	);
end entity;
architecture behavioral of real_power_calc is 

	constant one: integer:= 1;

	signal counter: integer:=0; 
	signal power: integer:=0; --signed(25 downto 0):= (others => '0'); -- 24 bit unsigned, product of two 12 bit unsigned binary is 24 bit unsigned binary
	signal zero:unsigned(44 downto 0):=(others => '0'); -- Used to reset signals 
	signal summation: integer:=0;--unsigned(32 downto 0):=(others => '0'); -- The highest bit count when summing a 24 bit binary by 334 is 33 bit
	signal summation_334: integer:=0; --unsigned(32 downto 0):=(others => '0');
	signal multiply: unsigned(11 downto 0):= "110001000011"; ---- 1/334 (1/number of smaples)in binary that was Rigth shift 20 bits 
	signal inside_sqrt:  unsigned(44 downto 0):=(others => '0'); -- Product of summation_33(33 bit) and multiply (12 bit) is 45 bit unsigned
	signal inside: integer:= 0;
	component real_power_component is 
	port( 
		input_flag: in std_logic; 
		data_in    : in unsigned(44 downto 0):=(others => '0'); 
		data_out   : out unsigned(11 downto 0):=(others => '0');
		output_flag : out std_logic
		);
	end component;

begin 

	component_real_power: real_power_component port map (input_flag,inside_sqrt,Real_power,flag_out); --Lags 3 cycles before it outputs the value 												-- One is sending as zero, because the output lags 1 number to the real one 
	
	process(input_flag) -- Using a process so it will go down the line instead of running cuncurently 
	begin
	if (input_flag'event and input_flag = '1') then --When data is put in, it runs the process

		case counter is
				
		when (335) =>
		power <= to_integer(signed(Voltage_in))*to_integer(signed(Current_in)); -- Second power
		--summation_334 <= summation + power; -- summation333 + power in 334 
		inside_sqrt <= to_unsigned(summation,33) * multiply; --Summation is 334 * 3139 
		summation <= power ;--First power 
		counter <=  2;


		when others => -- If statement that repeats until the number of samples is reached 
		power <= to_integer(signed(Voltage_in))*to_integer(signed(Current_in));
		summation <= summation + power; -- Running summation of the squared input voltage 
		counter <= counter + one; -- Counter that triggers the next process 
		inside_sqrt <= zero; --restting inside_sqrt when it leaves 5050 case
	
		end case;
	
	end if;
	end process;
end architecture behavioral; 