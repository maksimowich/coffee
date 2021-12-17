library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RTL_behavioral is
    Port ( clk : in STD_LOGIC; -- 1kHz
           reset : in STD_LOGIC;
           
           button_START_pressed : in STD_LOGIC;
           button_UP_pressed : in STD_LOGIC;
           button_DOWN_pressed : in STD_LOGIC;
           button_BIGCUP_pressed : in STD_LOGIC;
           
           water_heater_on : out STD_LOGIC :=  '0';
           water_temp_over_90C : in STD_LOGIC;
           
           led_grind_time : out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           led_bigcup : out STD_LOGIC :=  '0';         
           grinder_on : out STD_LOGIC :=  '0';          
           water_on : out STD_LOGIC :=  '0');
end RTL_behavioral;

architecture Behavioral of RTL_behavioral is

signal grind_time		: std_logic_vector(11 downto 0) := X"0FF"; -- 0,25 - 4 sec

signal pour_water_time		: std_logic_vector(11 downto 0) := X"7FF"; -- 2 sec

signal delay_counter		: std_logic_vector(11 downto 0) := (others => '0');

signal big_cup_selected		: std_logic :=  '0';

type state_type is (IDLE, GRINDING_TIME_UP,GRINDING_TIME_DOWN,CUPSELECT,WAIT_DELAY,GRINDING,GRINDING_WAIT, POURING,POURING_WAIT);
signal state, next_state      : state_type := IDLE;
		
	
begin

    led_grind_time  <= grind_time(11 downto 8);
    led_bigcup  <= big_cup_selected;   
        
--автоподогрев воды в бойлере
	process(clk)
	begin
	if rising_edge(clk) then

            if (water_temp_over_90C = '0')and(state = POURING_WAIT) then
                water_heater_on <= '1';
            else
                water_heater_on <= '0';
            end if;
	end if;
	end process;



   --MOORE State-Machine
  SYNC_PROC: process (clk)
   begin
      if rising_edge(clk) then
         if (reset = '1') then
            state <= IDLE;
         else
            state <= next_state;
         end if;
         
       if (state = WAIT_DELAY)or(state = GRINDING_WAIT)or(state = POURING_WAIT) then
          delay_counter <= delay_counter + 1;
       else
            delay_counter <= X"000";
       end if;           

     
         
      end if;
   end process;

   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE: process (state)
   begin
      if state = GRINDING_TIME_UP then
         grind_time <= grind_time(10 downto 8) & '1' & X"FF";         
      end if;
      if state = GRINDING_TIME_DOWN then
         grind_time <= '0' & grind_time(11 downto 9) & X"FF";
      end if;      
      if state = CUPSELECT then
         big_cup_selected   <= not big_cup_selected;
      end if;        
 
       if (state = GRINDING) then
         pour_water_time(11) <= big_cup_selected;
      end if;
        
      if (state = GRINDING_WAIT) then
         grinder_on   <= '1';
      else
         grinder_on   <= '0';     
      end if;  
      
       if (state = POURING_WAIT) then
         water_on   <= '1';
      else
         water_on   <= '0';     
      end if;              
   end process;

   NEXT_STATE_DECODE: process (state, button_UP_pressed, button_DOWN_pressed, button_BIGCUP_pressed, button_START_pressed, delay_counter)
   begin
      case (state) is
      
         when IDLE =>
            if button_UP_pressed = '1' then
               next_state <= GRINDING_TIME_UP;
            elsif button_DOWN_pressed = '1' then
               next_state <= GRINDING_TIME_DOWN;
            elsif button_BIGCUP_pressed = '1' then
               next_state <= CUPSELECT;
            elsif button_START_pressed = '1' then
               next_state <= GRINDING;
            end if;            
            
         when GRINDING_TIME_UP =>
            next_state <= WAIT_DELAY;

         when GRINDING_TIME_DOWN =>
            next_state <= WAIT_DELAY;
 
          when CUPSELECT =>
            next_state <= WAIT_DELAY;
            
          when WAIT_DELAY =>
            if delay_counter = X"0FF" then 
               next_state <= IDLE;
            end if; 
                      
          when GRINDING =>
            next_state <= GRINDING_WAIT;
                       
          when GRINDING_WAIT =>
            if delay_counter = grind_time then 
               next_state <= POURING;
            end if; 
            
          when POURING =>
            next_state <= POURING_WAIT;
                       
          when POURING_WAIT =>
            if delay_counter = pour_water_time then 
               next_state <= IDLE;
            end if; 
                        
         when others =>
            next_state <= IDLE;
      end case;
   end process;
end Behavioral;
