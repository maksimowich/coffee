library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_tb is

end sim_tb;

architecture Behavioral of sim_tb is

   
   
   
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

component tester is
    Port ( clk : out STD_LOGIC; -- 1kHz
           reset : out STD_LOGIC;
           
           button_START_pressed : out STD_LOGIC;
           button_UP_pressed : out STD_LOGIC;
           button_DOWN_pressed : out STD_LOGIC;
           button_BIGCUP_pressed : out STD_LOGIC;
           
           water_heater_on : in STD_LOGIC;
           water_temp_over_90C : out STD_LOGIC;
           
           led_grind_time : in STD_LOGIC_VECTOR (3 downto 0); 
           led_bigcup : in STD_LOGIC;          
           grinder_on : in STD_LOGIC;           
           water_on : in STD_LOGIC);
end component;


signal clk		: std_logic := '0';
signal reset	: std_logic:= '0';
	
signal button_START_pressed		: std_logic := '0';
signal button_UP_pressed	: std_logic:= '0';
signal button_DOWN_pressed		: std_logic := '0';
signal button_BIGCUP_pressed	: std_logic:= '0';

signal water_heater_on		: std_logic := '0';
signal water_temp_over_90C	: std_logic:= '0';
signal water_on		: std_logic := '0';
signal grinder_on		: std_logic := '0';
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
	   grinder_on => grinder_on,
           water_on => water_on                         
		);

tester_inst : component tester
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
	   grinder_on => grinder_on,
           water_on => water_on                         
		);

end Behavioral;
