library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern3 is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(genClk : in std_logic;
       LEDs : out std_logic_vector(6 downto 0) -- 
      );
end entity;

architecture Pattern3_arch of Pattern3 is

  signal LEDout : std_logic_vector(6 downto 0):= "0000000";
  signal current : integer := 127;         

  begin
    countDOWN : process (genClk)
      begin
        if rising_edge(genClk) then
          if (current > 0) then
            current <= current - 1;
          else 
	    current <= 127;
          end if;
 	end if;
        LEDs <= std_logic_vector(to_unsigned(current, 7));
    end process;
end architecture;
