library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity real_power_calc is 
port( 
	input_flag: in std_logic; --Using as process trigger 
	Voltage_in: in unsigned(11 downto 0); -- Voltage input coming from ADC IP
	Current_in: in unsigned(11 downto 0); -- Current input coming from ADC IP 
	Real_power:  out unsigned(11 downto 0) -- Real power coming out of the function NEED TO BE ADJUSTED 13 BITS RIGHT TO GET RIGHT VALUE (ADD 12 ZEROS AFTER THE VALUE) (In uW) 
	);
end entity;
architecture behavioral of real_power_calc is 

	constant one: integer:= 1;

	signal counter: integer:=0;
	signal power: unsigned(23 downto 0):= (others => '0');
	signal zero:unsigned(44 downto 0):=(others => '0');
	signal summation: unsigned(32 downto 0):=(others => '0');
	signal summation_334: unsigned(32 downto 0):=(others => '0');
	signal multiply: unsigned(11 downto 0):= "110001000011"; ---- 1/5050 (1/number of smaples)in binary that was Rigth shift 20 bits 
	signal inside_sqrt:  unsigned(44 downto 0):=(others => '0');
	
	component real_power_component is 
	port( 
		input_flag: in std_logic; 
		data_in    : in unsigned(44 downto 0):=(others => '0'); 
		data_out   : out unsigned(11 downto 0):=(others => '0')
		);
	end component;


begin 

	component_real_power: real_power_component port map (input_flag,inside_sqrt,Real_power); --The RMS Values lag 3 cycles before it outputs the value 
												-- One is sending as zero, because the output lags 1 number to the real one 
	
	process(input_flag) -- Using a process so it will go down the line instead of running cuncurently 
	begin
	if (rising_edge(input_flag)) then --Testing to make sure the calculation run every

		case counter is
				
		when (333) =>	
		summation_334 <= summation ;
		summation <= zero(32 downto 0);
		counter <= counter + 1;
		
		when (334) => -- might be missing 334 data. look at waveform 
		counter <= 0;
		summation <= summation + power; -- first input  
		inside_sqrt <= summation_334 * multiply; -- Multiplying the total summation with 13 

		when others => -- If statement that repeats until the number of samples is reached 
		power <= Voltage_in*Current_in;
		summation <= summation + power; -- Running summation of the squared input voltage 
		counter <= counter + one; -- Counter that triggers the next process 
		inside_sqrt <= zero; --restting inside_sqrt when it leaves 5050 case
		end case;
	
	end if;
	end process;
end architecture behavioral; 
	
	
