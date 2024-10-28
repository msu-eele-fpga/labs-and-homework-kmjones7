library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
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
end entity debouncer;

architecture debouncer_arch of debouncer is
  signal ONcounter : integer := 0;
  signal OFFcounter : integer := 0;
  signal DB_COUNTER : integer := debounce_time/clk_period;


 
  type State_Type is (sWait, dbON, dbOFF);
  signal current_state, next_state : State_Type;

  begin
---------------------------------------------------------------------
  STATE_MEMORY : process (clk, rst)
    begin
      if (rst = '1') then		-- if reset = 0, 
	current_state <= sWait;
      elsif (rising_edge(clk)) then
	current_state <= next_state;
      end if;
  end process;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
  NEXT_STATE_LOGIC : process (clk, current_state, input)
    begin
      case (current_state) is
---------------------------------------------------
        when sWait => 
	  if (input = '1') then
	    debounced <= '1';
	    next_state <= dbON;
	  else
	    debounced <= '0';
	    next_state <= sWait;
	  end if;
--------------------------------------------------
        when dbON => 
          if (ONcounter < DB_COUNTER - 1) then
	    debounced <= '1';
 	    next_state <= dbON;
	  else
	    if (input = '0') then
	      debounced <= '0';
	      next_state <= dbOFF;
	    else
	      debounced <= '1';
	      next_state <= dbON;
	    end if;
	  end if;
--------------------------------------------------
	when dbOFF =>
	  debounced <= '0';
	  if (OFFcounter < DB_COUNTER - 1) then
	    debounced <= '0';
	    next_state <= dbOFF;
	  else
	    debounced <= '0';
	    next_state <= sWait;
	  end if;
	end case;
  end process;

 counters : process (clk)
    begin
    if (rising_edge(clk)) then
      case (current_state) is
---------------------------------------------------
        when sWait => 
	  OFFcounter <= 0;
	  ONcounter <= 0;
--------------------------------------------------
        when dbON => 
          if (ONcounter < DB_COUNTER) then
	    ONcounter <= ONcounter + 1;
	  --else
	  --  ONcounter <= 0;
	  end if;
--------------------------------------------------
	when dbOFF =>
	  if (OFFcounter < DB_COUNTER) then
	    OFFcounter <= OFFcounter + 1;
	  --else
	  --  OFFcounter <= 0;
	  end if;
	end case;
    end if;
  end process;
-------------------------------------------------------------------------

----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--  OUTPUT_LOGIC : process (current_state)
--    begin
--        case (current_state) is
--	  when sWait => debounced <= '0';
--	  when dbON => debounced <= '1';
-- 	  when dbOFF => debounced <= '0';
--        end case;
--  end process;

end architecture debouncer_arch;