library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PatternSW is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(clk : in std_logic;
       LED_reg : in std_logic_vector(7 downto 0);
       LEDs : out std_logic_vector(7 downto 0) -- 
      );
end entity;

architecture PatternSW_arch of PatternSW is

  signal internLEDs : std_logic_vector(7 downto 0);
  begin
  
  showLED : process (clk)
  begin
    LEDs <= LED_reg;
  end process;
    
end architecture;
