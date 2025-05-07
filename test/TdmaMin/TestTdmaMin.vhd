library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestTdmaMin is
	generic (
		ports : positive := 5
	);
end entity;

architecture sim of TestTdmaMin is

	signal clock : std_logic := '1';

	signal send_port : tdma_min_ports(0 to ports-1);
	signal recv_port : tdma_min_ports(0 to ports-1);

begin

	clock <= not clock after 10 ns;

	dut : entity work.TdmaMin
	generic map (
		ports => ports
	)
	port map (
		clock => clock,
		sends => send_port,
		recvs => recv_port
	);

	process
	begin
		wait for 100 ns;
		send_port(0).addr <= x"03";
		send_port(0).data <= x"80000001";
		send_port(1).addr <= x"07";
		send_port(1).data <= x"80000002";
		send_port(2).addr <= x"02";
		send_port(2).data <= x"80000003";
		send_port(3).addr <= x"00";
		send_port(3).data <= x"80000004";
		send_port(4).addr <= x"02";
		send_port(4).data <= x"80000005";
		wait for 20 ns;
		send_port(0).addr <= (others => '0');
		send_port(0).data <= (others => '0');
		send_port(1).addr <= (others => '0');
		send_port(1).data <= (others => '0');
		send_port(2).addr <= (others => '0');
		send_port(2).data <= (others => '0');
		send_port(3).addr <= (others => '0');
		send_port(3).data <= (others => '0');
		send_port(4).addr <= (others => '0');
		send_port(4).data <= (others => '0');
		wait;
	end process;

end architecture;
