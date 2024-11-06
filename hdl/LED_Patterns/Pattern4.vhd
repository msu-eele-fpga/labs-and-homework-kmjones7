library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern4 is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(genClk : in std_logic;
       LEDs : out std_logic_vector(6 downto 0) -- 
      );
end entity;

architecture Pattern4_arch of Pattern4 is

  signal internLEDs : unsigned(6 downto 0) := "0000000";
  signal counter : integer := 0;    
  signal startOver : boolean := false;
  signal start : boolean := false;


  type State_Type is (s0, s1, s2, s3, s4);
  signal current_state, next_state : State_Type;   
  


  begin

-- STATE MEMORY ------------------------------------------------------
  STATE_MEMORY : process (genClk)
    begin
 --     if (start = false) then
 --       current_state <= s0;
 --       start <= true;
      if (rising_edge(genClk)) then
	current_state <= next_state;
      end if;
  end process;
-------------------------------------------------
  COUNTER_PROCESS : process (genClk)
    begin
    if(rising_edge(genClk)) then
      if (counter < 4) then
        counter <= counter + 1;
      else 
	counter <= 0;
	startOver <= not startOver;
      end if;
    end if;
  end process;
------------------------------------------------
  NEXT_STATE_LOGIC : process (counter)
    begin
 --   if(rising_edge(genClk)) then 
      if (startOver = false) then
        case (current_state) is
          when s0 => next_state <= s1;
          when s1 => next_state <= s2;
          when s2 => next_state <= s3;
          when s3 => next_state <= s4;
	  when s4 => next_state <= s0;
          when others => next_state <= current_state;
	end case;
      elsif (startOver = true) then
        case (current_state) is
          when s4 => next_state <= s3;
          when s3 => next_state <= s2;
          when s2 => next_state <= s1;
          when s1 => next_state <= s0;
	  when s0 => next_state <= s4;
	  when others => next_state <= current_state;
	end case;
      end if;
  --  end if;
  end process;
--------------------------------------------------
  OUTPUT_LOGIC : process (current_state) 
    begin
    --if(rising_edge(genClk)) then
      case (current_state) is
        when s0 => internLEDs <= "0000000";
	when s1 => internLEDs <= "1000001";
	when s2 => internLEDs <= "0100010";
	when s3 => internLEDs <= "0010100";
	when s4 => internLEDs <= "0001000";
        when others => internLEDs <= internLEDs;
      end case;
  --  end if;
    LEDs <= std_logic_vector(internLEDs);
  end process;
---------------------------------------------
end architecture;
