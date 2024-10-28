library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern4_tb is
end entity;

architecture Pattern4_tb_arch of Pattern4_tb is

  component Pattern4
    port(genClk : in std_ulogic;
         LEDs : out std_ulogic_vector(6 downto 0)
         );
  end component;

  signal clk_tb : std_ulogic := '0';
  signal LEDs_tb : std_ulogic_vector(6 downto 0);

  begin

  DUT : component Pattern4
    port map (genClk => clk_tb,
	      LEDs => LEDs_tb);

  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for 20 ns / 2;
  end process;


end architecture;
