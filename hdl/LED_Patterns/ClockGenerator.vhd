library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity ClockGenerator is
  generic (system_clock_period : time := 20ns);
  port (clk : in std_logic; -- system clock
	     PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
        SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
	     base_period : in unsigned(7 downto 0);
		  HPS_LED_control : in boolean;
        LEDout : out std_logic;
	     clkOut : out std_logic
	     );

end entity ClockGenerator;

architecture ClockGenerator_arch of ClockGenerator is
  signal testOut : std_logic := '0';
  signal period : unsigned(7 downto 0);
--  signal counter : unsigned(31 downto 0);
  signal newFreq : std_logic_vector(31 downto 0);
  signal counter : integer range 0 to 100000000;
  signal max : integer range 0 to 100000000;
  signal toggleLED : std_logic := '0';
  signal cntBin : unsigned(34 downto 0);
  
  
  signal freq : unsigned(26 downto 0) := "010111110101111000010000000"; -- 50000000
  
  signal freq0 : unsigned (26 downto 0) := "001011111010111100001000000"; -- 25000000
  signal freq1 : unsigned (26 downto 0) := "000101111101011110000100000"; -- 12500000
  signal freq2 : unsigned (26 downto 0) := "101111101011110000100000000"; -- 100000000
  signal freq3 : unsigned (26 downto 0) := "000010111110101111000010000"; -- 6750000
  signal freq4 : unsigned (26 downto 0) := "000001100110111111110011000"; -- 3375000
  
 begin
 period <= base_period;

 max <= to_integer(cntBin(34 downto 4));

  selectClock : process (clk)
    begin
	 if (PB = '1') then
--		case (SW) is -- use rotate right/rotate left
--		  when "0000" => max <= 25000000;
--		  when "0001" => max <= 12500000;
--		  when "0010" => max <= 100000000;
--		  when "0011" => max <= 6750000;
--		  when "0100" => max <= 3375000;
--		  when others => max <= max; -- 50000000
		case (SW) is -- use rotate right/rotate left
		  when "0000" => cntBin <= freq0 * period;
		  when "0001" => cntBin <= freq1 * period;
		  when "0010" => cntBin <= freq2 * period;
		  when "0011" => cntBin <= freq3 * period;
		  when "0100" => cntBin <= freq4 * period;
		  when others => cntBin <= freq * period;
		end case;
	 else
		cntBin <= cntBin;
	 end if;
  end process;


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
  
  --      when "0000" => period <= "00001000"; -- 0.5 x base rate -- 0
--      when "0001" => period <= "00000100";-- 0.25 x base rate -- 1
--     when "0010" => period <= "00100000"; -- 2 x base rate -- 2
--      when "0011" => period <= "00000010";-- 0.125 x base rate -- 3
--      when "0100" => period <= "00011000"; -- 1.5 x base rate -- 4
--      when others => period <= "00010000";


    
 -- newFreq <= period * SYS_CLKs_sec;
    
   
      
    
end architecture ClockGenerator_arch;