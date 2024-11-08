library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity State_Machine is
  port (systemClk : in std_logic;
	     rst : in std_logic; -- system reset (assume active high, change at top level if needed)
        PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
        SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
        done : in boolean;
        Sel : out std_logic_vector(3 downto 0);
        enable : out boolean
       );
end entity State_Machine;

architecture State_Machine_arch of State_Machine is
  signal sync_to_debounce : std_logic;
  signal debounced : std_logic;
  signal genClk : std_logic;
  signal countLED : unsigned(7 downto 0);
  signal Base_rate : unsigned(7 downto 0);
  signal internSel : std_logic_vector(3 downto 0);
  signal internLED : std_logic;
  signal sixLEDs : std_logic_vector(6 downto 0);
  signal internEnable : boolean:= false;


  type State_Type is (s0, s1, s2, s3, s4, sCount);
  signal current_state, next_state, previous_state : State_Type;

  component synchronizer is
    port(
      clk : in std_logic;
      async : in std_logic;
      sync : out std_logic
      );
  end component synchronizer;

  component debouncer is
    generic(
      clk_period : time := 20 ns;
      debounce_time : time
      );
    port(
      clk : in std_logic;
      rst : in std_logic;
      input : in std_logic;
      debounced : out std_logic
      );
    end component debouncer;

  component ClockGenerator 
    generic  (system_clock_period : time := 20ns);
    port     (clk : in std_logic; 
	           PB : in std_logic;  
              SW : in std_logic_vector(3 downto 0); 
	           base_period : in unsigned(7 downto 0);
	           LEDout : out std_logic;
	           clkOut : out std_logic
	           );
  end component ClockGenerator; 

  begin

  SYNC_MAP : synchronizer port map(clk => systemClk,
		                             async => PB,
		                             sync => sync_to_debounce);

  
  DEBOUNCE_MAP : debouncer generic map(clk_period => 20 ns, -- what should I put here?
                                       debounce_time => 1000 ns) -- what should I put here?
                           port map   (clk => systemClk,
				                           rst => rst,
		 	 	                           input => sync_to_debounce,
		                                 debounced => debounced);

  CLOCK_GENERATOR_MAP : ClockGenerator generic map(system_clock_period => 20ns)
				                           port map   (clk => systemClk,
						                                 PB => debounced, -- synchronized and debounced button push goes into clock generator
                                                   SW => SW,
						                                 base_period => Base_rate,
   						                              LEDout => internLED,
					                                    clkOut => genClk);


--------------------------------------------------------------------
--- STATE MACHINE -------------------------------------------------
-- STATE MEMORY ------------------------------------------------------
  STATE_MEMORY : process (systemClk, rst)
    begin
      if (rst = '1') then		-- if reset = 0, 
	     current_state <= s0;
      elsif (rising_edge(systemClk)) then
	     current_state <= next_state;
      end if;
  end process;
-------------------------------------------------------------------------
  NEXT_STATE_LOGIC : process (systemClk)
    begin
	   if (rising_edge(systemClk)) then	
        if (PB = '1') then  -- if button has been pushed, show SW on LEDS
            previous_state <= current_state;
            next_state <= sCount;  
        elsif (done = true) then  -- if SW are done on LEDS
          case(SW) is
           when "0000" => next_state <= s0;
	        when "0001" => next_state <= s1;
	        when "0010" => next_state <= s2;
	        when "0011" => next_state <= s3;
	        when "0100" => next_state <= s4;
	        when others => next_state <= previous_state;
         end case;	
        else				         -- if SW AREN'T done on LEDS or push button hasn't changed	
        next_state <= current_state;  
      end if;
	  end if;
  end process;
----------------------------------------------------------------------
  OUTPUT_LOGIC : process (systemClk)
    begin
	 if (rising_edge(systemClk)) then
        case (current_state) is
          when s0 => internSel <= "0000"; internEnable <= false;
	       when s1 => internSel <= "0001"; internEnable <= false;
	       when s2 => internSel <= "0010"; internEnable <= false;
	       when s3 => internSel <= "0011"; internEnable <= false;
	       when s4 => internSel <= "0100"; internEnable <= false;
			 when sCount => internSel <= "1000"; internEnable <= true;
          when others => internSel <= "0000";
        end case; 
        Sel <= internSel;
        enable <= internEnable;
    end if;
  end process;




end architecture State_Machine_arch;