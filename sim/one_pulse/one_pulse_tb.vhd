library ieee;
use ieee.std_logic_1164.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture one_pulse_tb_arch of one_pulse_tb is
 
  component one_pulse is
    port(
      clk : in std_ulogic;
      rst : in std_ulogic;
      input : in std_ulogic;
      pulse : out std_ulogic
      );
  end component one_pulse;

  signal clk_tb : std_ulogic := '0';
  signal rst_tb : std_ulogic := '0';
  signal input_tb : std_ulogic := '0';
  signal pulse_tb : std_ulogic;
  signal toggle : inter := '0;

 begin
  
    dut : component one_pulse
    port map (
      clk   => clk_tb,
      rst => rst_tb,
      input  => input_tb,
      pulse => pulse_tb
    );

-- create one_pulse signal
  OP_TB : process is
    begin
    if (input_tb = '1') then
      pulse_tb <= '1'; wait for 40 ns;
    else
      pulse_tb <= '0'; 
  end process;
-- compare expected to actual
  COMPARE : process is
    begin
    if (pulse_tb <= '1' and pulse <= '0') then
      report "Expecting '1', Actual '0'"
    elsif (pulse_tb <= '0' and pulse <= '1') then
      report "Expecting '0', Actual '1'"
    end else;
    end process;
     
end architecture one_pulse_tb_arch;