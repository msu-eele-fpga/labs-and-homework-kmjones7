library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LED_patterns is
  generic(system_clock_period : time := 20ns);
  port(clk : in std_ulogic; -- system clock
       rst : in std_ulogic; -- system reset (assume active high, change at top level if needed)
       PB : in std_ulogic;  -- Pushbutton to change state (assume active high, change at top level if needed)
       SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
       HPS_LED_control: in boolean;	-- Software is in control when asserted (=1)
       
       base_period : in unsigned(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
       LED_reg : in std_ulogic_vector(7 downto 0); -- LED register
       LED : out std_ulogic_vector(7 downto 0)  -- LEDs on the DE10 NANO board
  );
end entity LED_patterns;

architecture LED_patterns_arch of LED_patterns is
  -- signal declaration
  -- component declarations

  begin
-- concurrent statements
  if(HPS_LED_control) then
 --   LED <= controlled by software that writes to register LED\_reg
  else
--  LED <= controlled by hardware stat machines in LED\_Patterns
  end if;
end architecture LED_patterns_arch;