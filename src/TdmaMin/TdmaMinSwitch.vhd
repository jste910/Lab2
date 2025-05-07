library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinSwitch is
	port (
		s : in  std_logic;
		a : in  tdma_min_data;
		b : in  tdma_min_data;
		x : out tdma_min_data;
		y : out tdma_min_data
	);
end entity;

architecture rtl of TdmaMinSwitch is
begin

	x <= a when s = '0' else b;
	y <= b when s = '0' else a;

end architecture;
