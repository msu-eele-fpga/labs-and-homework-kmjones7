library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockGenerator is
  generic (system_clock_period : time := 20ns);
  port (clk : in std_ulogic; -- system clock
        SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
        base_period : out unsigned(7 downto 0));

end entity;

architecture ClockGenerator_arch of ClockGenerator is
  signal period : unsigned(7 downto 0);
  --signal counter : unsigned(7 downto 0);
  signal counter : integer := 0;
  begin

  selectClock : process (SW)
    begin
    case (SW) is
      when "0000" => period <= "00001000"; -- 0.5 x base rate -- 0
      when "0001" => period <= "00000100";-- 0.25 x base rate -- 1
      when "0010" => period <= "00100000"; -- 2 x base rate -- 2
      when "0011" => period <= "00000010";-- 0.125 x base rate -- 3
      when "0100" => period <= "00011000"; -- 1.5 x base rate -- 4
      when others => period <= "00010000";
    end case;
  end process;

  ClockGeneration : process (clk)
    begin
      if (rising_edge(clk)) then
        if (counter < period) then
          counter <= counter + 1;
	else
	  counter <= counter;
 	  base_period <= period;
        end if;
      end if;
  end process;
   
      
    
end architecture ClockGenerator_arch;