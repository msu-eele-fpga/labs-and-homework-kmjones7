library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity timed_counter_tb;

architecture testbench of timed_counter_tb is
  component timed_counter is
    generic (
      clk_period : time;
      count_time : time
    );
    port(
      clk : in std_ulogic; 
      enable : in boolean;
      done : out boolean
    );
  end component timed_counter;
  
  signal clk_tb : std_ulogic := '0';
  
  signal enable_100ns_tb : boolean := false;
  signal done_100ns_tb : boolean;

  signal enable_240ns_tb : boolean := false;
  signal done_240ns_tb : boolean;

  constant HUNDRED_NS : time := 100 ns;
  constant TWOFORTY_NS : time := 240 ns;

-- predict the counter's done output
  procedure predict_counter_done(
    constant count_time : in time;
    signal enable : in boolean;
    signal done : in boolean;
    constant count_iter : in natural
  ) is
  begin
    if enable then
      if count_iter < (count_time / CLK_PERIOD) then
        assert_false(done, "counter not done");
      else
        assert_true(done, "counter is done");
      end if;
    else
        assert_true(done, "counter not enabled");
      end if;
  end procedure predict_counter_done;

  begin

    dut_100ns_counter : component timed_counter
      generic map (
	clk_period => CLK_PERIOD,
	count_time => HUNDRED_NS
	)
      port map (
	clk => clk_tb,
	enable => enable_100ns_tb,
	done => done_100ns_tb
      );

    dut_240ns_counter : component timed_counter
	generic map (
	  clk_period => CLK_PERIOD,
	  count_time => TWOFORTY_NS
	)
	port map(
	  clk => clk_tb,
	  enable => enable_240ns_tb,
	  done => done_240ns_tb
	);
	
  clk_tb <= not clk_tb after CLK_PERIOD / 2;

  stimuli_and_checker : process is
  begin
  
-- TEST 1 --------------------------------------------------------------
  -- test 100 ns timer when it's enabled
    print("TEST 1: testing 100 ns timer: enabled");
    wait_for_clock_edge(clk_tb);
    enable_100ns_tb <= true;
  -- loop for the number of clock cycles that is equal to the timer's period
    for i in 0 to (HUNDRED_NS/CLK_PERIOD) loop
      wait_for_clock_edge(clk_tb);
      -- test whether the counter's done output is correct or not
      predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
    end loop;
-- END TEST 1 ------------------------------------------------------------

-- TEST 2 ----------------------------------------------------------------
   print("TEST 2: testing 100 ns timer: disabled");
   wait_for_clock_edge(clk_tb);
   enable_100ns_tb <= false;
   for i in 0 to ((HUNDRED_NS/CLK_PERIOD)*2) loop
     wait_for_clock_edge(clk_tb);
     -- test whether the counter's done output is correct or not
     predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
   end loop;
-- Don't understand why this is failing. Counter is DISABLED (enable = false), therefore it shouldnt count, and
-- done = false. The waveform shows that this is true, however, it is failing the test saying 'counter not enabled'.
-- END TEST 2 ----------------------------------------------------------------

-- TEST 3 --------------------------------------------------------------------
   print("TEST 3: testing 100 ns timer: nested for loop");
   wait_for_clock_edge(clk_tb);
   enable_100ns_tb <= false;
   wait_for_clock_edge(clk_tb);
   enable_100ns_tb <= true;
   for j in 0 to 3 loop
     for i in 0 to (HUNDRED_NS/CLK_PERIOD) loop
       wait_for_clock_edge(clk_tb);
      -- test whether the counter's done output is correct or not
      predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
     end loop;
     wait_for_clock_edge(clk_tb);
     enable_100ns_tb <= false;
     wait_for_clock_edge(clk_tb);
     enable_100ns_tb <= true;
   end loop;
-- END TEST 3 ---------------------------------------------------------------
     
-- TEST 4 --------------------------------------------------------------
  -- test 100 ns timer when it's enabled
    print("TEST 4: testing 240 ns timer: enabled");
--    wait_for_clock_edge(clk_tb);
--    enable_100ns_tb <= false;
    wait_for_clock_edge(clk_tb);
    enable_240ns_tb <= true;
  -- loop for the number of clock cycles that is equal to the timer's period
    for i in 0 to (TWOFORTY_NS/CLK_PERIOD) loop
      wait_for_clock_edge(clk_tb);
      -- test whether the counter's done output is correct or not
      predict_counter_done(TWOFORTY_NS, enable_240ns_tb, done_240ns_tb, i);
    end loop;
-- END TEST 4 ------------------------------------------------------------

-- TEST 5 ----------------------------------------------------------------
   print("TEST 5: testing 240 ns timer: disabled");
   wait_for_clock_edge(clk_tb);
   enable_240ns_tb <= false;
   for i in 0 to ((TWOFORTY_NS/CLK_PERIOD)*2) loop
     wait_for_clock_edge(clk_tb);
     -- test whether the counter's done output is correct or not
     predict_counter_done(TWOFORTY_NS, enable_240ns_tb, done_240ns_tb, i);
   end loop;
-- Don't understand why this is failing. Counter is DISABLED (enable = false), therefore it shouldnt count, and
-- done = false. The waveform shows that this is true, however, it is failing the test saying 'counter not enabled'.
-- END TEST 5 ----------------------------------------------------------------

-- TEST 6 --------------------------------------------------------------------
   print("TEST 6: testing 240 ns timer: nested for loop");
   wait_for_clock_edge(clk_tb);
   enable_240ns_tb <= false;
   wait_for_clock_edge(clk_tb);
   enable_240ns_tb <= true;
   for j in 0 to 3 loop
     for i in 0 to (TWOFORTY_NS/CLK_PERIOD) loop
       wait_for_clock_edge(clk_tb);
      -- test whether the counter's done output is correct or not
      predict_counter_done(TWOFORTY_NS, enable_240ns_tb, done_240ns_tb, i);
     end loop;
     wait_for_clock_edge(clk_tb);
     enable_240ns_tb <= false;
     wait_for_clock_edge(clk_tb);
     enable_240ns_tb <= true;
   end loop;
-- END TEST 3 ---------------------------------------------------------------




   -- add other test cases here
    std.env.finish;
  end process stimuli_and_checker;
end architecture testbench;