library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern2 is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(genClk : in std_logic;
       LEDs : out std_logic_vector(6 downto 0) -- 
      );
end entity;

architecture Pattern2_arch of Pattern2 is

  signal LEDout : std_logic_vector(6 downto 0):= "0000000";
  signal current : integer range 0 to 128;           

  begin
    countUP : process (genClk)
      begin
        if rising_edge(genClk) then
          if (current < 127) then
            current <= current + 1;
          else 
	    current <= 0;
          end if;
 	end if;
        LEDs <= std_logic_vector(to_unsigned(current, 7));
    end process;
end architecture;