library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinFabric is
	generic (
		stages : positive;
		ports  : positive
	);
	port (
		slot : in  std_logic_vector(stages-1 downto 0);
		push : in  tdma_min_datas(0 to ports-1);
		pull : out tdma_min_datas(0 to ports-1)
	);
end entity;

architecture rtl of TdmaMinFabric is

	constant terminals : positive := 2**stages;

	type links_t is array (stages downto 0) of tdma_min_datas(0 to terminals-1);
	signal links: links_t;

begin

	links(stages)(ports to terminals-1) <= (others => (others => '0'));
	links(stages)(0 to ports-1) <= push;
	pull <= links(0)(0 to ports-1);

	staging : for index in stages-1 downto 0 generate
		stage : entity work.TdmaMinStage
		generic map (
			terminals => terminals
		)
		port map (
			s => slot(index),
			i => links(index+1),
			o => links(index)
		);
	end generate;

end architecture;
