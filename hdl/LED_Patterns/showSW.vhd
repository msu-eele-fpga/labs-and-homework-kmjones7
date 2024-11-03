library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity showSW is -- add genClk, LEDs, PB ?, have all patterns go into LED_Patterns and have a mux with select line
  port(systemClk : in std_logic;
       SW : in std_logic_vector(3 downto 0);
       enable : in boolean;
       done : out boolean;
       LEDs : out std_logic_vector(6 downto 0) -- 
      );
end entity;

architecture showSW_arch of showSW is
  signal internDone : boolean:= true;
  signal count : integer:= 0;
  signal internLEDs : std_logic_vector(6 downto 0);
  signal started : boolean:= false;

  begin

  showSW_process : process (systemClk)
    begin
      if(rising_edge(systemClk)) then
        if (enable = true and internDone = true) then -- if enabled and hasn't started, reset count and done
          count <= 0;
	  internDone <= false;
        elsif (enable = true) then                   -- if enabled and HAS started
	  if(count < 50000000) then
	    count <= count + 1;
            internLEDs <= "000" & SW;
	    internDone <= false;
          else
	    internDone <= true;
	    internLEDs <= "1010101";
          end if;
        end if;
      end if;
    LEDs <= internLEDs;
    done <= internDone;
  end process;
        
end architecture;

