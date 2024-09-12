library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;

entity timed_counter is
  generic (
    clk_period : time;
    count_time : time
  );
  port (
    clk : in std_ulogic;
    enable : in boolean;
    done : out boolean
  );
end entity timed_counter;
-- count time: how long the timer should count before asserting its done output
-- clk_period: 20ns
-- the timed counter will assert its DONE for ONE CLOCK CYCLE
-- counter will only count when its ENABLE is asserted TRUE
-- counter will be reset to ZERO when ENABLE is FALSE

-- count_time: 100ns
-- clk_period: 20ns
-- COUNTER_LIMIT: 5

architecture timed_counter_arch of timed_counter is

  constant COUNTER_LIMIT : integer := count_time / clk_period; -- COUNTER_LIMIT = Clock Cycles
  signal counter : integer range 0 to COUNTER_LIMIT := 0;

  begin
  COUNTER_PROCESS : process (clk)
    begin
    if (enable = true) then -- Count when ENABLE is TRUE
      if (rising_edge(clk) and counter < COUNTER_LIMIT) then
        counter <= counter + 1;
        done <= false;
      elsif (rising_edge(clk) and counter = COUNTER_LIMIT) then
        done <= true;
      end if;
    elsif (enable = false) then -- DON'T Count when ENABLE is FALSE, RESET Counter
      if (rising_edge(clk)) then
        counter <= 0;
        done <= false;
--      done <= true; -- when done <= true instead of false, test 2 passes
      end if;
    end if;

  end process;
      

   
end architecture timed_counter_arch;