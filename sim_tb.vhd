library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_tb is

end sim_tb;

architecture Behavioral of sim_tb is

   
   
   
component RTL_behavioral is
    Port ( clk : in STD_LOGIC :=  '0';
           reset : in STD_LOGIC :=  '0';
           
           button_START_pressed : in STD_LOGIC :=  '0';
           button_UP_pressed : in STD_LOGIC :=  '0';
           button_DOWN_pressed : in STD_LOGIC :=  '0';
           button_BIGCUP_pressed : in STD_LOGIC :=  '0';

			  water_level_ok : in STD_LOGIC :=  '0';           
           water_temp_over_90C : in STD_LOGIC :=  '0';
			  pressure : in STD_LOGIC :=  '0';
			  
           
           led_grind_time : out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           led_cup_200ml : out STD_LOGIC :=  '0'; 
           led_cup_100ml : out STD_LOGIC :=  '0'; 			  
			  
           led_alarm_level : out STD_LOGIC :=  '0'; 
           led_alarm_pump : out STD_LOGIC :=  '0'; 
           led_alarm_heater : out STD_LOGIC :=  '0';
 			  

           heater : out STD_LOGIC :=  '0';
			  pump : out STD_LOGIC :=  '0';
           grinder_on : out STD_LOGIC :=  '0';          
           water_valve : out STD_LOGIC :=  '0';
			  return_valve : out STD_LOGIC :=  '0';
			  cup_valve : out STD_LOGIC :=  '0';
			  drain_valve : out STD_LOGIC :=  '0');
end component;

component tester is
    Port ( clk : out STD_LOGIC :=  '0';
           reset : out STD_LOGIC :=  '0';
           
           button_START_pressed : out STD_LOGIC :=  '0';
           button_UP_pressed : out STD_LOGIC :=  '0';
           button_DOWN_pressed : out STD_LOGIC :=  '0';
           button_BIGCUP_pressed : out STD_LOGIC :=  '0';

			  water_level_ok : out STD_LOGIC :=  '0';           
           water_temp_over_90C : out STD_LOGIC :=  '0';
			  pressure : out STD_LOGIC :=  '0';
			  
           
           led_grind_time : in STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           led_cup_200ml : in STD_LOGIC :=  '0'; 
           led_cup_100ml : in STD_LOGIC :=  '0'; 			  
			  
           led_alarm_level : in STD_LOGIC :=  '0'; 
           led_alarm_pump : in STD_LOGIC :=  '0'; 
           led_alarm_heater : in STD_LOGIC :=  '0';
 			  

           heater : in STD_LOGIC :=  '0';
			  pump : in STD_LOGIC :=  '0';
           grinder_on : in STD_LOGIC :=  '0';          
           water_valve : in STD_LOGIC :=  '0';
			  return_valve : in STD_LOGIC :=  '0';
			  cup_valve : in STD_LOGIC :=  '0';
			  drain_valve : in STD_LOGIC :=  '0');
end component;


signal  clk : STD_LOGIC :=  '0';
signal  reset : STD_LOGIC :=  '0';
  
signal  button_START_pressed : STD_LOGIC :=  '0';
signal  button_UP_pressed : STD_LOGIC :=  '0';
signal  button_DOWN_pressed : STD_LOGIC :=  '0';
signal  button_BIGCUP_pressed : STD_LOGIC :=  '0';

signal  water_level_ok : STD_LOGIC :=  '0';           
signal  water_temp_over_90C : STD_LOGIC :=  '0';
signal  pressure : STD_LOGIC :=  '0';
  
  
signal  led_grind_time : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal  led_cup_200ml : STD_LOGIC :=  '0'; 
signal  led_cup_100ml : STD_LOGIC :=  '0'; 			  
  
signal  led_alarm_level : STD_LOGIC :=  '0'; 
signal  led_alarm_pump : STD_LOGIC :=  '0'; 
signal  led_alarm_heater : STD_LOGIC :=  '0';
  

signal  heater : STD_LOGIC :=  '0';
signal  pump : STD_LOGIC :=  '0';
signal  grinder_on : STD_LOGIC :=  '0';          
signal  water_valve : STD_LOGIC :=  '0';
signal  return_valve : STD_LOGIC :=  '0';
signal  cup_valve : STD_LOGIC :=  '0';
signal  drain_valve : STD_LOGIC :=  '0';

begin

RTL_inst : component RTL_behavioral
	port map (
		clk            => clk,   
		reset          => reset,

		button_START_pressed => button_START_pressed,
		button_UP_pressed => button_UP_pressed,
		button_DOWN_pressed => button_DOWN_pressed,
		button_BIGCUP_pressed => button_BIGCUP_pressed,
		  
	  water_level_ok => water_level_ok,
	  water_temp_over_90C => water_temp_over_90C,
	  pressure => pressure,
	  
	  
	  led_grind_time => led_grind_time,
	  led_cup_200ml => led_cup_200ml,
	  led_cup_100ml => led_cup_100ml,
	  
	  led_alarm_level => led_alarm_level,
	  led_alarm_pump => led_alarm_pump,
	  led_alarm_heater => led_alarm_heater,
	  

	  heater => heater,
	  pump => pump,
	  grinder_on => grinder_on,
	  water_valve => water_valve,
	  return_valve => return_valve,
	  cup_valve => cup_valve,
	  drain_valve => drain_valve   
		);

tester_inst : component tester
	port map (
		clk            => clk,   
		reset          => reset,

		button_START_pressed => button_START_pressed,
		button_UP_pressed => button_UP_pressed,
		button_DOWN_pressed => button_DOWN_pressed,
		button_BIGCUP_pressed => button_BIGCUP_pressed,
		  
	  water_level_ok => water_level_ok,
	  water_temp_over_90C => water_temp_over_90C,
	  pressure => pressure,
	  
	  
	  led_grind_time => led_grind_time,
	  led_cup_200ml => led_cup_200ml,
	  led_cup_100ml => led_cup_100ml,
	  
	  led_alarm_level => led_alarm_level,
	  led_alarm_pump => led_alarm_pump,
	  led_alarm_heater => led_alarm_heater,
	  

	  heater => heater,
	  pump => pump,
	  grinder_on => grinder_on,
	  water_valve => water_valve,
	  return_valve => return_valve,
	  cup_valve => cup_valve,
	  drain_valve => drain_valve  
		);

end Behavioral;
