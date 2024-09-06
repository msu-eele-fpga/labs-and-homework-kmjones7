library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronizer is
port(
  clk : in std_ulogic;
  async : in std_ulogic;
  sync : out std_ulogic
);
end entity;


architecture flipFlops of synchronizer is
  signal between : std_ulogic;
  begin
    process(clk)
      begin
	if rising_edge(clk) then
	  between <= async;
	  sync <= between;
	end if;  
    end process;
end architecture;