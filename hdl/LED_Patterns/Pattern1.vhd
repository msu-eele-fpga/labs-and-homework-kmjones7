library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern1 is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(genClk : in std_ulogic;
       LEDs : out std_ulogic_vector(6 downto 0) -- 
      );
end entity;

architecture Pattern1_arch of Pattern1 is

  signal internLED : unsigned(6 downto 0) := "0000011"; -- first turn on LEDs 0 and 1
  signal counter : integer := 0;    
  signal startOver : integer := 0;     
  signal displaySW : integer := 0;    
  signal done : boolean:= false;    

  begin

  Pattern1_Process : process (genClk)
    begin
    if (rising_edge(genClk)) then
      if (counter < 5) then           -- if done displaying SW
        internLED <= internLED sll 1;
        counter <= counter + 1;
      else
        if (startOver < 1) then
          internLED <= "1000001";
          startOver <= startOver + 1;
        else
          internLED <= "0000011";
          counter <= 0;
          startOver <= 0;
        end if;
      end if;
    end if;
    LEDs <= std_ulogic_vector(internLED);
  end process;

end architecture;


    
--    ShiftRight : process (genClk) -- 12500000
--      begin
--        if (rising_edge(genClk)) then
--          if (push = '1' or done = false) then -- if button has been push or not done displaying SW
--            if (displaySW < 25) then
--              displaySW <= displaySW + 1;
--	      internLED <=  "0000001";
--	      done <= false;
--            else
--	      done <= true;
--	      displaySW <= 0;
 --             internLED <= "0000011";
--	    end if;
--	  else
--	    displaySW <= displaySW; -- latch
--	  end if;
 ----------------------------------------------------        
  --        if (done = true) then
    --        if (counter < 5) then           -- if done displaying SW
    --          internLED <= internLED sll 1;
    --          counter <= counter + 1;
    --        else
    --          if (startOver < 1) then
    --            internLED <= "1000001";
    --            startOver <= startOver + 1;
    --          else
    --            internLED <= "0000011";
    --            counter <= 0;
    --            startOver <= 0;
    --          end if;
	   -- end if;
--          end if;
 --       LEDs <= std_ulogic_vector(internLED);
--      end if;
--    end process;

