library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_tb is
   generic (CLOCK_RATE     : integer :=1;         -- clock rate
            CLOCK_UNIT     : integer :=1000);   -- clock rate unit GHz
end sim_tb;

architecture Behavioral of sim_tb is
   constant    CLOCK_PERIOD   : time := 1 sec / CLOCK_RATE / CLOCK_UNIT;
   constant    HALF_PERIOD    : time := CLOCK_PERIOD / 2;
   
   
   
component RTL_behavioral is
    Port ( clk : in STD_LOGIC; -- 1kHz
           reset : in STD_LOGIC;
           
           button_START_pressed : in STD_LOGIC;
           button_UP_pressed : in STD_LOGIC;
           button_DOWN_pressed : in STD_LOGIC;
           button_BIGCUP_pressed : in STD_LOGIC;
           
           water_heater_on : out STD_LOGIC;
           water_temp_over_90C : in STD_LOGIC;
           
           led_grind_time : out STD_LOGIC_VECTOR (3 downto 0); 
           led_bigcup : out STD_LOGIC;          
           grinder_on : out STD_LOGIC;           
           water_on : out STD_LOGIC);
end component;



signal clk		: std_logic := '1';
signal reset	: std_logic:= '1';
	
signal button_START_pressed		: std_logic := '0';
signal button_UP_pressed	: std_logic:= '0';
signal button_DOWN_pressed		: std_logic := '0';
signal button_BIGCUP_pressed	: std_logic:= '0';

signal water_heater_on		: std_logic := '0';
signal water_temp_over_90C	: std_logic:= '0';
signal water_on		: std_logic := '0';
signal led_bigcup		: std_logic := '0';
signal led_grind_time	: std_logic_vector(3 downto 0) := (others => '0');	

begin

coffemashine_inst : component RTL_behavioral
		port map (
		   clk            => clk,   
		   reset          => reset,
		   
           button_START_pressed => button_START_pressed,
           button_UP_pressed => button_UP_pressed,
           button_DOWN_pressed => button_DOWN_pressed,
           button_BIGCUP_pressed=> button_BIGCUP_pressed,
           
           water_heater_on => water_heater_on, 
           water_temp_over_90C => water_temp_over_90C, 
           
           led_grind_time => led_grind_time,            
           led_bigcup => led_bigcup,
           water_on => water_on                         
		);

   internal_clock: process (clk)
   begin
      clk <= not clk after HALF_PERIOD;
   end process internal_clock; 

   test_heater: process
   begin
      wait for 1500ms;
      water_temp_over_90C <= '0';     
      wait for 500ms;
      water_temp_over_90C <= '1'; 
   end process; 

   test_reset: process
   begin
      wait for 2ms;
      reset <= '0';     
      wait;
   end process; 

   test_button_UPDOWN_pressed: process
   begin
      wait for 10ms;
      button_UP_pressed <= '1';
           
      wait for 1500ms;
      button_UP_pressed <= '0';
     
      wait for 500ms;
      button_DOWN_pressed <= '1';
           
      wait for 500ms;
      button_DOWN_pressed <= '0';
 
      wait for 500ms;
      button_BIGCUP_pressed <= '1';
           
      wait for 100ms;
      button_BIGCUP_pressed <= '0';     

      wait for 500ms;
      button_START_pressed <= '1';
           
      wait for 100ms;
      button_START_pressed <= '0';   


      
     wait; 
   end process; 

end Behavioral;