library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pattern1_tb is
end entity;

architecture Pattern1_tb_arch of Pattern1_tb is

  component Pattern1
    port(genClk : in std_ulogic;
         LEDs : out std_logic_vector(6 downto 0)
         );
  end component;

  signal clk_tb : std_ulogic := '0';
  signal systemClk_tb : std_ulogic:= '0';
  signal rst_tb : std_ulogic := '0';
  signal LEDs_tb : std_logic_vector(6 downto 0);
  signal push_tb : std_ulogic;
  signal SW_tb : std_ulogic_vector(3 downto 0);

  begin

  DUT : component Pattern1
    port map (genClk => clk_tb,
	      LEDs => LEDs_tb);


  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for 100 ns / 2;
  end process;

  STIMULUS : process is
    begin
      push_tb <= '1';
      wait for 300 ns;

      push_tb <= '0';
      wait for 200 ns;
  
      push_tb <= '1';
      wait for 50 ns;
  end process;

end architecture;
