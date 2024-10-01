library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LED_patterns is
  port(clk : in std_logic; -- system clock
       reset : in std_logic; -- system reset (assume active high, change at top level if needed)
       PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
       SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
       HPS_LED_control: in std_logic;	-- Software is in control when asserted (=1)
       SYS_CLKs_sec : in std_logic_vector(31 downto 0); -- Number of system clock cycles in one second
       Base_rate : in std_logic_vector(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
       LED_red : in std_logic_vector(7 downto 0); -- LED register
       LED : out std_logic_vector(7 downto 0);  -- LEDs on the DE10 NANO board
  );
end entity LED_patterns;

architecture LED_patterns_arch of LED_patterns is
  begin
end architecture LED_patterns_arch;