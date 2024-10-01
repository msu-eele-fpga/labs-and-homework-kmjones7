library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockGenerator_tb is
end entity ClockGenerator_tb;

architecture ClockGenerator_tb_arch of ClockGenerator_tb is

  component ClockGenerator is
    generic (system_clock_period : time := 20ns);
    port (clk : in std_ulogic; -- system clock
          SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
          base_period : out unsigned(7 downto 0));
  end component;

  signal clk_tb : std_ulogic := '0';
  signal SW_tb : std_ulogic_vector(3 downto 0);
  signal base_period_tb : unsigned(7 downto 0);

  begin

  DUT : component ClockGenerator
    generic map (system_clock_period => 20 ns)
    port map (clk => clk_tb,
	      SW => SW_tb,
	      base_period => base_period_tb);

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for 20 ns / 2;
  end process;
  
  STIMULUS : process is
  begin
    SW_tb <= "0010";
    wait for 80 ns;

    SW_tb <= "0001";
    wait for 80 ns;

    SW_TB <= "0100";
    wait for 80ns;

  end process;


end architecture ClockGenerator_tb_arch;