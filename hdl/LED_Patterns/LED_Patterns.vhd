library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LED_patterns is
  generic(
	       system_clock_period : time := 20 ns
			 );
  port(clk : in std_logic; -- system clock
       rst : in std_logic; -- system reset (assume active high, change at top level if needed)
       PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
       SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
       HPS_LED_control: in boolean;	-- Software is in control when asserted (=1)
       Base_rate : in unsigned(7 downto 0);  -- base transition period in seconds, fixed-point data type (W=8, F=4)
       LED_reg : in std_logic_vector(7 downto 0); -- LED register
       LED : out std_logic_vector(7 downto 0)  -- LEDs on the DE10 NANO board
  );
end entity LED_patterns;

architecture LED_patterns_arch of LED_patterns is

-- INTERNAL SIGNALS -----------------------------------------
  signal systemClk : std_logic; -- system clock 
  signal displayLED : integer := 0;
  signal reset : std_logic;     -- reset
  signal pushButton : std_logic;  -- PB
  signal buttonPush : std_logic; -- output of onePulse
  signal BR : unsigned(7 downto 0);
  signal switches : std_logic_vector(3 downto 0); -- 4 switches
  signal LED_register : std_logic_vector(7 downto 0); -- LED input register
  signal LEDs: std_logic_vector(7 downto 0);          -- LED output         
  signal oneLED : std_logic;                          -- first LED that be controlled by base rate
  signal sevenLEDs : std_logic_vector(6 downto 0);    -- 7 LEDs that will be controlled by state machine patterns
  
  signal sync_to_debounce : std_logic;               -- sync to debouncer signal
  signal debounced : std_logic;                      -- signal from debouncer
  signal debounce_to_onePulse : std_logic;
  signal newClk : std_logic;                         -- generated clock
  signal choosePatt : std_logic_vector(3 downto 0);
  signal swPatt : std_logic_vector(6 downto 0);
  signal patt0LED : std_logic_vector(6 downto 0);
  signal patt1LED : std_logic_vector(6 downto 0);
  signal patt2LED : std_logic_vector(6 downto 0);
  signal patt3LED : std_logic_vector(6 downto 0);
  signal patt4LED : std_logic_vector(6 downto 0);

  signal internDone : boolean;
  signal internEnable : boolean;
--------------------------------------------------------------------

-- COMPONENTS ----------------------------------------------------
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

  component one_pulse is
    port(
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    pulse : out std_logic
    );
  end component one_pulse;

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

  component State_Machine
    port (systemClk : in std_logic;
	       rst : in std_logic; -- system reset (assume active high, change at top level if needed)
          PB : in std_logic;  -- Pushbutton to change state (assume active high, change at top level if needed)
          SW : in std_logic_vector(3 downto 0); -- Switches that determine the next state to be selected
	       done : in boolean;
          Sel : out std_logic_vector(3 downto 0);
          enable : out boolean
         );
  end component;

  component showSW
    port(systemClk : in std_logic;
	      SW : in std_logic_vector(3 downto 0);
	      enable : in boolean;
	      done : out boolean;
	      LEDs : out std_logic_vector(6 downto 0)
	      );
  end component showSW;
  
  component Pattern0
    port(genClk : in std_logic;
	      LEDS : out std_logic_vector(6 downto 0)
	      );
  end component Pattern0;

  component Pattern1
    port(genClk : in std_logic;
         LEDs : out std_logic_vector(6 downto 0)
	      );
  end component Pattern1;

  component Pattern2
    port(genClk : in std_logic;
         LEDs : out std_logic_vector(6 downto 0)
	      );
  end component Pattern2;

  component Pattern3
    port(genClk : in std_logic;
         LEDs : out std_logic_vector(6 downto 0)
	     );
  end component Pattern3;

  component Pattern4
    port(genClk : in std_logic;
	      LEDs : out std_logic_vector(6 downto 0)
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
 

  SYNC_MAP : synchronizer port map(clk => systemClk,
		                             async => PB,                -- takes in PB signal
		                             sync => sync_to_debounce);  -- produces a synchronous PB signal

  
  DEBOUNCE_MAP : debouncer generic map(clk_period => 20 ns, 
                                       debounce_time => 100 ns) 
                           port map   (clk => systemClk,
				                           rst => reset,
		 	 	                           input => sync_to_debounce, -- takes in synchronous PB signal
		                                 debounced => debounce_to_onePulse); -- produces a debounced synchronous PB signal

  ONE_PULSE_MAP : one_pulse port map (clk => systemClk,
   				                       rst => reset,
    				                       input => debounce_to_onePulse, -- takes in debounced synchronous PB signal
   				                       pulse => buttonPush            -- produces a one clk period debounced synchronous PB signal
    				                       );

  CLOCK_GENERATOR_MAP : ClockGenerator generic map(system_clock_period => 20ns)
				       port map   (clk => systemClk,
						             PB => buttonPush, -- one pulse PB signal
                               SW => switches,
						             base_period => BR,
                               LEDout => oneLED, -- one LED flashing at current base rate
					                clkOut => newClk); -- new generated clock frequency

  STATE_MACHINE_MAP : State_Machine port map(systemClk => systemClk,
					                              rst => rst,
					                              PB => buttonPush,  -- one pulse PB signal
					                              SW => switches,
					                              done => internDone,  -- showSW done signal
					                              Sel => choosePatt,  -- produces a select signal to choose LED Pattern
					                              enable => internEnable);  -- enables showSW counter

  SHOWSW_MAP : showSW port map(systemClk => systemClk,
			                      SW => switches,
	                            enable => internEnable,  -- enable counter signal
			                      done => internDone,      -- counter done signal
			                      LEDs => swPatt);         -- switch LED Pattern

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


--  choosePattern : process (choosePatt)
--    begin
--          case (choosePatt) is
--	         when "0000" => LED(6 downto 0) <= patt0LED;
--         --   when "0001" => LED(6 downto 0) <= patt1LED;
--         --   when "0010" => LED(6 downto 0) <= patt2LED;
--            when "0011" => LED(6 downto 0) <= patt3LED;
--            when "0100" => LED(6 downto 0) <= patt4LED;
--	         when "1000" => LED(6 downto 0) <= swPatt;
--	         when others => LED(6 downto 0) <= patt0LED;
--          end case;
--  end process;
      
--------------------------------------------------------------------------------------------------



						     


end architecture LED_patterns_arch;