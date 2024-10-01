library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

 constant CLK_PERIOD : time := 20 ns; 

    signal clk_tb : std_ulogic := '0';
    signal rst_tb : std_ulogic;
    signal async_tb : std_ulogic := '0';
    signal sync_tb : std_ulogic := '0';
    signal expected : std_ulogic;

  signal async_input : std_ulogic := '0';
  signal sync_to_debounce : std_ulogic := '0';
  signal debounce_to_pulse : std_ulogic := '0';
  signal pulse_to_async : std_ulogic := '0';


    component async_conditioner is
      port( 
        clk : in std_ulogic;
        rst : in std_ulogic;
        async : in std_ulogic;
        sync : out std_ulogic
      );
    end component async_conditioner;

    component synchronizer is
      port(
        clk : in std_ulogic;
        async : in std_ulogic;
        sync : out std_ulogic
      );
    end component synchronizer;

    component debouncer is
      generic(
        clk_period : time := 20 ns;
        debounce_time : time
      );
      port(
        clk : in std_ulogic;
        rst : in std_ulogic;
        input : in std_ulogic;
        debounced : out std_ulogic
      );
    end component debouncer;

    component one_pulse is
      port(
        clk : in std_ulogic;
        rst : in std_ulogic;
        input : in std_ulogic;
        pulse : out std_ulogic
      );
    end component one_pulse;  

  begin

  dut_async : component async_conditioner
    port map (
      clk   => clk_tb,
      rst => rst_tb,
      async => async_tb,
      sync  => sync_tb
    );
  dut_sync : component synchronizer
      port map(
        clk => clk_tb,
	async => async_tb,
	sync => sync_to_debounce
	);

  dut_debounce : component debouncer
    generic map (clk_period => clk_period, debounce_time => 100 ns)
    port map (clk => clk_tb,
	      rst => rst_tb,
              input => sync_to_debounce,
              debounced => debounce_to_pulse
	      );

  dut_one_pulse : component one_pulse
    port map(clk => clk_tb,
	     rst => rst_tb,
             input => debounce_to_pulse,
             pulse => pulse_to_async
	     );
	      


   

  clk_gen : process is
   begin

    clk_tb <= not clk_tb;
    wait for CLK_PERIOD / 2;

  end process clk_gen;

  async_stim : process is
   begin

    async_tb <= '0';
    wait for 1.8 * CLK_PERIOD;

    async_tb <= '1';
    wait for 5 * CLK_PERIOD;

    async_tb <= '0';
    wait for 4 * CLK_PERIOD;

    async_tb <= '1';
    wait for 8 * CLK_PERIOD;

    async_tb <= '0';
    wait for 2 * CLK_PERIOD;

    async_tb <= '1';
    wait for 3 * CLK_PERIOD;

    async_tb <= '0';
    wait for 8 * CLK_PERIOD;

    async_tb <= '1';
    wait for 2 * CLK_PERIOD;

    wait;
  end process async_stim;

 expected_sync : process is
  begin


    expected <= '0';
    wait for 4 * CLK_PERIOD;

    expected <= '1';
    wait for 1 * CLK_PERIOD;

    expected <= '0';
    wait for 10 * CLK_PERIOD;

    expected <= '1';
    wait for 1 * CLK_PERIOD;

    expected <= '0';
    wait;

  end process expected_sync;

  check_output : process is

    variable failed : boolean := false;

  begin

    for i in 0 to 9 loop

      assert expected = sync_tb
        report "Error for clock cycle " & to_string(i) & ":" & LF & "sync = " & to_string(sync_tb) & " expected  = " & to_string(expected)
        severity warning;

      if expected /= sync_tb then
        failed := true;
      end if;

      wait for CLK_PERIOD;

    end loop;

    if failed then
      report "tests failed!"
        severity failure;
    else
      report "all tests passed!";
    end if;

    std.env.finish;

  end process check_output;

end architecture async_conditioner_tb_arch;
