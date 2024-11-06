library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine_tb is
end entity;

architecture State_Machine_tb_arch of State_Machine_tb is

  component State_Machine is
    port (systemClk : in std_logic;
	  rst : in std_logic; -- system reset (assume active high, change at top level if needed)
          PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
          SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
          done : in boolean;
	  Sel : out std_logic_vector(3 downto 0);
	  enable : out boolean
          );
  end component;


  signal Clk_tb : std_logic := '0';
  signal rst_tb : std_logic;
  signal done_tb : boolean;
  signal enable_tb : boolean;
  signal PB_tb : std_logic;
  signal SW_tb : std_logic_vector(3 downto 0);
  signal Sel_tb : std_logic_vector(3 downto 0) := "0000";

  begin

  DUT : component State_Machine
    port map(systemClk => Clk_tb,
	     rst => rst_tb,
	     PB => PB_tb,
	     SW => SW_tb,
	     done => done_tb,
	     Sel => Sel_tb,
	     enable => enable_tb
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
    wait for 300 ns;

    PB_tb <= '0';
    SW_tb <= "0001";
    wait for 100 ns;
    SW_tb <= "0100";
    wait for 100 ns;


    PB_tb <= '1';
    SW_TB <= "0100";
    wait for 300 ns;


    PB_tb <= '0';
    SW_TB <= "0110";
    wait for 300 ns;
  


    PB_tb <= '1';
    SW_TB <= "0110";
    wait for 300 ns;
  
  end process;
  


end architecture;
