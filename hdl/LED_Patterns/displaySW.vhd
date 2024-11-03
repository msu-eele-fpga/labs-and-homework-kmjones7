library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity displaySW is
  port(clk : in std_logic
       Sel : in std_logic_vector(3 downto 0);
       Enable : in boolean;
       LEDs : out std_logic_vector(6 downto 0);
       showSW : out boolean
       );
end entity;


architecture displaySW_arch of displaySW is

  signal counter : integer := 0;
  signal internEnable : boolean := false;
  begin
  
  DISPLAY_SWITCHES : process (clk)
    begin
      if (enable = true) then
        if (counter < 50000000) then
          counter <= counter + 1;
	  LEDs <= "000" & SW;
        else
	  enable <= false;
      else
        done <= done;
end architecture displaySW_arch;
