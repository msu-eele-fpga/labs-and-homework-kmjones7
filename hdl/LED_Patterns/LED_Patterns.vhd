library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LED_patterns is
  generic(
	       system_clock_period : time := 20 ns
			 );
  port(clk : in std_ulogic; -- system clock
       rst : in std_ulogic; -- system reset (assume active high, change at top level if needed)
       PB : in std_ulogic;  -- Pushbutton to change state (assume active high, change at top level if needed)
       SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
       HPS_LED_control: in boolean;	-- Software is in control when asserted (=1)
       Base_rate : in unsigned(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
       LED_reg : in std_ulogic_vector(7 downto 0); -- LED register
       LED : out std_ulogic_vector(7 downto 0)  -- LEDs on the DE10 NANO board
  );
end entity LED_patterns;

architecture LED_patterns_arch of LED_patterns is

-- INTERNAL SIGNALS -----------------------------------------
  signal systemClk : std_ulogic; -- system clock 
  signal displayLED : integer := 0;
  signal reset : std_ulogic;     -- reset
  signal pushButton : std_ulogic;  -- PB
  signal buttonPush : std_ulogic; -- output of onePulse
  signal BR : unsigned(7 downto 0);
  signal switches : std_ulogic_vector(3 downto 0); -- 4 switches
  signal LED_register : std_ulogic_vector(7 downto 0); -- LED input register
  signal LEDs: std_ulogic_vector(7 downto 0);          -- LED output         
  signal oneLED : std_ulogic;                          -- first LED that be controlled by base rate
  signal sevenLEDs : std_ulogic_vector(6 downto 0);    -- 7 LEDs that will be controlled by state machine patterns
  
  signal sync_to_debounce : std_ulogic;               -- sync to debouncer signal
  signal debounced : std_ulogic;                      -- signal from debouncer
  signal debounce_to_onePulse : std_ulogic;
  signal newClk : std_ulogic;                         -- generated clock
  signal choosePatt : std_ulogic_vector(3 downto 0);
  signal swPatt : std_ulogic_vector(6 downto 0);
  signal patt0LED : std_ulogic_vector(6 downto 0);
  signal patt1LED : std_ulogic_vector(6 downto 0);
  signal patt2LED : std_ulogic_vector(6 downto 0);
  signal patt3LED : std_ulogic_vector(6 downto 0);
  signal patt4LED : std_ulogic_vector(6 downto 0);

  signal internDone : boolean;
  signal internEnable : boolean;
--------------------------------------------------------------------

-- COMPONENTS ----------------------------------------------------
  component synchronizer is
    port(
      clk : in std_ulogic;
      async : in std_ulogic;
      sync : out std_ulogic
      );
  end component synchronizer;

  component debouncer is
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
    end component debouncer;

  component one_pulse is
    port(
    clk : in std_ulogic;
    rst : in std_ulogic;
    input : in std_ulogic;
    pulse : out std_ulogic
    );
  end component one_pulse;

  component ClockGenerator 
    generic  (system_clock_period : time := 20ns);
    port     (clk : in std_ulogic; 
	      PB : in std_ulogic;  
              SW : in std_ulogic_vector(3 downto 0); 
	      base_period : in unsigned(7 downto 0);
              LEDout : out std_ulogic;
	      clkOut : out std_ulogic
	      );
  end component ClockGenerator; 

  component State_Machine
    port (systemClk : in std_ulogic;
	  rst : in std_ulogic; -- system reset (assume active high, change at top level if needed)
          PB : in std_ulogic;  -- Pushbutton to change state (assume active high, change at top level if needed)
          SW : in std_ulogic_vector(3 downto 0); -- Switches that determine the next state to be selected
	  done : in boolean;
          Sel : out std_ulogic_vector(3 downto 0);
          enable : out boolean
         );
  end component;

  component showSW
    port(systemClk : in std_ulogic;
	 SW : in std_ulogic_vector(3 downto 0);
	 enable : in boolean;
	 done : out boolean;
	 LEDs : out std_ulogic_vector(6 downto 0)
	 );
  end component showSW;
  
  component Pattern0
    port(genClk : in std_ulogic;
	 LEDS : out std_ulogic_vector(6 downto 0)
	 );
  end component Pattern0;

  component Pattern1
    port(genClk : in std_ulogic;
         LEDs : out std_ulogic_vector(6 downto 0)
	 );
  end component Pattern1;

  component Pattern2
    port(genClk : in std_ulogic;
         LEDs : out std_ulogic_vector(6 downto 0)
	 );
  end component Pattern2;

  component Pattern3
    port(genClk : in std_ulogic;
         LEDs : out std_ulogic_vector(6 downto 0)
	 );
  end component Pattern3;

  component Pattern4
    port(genClk : in std_ulogic;
	 LEDs : out std_ulogic_vector(6 downto 0)
	 );
  end component Pattern4;
------------------------------------------------------------

  begin

-- SIGNAL ASSIGNMENTS AND PORT MAPPING ----------------------------------------------
  systemClk <= clk;
  reset <= rst;
  pushButton <= PB;
  switches <= SW;
  BR <= Base_rate;
  
  LED_register <= LED_reg;
 
--  LEDs(7) <= oneLED;
 -- LEDs(6 downto 0) <= sevenLEDs;

  SYNC_MAP : synchronizer port map(clk => systemClk,
		                   async => PB,
		                   sync => sync_to_debounce);

  
  DEBOUNCE_MAP : debouncer generic map(clk_period => 20 ns, -- what should I put here?
                                       debounce_time => 100 ns) -- what should I put here?
                           port map   (clk => systemClk,
				       rst => reset,
		 	 	       input => sync_to_debounce,
		                       debounced => debounce_to_onePulse);

  ONE_PULSE_MAP : one_pulse port map (clk => systemClk,
   				      rst => reset,
    				      input => debounce_to_onePulse,
   				      pulse => buttonPush
    				      );

  CLOCK_GENERATOR_MAP : ClockGenerator generic map(system_clock_period => 20ns)
				       port map   (clk => systemClk,
						   PB => buttonPush, -- synchronized and debounced button push goes into clock generator
                                                   SW => switches,
						   base_period => BR,
                                                   LEDout => oneLED,
					           clkOut => newClk);

  STATE_MACHINE_MAP : State_Machine port map(systemClk => systemClk,
					     rst => rst,
					     PB => buttonPush,
					     SW => switches,
					     done => internDone,
					     Sel => choosePatt,
					     enable => internEnable);

  SHOWSW_MAP : showSW port map(systemClk => systemClk,
			       SW => switches,
	                       enable => internEnable,
			       done => internDone,
			       LEDs => swPatt);

  PATTERN0_MAP : Pattern0 port map(genClk => newClk,
				   LEDS => patt0LED);

  PATTERN1_MAP : Pattern1 port map(genClk => newClk,
                                   LEDs => patt1LED);

  PATTERN2_MAP : Pattern2 port map(genClk => newClk,
				   LEDs => patt2LED);

  PATTERN3_MAP : Pattern3 port map(genClk => newClk,
				   LEDs => patt3LED);

  PATTERN4_MAP : Pattern4 port map (genClk => newClk,
		 		    LEDs => patt4LED);
  


  toggleLED1 : process (oneLED)
    begin
      LED(7) <= oneLED;
  end process;


  choosePattern : process (choosePatt)
    begin
          case (choosePatt) is
	    when "0000" => LED(6 downto 0) <= patt0LED;
            when "0001" => LED(6 downto 0) <= patt1LED;
            when "0010" => LED(6 downto 0) <= patt2LED;
            when "0011" => LED(6 downto 0) <= patt3LED;
            when "0100" => LED(6 downto 0) <= patt4LED;
	    when "1000" => LED(6 downto 0) <= swPatt;
	    when others => LED(6 downto 0) <= patt1LED;
          end case;
  end process;
      
--------------------------------------------------------------------------------------------------



						     


end architecture LED_patterns_arch;