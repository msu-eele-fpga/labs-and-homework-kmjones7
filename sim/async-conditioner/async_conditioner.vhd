library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_conditioner is
  port( 
    clk : in std_ulogic;
    rst : in std_ulogic;
    async : in std_ulogic;
    sync : out std_ulogic
      );
end entity async_conditioner;

architecture async_conditioner_arch of async_conditioner is

 

 type time_array is array (natural range<>) of time;

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

  constant DEBOUNCE_TIME_10US       : time    := 10 us;
  constant DEBOUNCE_TIME_1US       : time    := 1000 ns;

  constant DEBOUNCE_TIMES : time_array(0 to 1) :=
  (
    DEBOUNCE_TIME_1US,
    DEBOUNCE_TIME_10US
  );


  
  signal async_input : std_ulogic;
  signal sync_to_debounce : std_ulogic;
  signal debounce_to_pulse : std_ulogic;
  signal asyncCon_to_pulse : std_ulogic;



  begin

--  ASYNC_MAP : async_conditioner port map (clk   => clk,
--				     rst => rst,
--			             async => async_input,
--	                             sync => asyncCon_to_pulse);
  async_input <= async;

  SYNC_MAP : synchronizer port map (clk => clk,
				    async => async_input,
		                    sync => sync_to_debounce);


  DEBOUNCE_MAP : debouncer generic map (clk_period => 20 ns,
                                        debounce_time => DEBOUNCE_TIME_10US)
                           port map (clk => clk,
				     rst => rst,
		 	 	     input => sync_to_debounce,
		                     debounced => debounce_to_pulse);    

  ONE_PULSE_MAP : one_pulse port map (clk => clk,
				  rst => rst,
		  		  input => debounce_to_pulse,
			    	  pulse => asyncCon_to_pulse);

  sync <= asyncCon_to_pulse;
  
  -- create three port maps (one for each component)
  -- create a signal for each output - input component interface
  

  



end architecture async_conditioner_arch;
