library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
  port(
    clk : in std_ulogic;
    rst : in std_ulogic;
    nickel : in std_ulogic;
    dime : in std_ulogic;
    dispense: out std_ulogic;
    amount : out natural range 0 to 15
    );
end entity vending_machine;

architecture vending_arch of vending_machine is
 
  type State_Type is (s0, s5, s10, s15);
  signal current_state, next_state : State_Type;
  signal counter : natural range 0 to 20;
  
  begin
  -----------------------------------------------------------------
  STATE_MEMORY : process (clk, rst)
    begin
      if (rst = '1') then		-- if reset = 0, 
	current_state <= s0;
      elsif (rising_edge(clk)) then
	current_state <= next_state;
      end if;
  end process;
---------------------------------------------------------------------
  NEXT_STATE_AND_OUTPUT_LOGIC : process (current_state, nickel, dime)
    begin
      case (current_state) is
	when s0 => amount <= 0;
		   if (dime = '1') then
		     next_state <= s10;
 		   elsif (nickel = '1' and dime = '0') then
		     next_state <= s5;
		   else
		     next_state <= s0;
		   end if;
		   dispense <= '0';
	when s5 => amount <= 5;
		   if (dime = '1') then
		     next_state <= s15;
		   elsif (nickel = '1' and dime = '0') then
		     next_state <= s10;
	           else 
	             next_state <= s5;
		   end if;
		   dispense <= '0';
	when s10 => amount <= 10;
		    if (nickel = '1' or dime = '1') then
		      next_state <= s15;
		    else
		      next_state <= s10;
		    end if;
		    dispense <= '0';
	when s15 => amount <= 15; next_state <= s0; amount <= 15; dispense <= '1';
      end case;
  end process;
-----------------------------------------------------------------------
end architecture;	    
  