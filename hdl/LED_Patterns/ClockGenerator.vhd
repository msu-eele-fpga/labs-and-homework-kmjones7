library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockGenerator is
  generic (system_clock_period : time := 20ns);
  port (clk : in std_logic; -- system clock
	     PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
        SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
	     base_period : in unsigned(7 downto 0);
        LEDout : out std_logic;
	clkOut : out std_logic
	);

end entity ClockGenerator;

architecture ClockGenerator_arch of ClockGenerator is
  signal testOut : std_logic := '0';
  signal period : unsigned(7 downto 0);
--  signal counter : unsigned(31 downto 0);
  signal newFreq : std_logic_vector(31 downto 0);
  signal counter : natural range 0 to 100000000;
  signal max : natural range 0 to 100000000;
  signal toggleLED : std_logic := '0';
  
 begin
 

  selectClock : process (PB)
    begin
    if (PB = '1') then
      case (SW) is -- use rotate right/rotate left
        when "0000" => max <= 25000000; --25000000
        when "0001" => max <= 12500000; --12500000
        when "0010" => max <= 100000000; -- 100000000
        when "0011" => max <= 6750000; -- 6750000
        when "0100" => max <= 3375000; -- 75000000
        when others => max <= max; -- 50000000
      end case;
    else
	   max <= max;
    end if;
  end process;

--      when "0000" => period <= "00001000"; -- 0.5 x base rate -- 0
--      when "0001" => period <= "00000100";-- 0.25 x base rate -- 1
--     when "0010" => period <= "00100000"; -- 2 x base rate -- 2
--      when "0011" => period <= "00000010";-- 0.125 x base rate -- 3
--      when "0100" => period <= "00011000"; -- 1.5 x base rate -- 4
--      when others => period <= "00010000";


    
 -- newFreq <= period * SYS_CLKs_sec;
    


  ClockGeneration : process (clk)
    begin
      if (rising_edge(clk)) then
        if (counter < max) then
          counter <= counter + 1;
          testOut <= testOut;
	     else
          testOut <= not testOut;
          toggleLED <= not toggleLED;
	       counter <= 0;
        end if;
	     clkOut <= testOut;
        LEDout <= toggleLED;
      end if;
  end process;
   
      
    
end architecture ClockGenerator_arch;