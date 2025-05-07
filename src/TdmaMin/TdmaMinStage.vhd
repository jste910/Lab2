library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinStage is
	generic (
		terminals : positive
	);
	port (
		s : in  std_logic;
		i : in  tdma_min_datas(0 to terminals-1);
		o : out tdma_min_datas(0 to terminals-1)
	);
end entity;

architecture rtl of TdmaMinStage is
begin

	switches : for index in 0 to terminals/2-1 generate
		switch : entity work.TdmaMinSwitch
		port map (
			s => s,
			a => i(index),
			b => i(index+terminals/2),
			x => o(index*2),
			y => o(index*2+1)
		);
	end generate;

end architecture;
