library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity tester is
   generic (CLOCK_RATE     : integer :=1;         -- clock rate
            CLOCK_UNIT     : integer :=1000);   -- clock rate unit GHz


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
end tester;

architecture Behavioral of tester is
constant    CLOCK_PERIOD   : time := 1 sec / CLOCK_RATE / CLOCK_UNIT;
constant    HALF_PERIOD    : time := CLOCK_PERIOD / 2;

signal clk_internal		: std_logic := '1';

	
begin

clk	<= clk_internal;

   internal_clock: process
   begin
      clk_internal <= not clk_internal after HALF_PERIOD;
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
