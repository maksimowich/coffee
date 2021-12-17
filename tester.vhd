library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity tester is
    Port ( clk : out STD_LOGIC :=  '0'; -- 1kHz
           reset : out STD_LOGIC :=  '0';
           
           button_START_pressed : out STD_LOGIC :=  '0';
           button_UP_pressed : out STD_LOGIC :=  '0';
           button_DOWN_pressed : out STD_LOGIC :=  '0';
           button_BIGCUP_pressed : out STD_LOGIC :=  '0';
           
           water_heater_on : in STD_LOGIC;
           water_temp_over_90C : out STD_LOGIC :=  '0';
           
           led_grind_time : in STD_LOGIC_VECTOR (3 downto 0); 
           led_bigcup : in STD_LOGIC;          
           grinder_on : in STD_LOGIC;           
           water_on : in STD_LOGIC);
end tester;

architecture Behavioral of tester is

signal clk_internal		: std_logic := '0';

	
begin

clk	<= clk_internal;

   internal_clock: process
   begin
	wait for 0.5ms;
	clk_internal <= not clk_internal;
   end process internal_clock; 

   
test_heater: process
   begin
		wait for 150ms;
		water_temp_over_90C <= '0';     
     		wait for 50ms;
      		if(water_on = '1')then 
			water_temp_over_90C <= '1';
		end if;
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
