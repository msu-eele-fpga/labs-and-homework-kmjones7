library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
  port(
    clk : in std_ulogic;
    rst : in std_ulogic;
    input : in std_ulogic;
    pulse : out std_ulogic
    );
end entity one_pulse;

architecture one_pulse_arch of one_pulse is
  signal PULSED : integer := 0;
  begin
  PULSE_PROCESS : process (clk, input)
    begin
    if(rising_edge(clk)) then
      if (input = '1') then -- button pushed
        if (PULSED = 0) then -- one pulse HASN'T happened
          pulse <= '1'; -- pulse
          PULSED <= 1;
        else           -- one pulse HAS happened
          pulse <= '0';
        end if;
      else
        PULSED <= 0;
      end if;
    end if;
  end process;
   
end architecture one_pulse_arch;
