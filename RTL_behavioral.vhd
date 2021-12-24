library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RTL_behavioral is
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
end RTL_behavioral;

architecture Behavioral of RTL_behavioral is

signal grind_time		: std_logic_vector(11 downto 0) := X"0FF"; -- 0,25 - 4 sec
signal clean_time		: std_logic_vector(11 downto 0) := X"3FF";

signal pour_water_time		: std_logic_vector(11 downto 0) := X"7FF"; -- 2 sec

signal delay_counter		: std_logic_vector(11 downto 0) := (others => '0');

signal big_cup_selected		: std_logic :=  '0';

type state_type is (IDLE, GRINDING_TIME_UP,GRINDING_TIME_DOWN,CUPSELECT,WAIT_DELAY, TEST_PUMP, TEST_HEATER, GRINDING, PREHEAT,POURING, CLEANING, WATER_LEVEL_ERROR, PUMP_ERROR, HEATER_ERROR);
signal state: state_type := IDLE;
		
begin

    led_grind_time  <= grind_time(11 downto 8);
	 
    led_cup_200ml  <= big_cup_selected;   
    led_cup_100ml  <= not big_cup_selected;            



STATE_DECODE: process (clk)
begin
	if (reset = '1') then
			state <= IDLE;
	elsif rising_edge(clk) then
	
	case (state) is
					
						when IDLE =>
							delay_counter <= X"000";
							if button_UP_pressed = '1' then
								state <= GRINDING_TIME_UP;
							elsif button_DOWN_pressed = '1' then
								state <= GRINDING_TIME_DOWN;
							elsif button_BIGCUP_pressed = '1' then
								state <= CUPSELECT;
							elsif button_START_pressed = '1' then
								pour_water_time(11) <= big_cup_selected;
								if water_level_ok = '1' then
									state <= TEST_PUMP;
								else
									state <= WATER_LEVEL_ERROR;
								end if;
							end if;            
							
						when GRINDING_TIME_UP =>
							state <= WAIT_DELAY;

						when GRINDING_TIME_DOWN =>
							state <= WAIT_DELAY;
			 
						 when CUPSELECT =>
							state <= WAIT_DELAY;
							
						 when WAIT_DELAY =>
							if delay_counter = X"0FF" then 
								delay_counter <= X"000";
								state <= IDLE;
							else
								delay_counter <= delay_counter + 1;
							end if; 



						 when TEST_PUMP =>
							if(pressure = '1') then
								delay_counter <= X"000";
								state <= TEST_HEATER;
							elsif delay_counter = X"0FF" then 
								state <= PUMP_ERROR;
							else
								delay_counter <= delay_counter + 1;
							end if; 
							
						 when TEST_HEATER =>
							if(water_temp_over_90C = '1') then
								delay_counter <= X"000";
								state <= GRINDING;
							elsif delay_counter = X"0FF" then 
								state <= HEATER_ERROR;
							else
								delay_counter <= delay_counter + 1;
							end if;							
							
							
							
								
						 when GRINDING =>
							if delay_counter = grind_time then
								delay_counter <= X"000";
								state <= PREHEAT;
							else
								delay_counter <= delay_counter + 1;									
							end if; 
							
						 when PREHEAT =>
							if(water_temp_over_90C = '1') then
								delay_counter <= X"000";
								state <= POURING;
							elsif delay_counter = X"0FF" then 
								state <= HEATER_ERROR;
							else
								delay_counter <= delay_counter + 1;
							end if;							
										  
						 when POURING =>
							if delay_counter = pour_water_time then 
								delay_counter <= X"000";
								state <= CLEANING;
							else
								delay_counter <= delay_counter + 1;									
							end if; 

						
						 when CLEANING =>
							if delay_counter = clean_time then
								delay_counter <= X"000";
								state <= IDLE;
							else
								delay_counter <= delay_counter + 1;									
							end if;

						when WATER_LEVEL_ERROR =>
				
						when PUMP_ERROR =>
							
						when HEATER_ERROR =>
						
						when others =>
							state <= IDLE;
					end case;	
	end if;
end process;
	
	
	
OUTPUT_DECODE: process (clk)
begin
	if rising_edge(clk) then
	
			if state = GRINDING_TIME_UP then
				grind_time <= grind_time(10 downto 8) & '1' & X"FF";         
			end if;
			
			if state = GRINDING_TIME_DOWN then
				grind_time <= '0' & grind_time(11 downto 9) & X"FF";
			end if;  
			
			if state = CUPSELECT then
				big_cup_selected   <= not big_cup_selected;
			end if; 
			
			
			if (state = GRINDING)or(state = CLEANING) then
				grinder_on   <= '1';
			else
				grinder_on   <= '0';     
			end if;
			
			if (state = POURING)or(state = CLEANING) then
				water_valve   <= '1';
			else
				water_valve   <= '0';     
			end if;
			
			if (state = CLEANING) then
				drain_valve   <= '1';
			else
				drain_valve   <= '0';     
			end if;


			if (state = TEST_PUMP)or(state = TEST_HEATER) or(state = PREHEAT) then
				return_valve   <= '1';
			else
				return_valve   <= '0';     
			end if;
			

			if ((state = POURING)or(state = TEST_HEATER)or(state = CLEANING) or(state = PREHEAT)) then
				 heater <= '1';
			else
				 heater <= '0';
			end if;
			
			if (state = TEST_PUMP)or(state = TEST_HEATER)or(state = CLEANING)or(state = POURING) or(state = PREHEAT)then
				pump   <= '1';
			else
				pump   <= '0';     
			end if;			
			
			if (state = POURING) then
				cup_valve   <= '1';
			else
				cup_valve   <= '0';     
			end if;			
			
			if (state = PUMP_ERROR) then
				led_alarm_pump   <= '1';
			else
				led_alarm_pump   <= '0';     
			end if;

			if (state = HEATER_ERROR) then
				led_alarm_heater   <= '1';
			else
				led_alarm_heater   <= '0';     
			end if;
			
			if (state = WATER_LEVEL_ERROR) then
				led_alarm_level   <= '1';
			else
				led_alarm_level   <= '0';     
			end if;			
			
			
	end if;	
end process;	
	
	
end Behavioral;
