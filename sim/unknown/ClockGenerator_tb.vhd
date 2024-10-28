library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockGenerator_tb is
end entity ClockGenerator_tb;

architecture ClockGenerator_tb_arch of ClockGenerator_tb is

  component ClockGenerator is
    generic (system_clock_period : time := 20ns);
    port (clk : in std_ulogic; -- system clock
          PB : in std_ulogic;  -- Pushbutton to change state (assume active high, change at top level if needed)
          SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
          base_period : in unsigned(7 downto 0);
	  LEDout : out std_ulogic;
          clkOut : out std_ulogic
	  );
  end component;

  signal clk_tb : std_ulogic := '0';
  signal clkOut_tb : std_ulogic;
  signal PB_tb : std_ulogic := '0';
  signal SW_tb : std_ulogic_vector(3 downto 0);
  signal base_period_tb : unsigned(7 downto 0);
  signal LEDout_tb : std_ulogic;

  begin

  DUT : component ClockGenerator
    generic map (system_clock_period => 20 ns)
    port map (clk => clk_tb,
	      PB => PB_tb,
	      SW => SW_tb,
	      base_period => base_period_tb,
	      LEDout => LEDout_tb,
	      clkOut => clkOut_tb);

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for 20 ns / 2;
  end process;
  
  STIMULUS : process is
  begin
    PB_tb <= '1';
    SW_tb <= "0010";
    wait for 100000 ns;

    PB_tb <= '0';
    SW_tb <= "0001";
    wait for 100000 ns;

    PB_tb <= '1';
    SW_TB <= "0100";
    wait for 100000 ns;

    PB_tb <= '0';
    SW_TB <= "0110";
    wait for 100000 ns;

  end process;


end architecture ClockGenerator_tb_arch;