library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestTopLevel is
	generic (
		ports : positive := 8
	);
end entity;

architecture sim of TestTopLevel is

	signal clock : std_logic := '1';

	signal send_port : tdma_min_ports(0 to ports-1);
	signal recv_port : tdma_min_ports(0 to ports-1);

begin

	clock <= not clock after 10 ns;

	tdma_min : entity work.TdmaMin
	generic map (
		ports => ports
	)
	port map (
		clock => clock,
		sends => send_port,
		recvs => recv_port
	);

	asp_adc : entity work.TestAdc
	generic map (
		forward => 1
	)
	port map (
		clock => clock,
		send  => send_port(0),
		recv  => recv_port(0)
	);

	asp_dac : entity work.TestDac
	port map (
		clock => clock,
		send  => send_port(1),
		recv  => recv_port(1)
	);

end architecture;
