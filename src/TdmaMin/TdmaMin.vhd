library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMin is
	generic (
		ports : positive
	);
	port (
		clock : in  std_logic;
		sends : in  tdma_min_ports(0 to ports-1);
		recvs : out tdma_min_ports(0 to ports-1)
	);
end entity;

architecture rtl of TdmaMin is

	constant stages : positive := log2Ceil(ports);

	signal slot : std_logic_vector(stages-1 downto 0);
	signal push : tdma_min_datas(0 to ports-1);
	signal pull : tdma_min_datas(0 to ports-1);

begin

	slots : entity work.TdmaMinSlots
	generic map (
		stages => stages
	)
	port map (
		clock => clock,
		slot  => slot
	);

	fabric : entity work.TdmaMinFabric
	generic map (
		stages => stages,
		ports  => ports
	)
	port map (
		slot => slot,
		push => push,
		pull => pull
	);

	interfaces : for identity in 0 to ports-1 generate
		interface : entity work.TdmaMinInterface
		generic map (
			stages   => stages,
			identity => identity
		)
		port map (
			clock => clock,
			slot  => slot,
			push  => push(identity),
			pull  => pull(identity),

			send  => sends(identity),
			recv  => recvs(identity)
		);
	end generate;

end architecture;
