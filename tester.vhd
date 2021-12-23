library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity tester is
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
end tester;

architecture Behavioral of tester is

signal clk_internal		: std_logic := '0';
	
begin

clk	<= clk_internal;

   internal_clock: process
   begin
	wait for 0.5 ms;
	clk_internal <= not clk_internal;
   end process internal_clock; 

water_level_ok	<= '1'; 


   test_button_UPDOWN_pressed: process					-- test increment/decrement buttons
   begin
      wait for 10 ms;
      button_UP_pressed <= '1';
           
      wait for 1500 ms;
      button_UP_pressed <= '0';
     
      wait for 500 ms;
      button_DOWN_pressed <= '1';
           
      wait for 500 ms;
      button_DOWN_pressed <= '0';
 
      wait for 500 ms;
      button_BIGCUP_pressed <= '1';
           
      wait for 100 ms;
      button_BIGCUP_pressed <= '0';     
     wait; 
   end process; 
	
	

	
	
   test_error: process
   begin
      wait for 5000 ms;					-- test pump error
      button_START_pressed <= '1';           
      wait for 100 ms;
      button_START_pressed <= '0';   
		
      wait for 1000 ms;		
		reset	<= '1';
      wait for 100 ms;		
		reset	<= '0';	
	
      wait for 1000 ms;					-- test heater error
      button_START_pressed <= '1';           
      wait for 100 ms;
      button_START_pressed <= '0';

		pressure	<= '1';
		
		wait until pump = '0';
		wait for 100 ms;
		pressure	<= '0';

      wait for 1000 ms;		
		reset	<= '1';
      wait for 100 ms;		
		reset	<= '0';
	
      wait for 1000 ms;					-- test cycle
      

		
		button_START_pressed <= '1';           
      wait for 100 ms;
      button_START_pressed <= '0'; 
		wait for 100 ms;
		pressure	<= '1';
		
		wait until heater = '1';
		wait for 200 ms;
		water_temp_over_90C	<= '1';
		
		wait until heater = '0';
		wait for 100 ms;
		water_temp_over_90C	<= '0';	
	
		wait until heater = '1';
		wait for 200 ms;
		water_temp_over_90C	<= '1';



	
      
     wait; 
   end process;
end Behavioral;
