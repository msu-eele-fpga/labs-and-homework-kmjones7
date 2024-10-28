library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Patterns_tb is
end entity;

architecture LED_Patterns_tb_arch of LED_Patterns_tb is
  component LED_Patterns
    port(clk : in std_ulogic; -- system clock
         rst : in std_ulogic; -- system reset (assume active high, change at top level if needed)
         PB : in std_ulogic;  -- Pushbutton to change state (assume active high, change at top level if needed)
         SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
         HPS_LED_control: in std_ulogic;	-- Software is in control when asserted (=1)
         Base_rate : in unsigned(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
         LED_reg : in std_ulogic_vector(7 downto 0); -- LED register
         LED : out std_ulogic_vector(7 downto 0)  -- LEDs on the DE10 NANO board
    );
  end component;

  signal clk_tb : std_ulogic := '0';
  signal rst_tb : std_ulogic;
  signal PB_tb : std_ulogic;
  signal SW_tb : std_ulogic_vector(3 downto 0);
  signal HPS_LED_control_tb : std_ulogic; 
  signal Base_rate_tb : unsigned(7 downto 0);
  signal LED_reg_tb : std_ulogic_vector(7 downto 0);
  signal LED_tb : std_ulogic_vector(7 downto 0);
  signal clkOut_tb : std_ulogic;

  begin

  DUT : component LED_Patterns
    port map(clk => clk_tb,
             rst => rst_tb,
 	     PB => PB_tb,
	     SW => SW_tb,
	     HPS_LED_control => HPS_LED_control_tb,
	     Base_rate => Base_rate_tb,
	     LED_reg => LED_reg_tb,
             LED => LED_tb
	     );


  clk_gen : process is
  begin

    clk_tb <= not clk_tb;
    wait for 20 ns / 2;
  end process;
  
  STIMULUS : process is
  begin
    PB_tb <= '1';
    SW_tb <= "0010";
    wait for 30000 ns;

    PB_tb <= '0';
    SW_tb <= "0001";
    wait for 1000 ns;
    SW_tb <= "0100";
    wait for 10000 ns;


    PB_tb <= '1';
    SW_TB <= "0100";
    wait for 30000 ns;


    PB_tb <= '0';
    SW_TB <= "0110";
    wait for 30000 ns;
  


    PB_tb <= '1';
    SW_TB <= "0110";
    wait for 30000 ns;
  end process;
end architecture;