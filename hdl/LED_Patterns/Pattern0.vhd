library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern0 is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(genClk : in std_logic;
       LEDs : out std_logic_vector(6 downto 0) -- 
      );
end entity;

architecture Pattern0_arch of Pattern0 is 
  signal internLED : unsigned(6 downto 0) := "1000000"; -- first turn on LEDs 0
  signal counter : integer := 0;    
  signal startOver : integer := 0; 

  begin

  Pattern0_Process : process (genClk)
    begin
    if (rising_edge(genClk)) then
      if (counter < 6) then           -- if done displaying SW
        internLED <= internLED srl 1;
        counter <= counter + 1;
	startOver <= 0;
      else
        if (startOver < 1) then
          internLED <= "1000000";
          startOver <= startOver + 1;
          counter <= 0;
        end if;
      end if;
    end if;
    LEDs <= std_logic_vector(internLED);
  end process;
end architecture;
