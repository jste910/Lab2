library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestTdmaMinInterface is
	generic (
		stages : positive := 3
	);
end entity;

architecture sim of TestTdmaMinInterface is

	signal clock : std_logic := '1';
	signal slot  : unsigned(stages-1 downto 0) := (others => '0');

	signal push : tdma_min_data;
	signal pull : tdma_min_data;
	signal send : tdma_min_port;
	signal recv : tdma_min_port;

begin

	clock <= not clock after 10 ns;

	dut : entity work.TdmaMinInterface
	generic map (
		stages   => stages,
		identity => 2
	)
	port map (
		clock => clock,
		slot  => std_logic_vector(slot),
		push  => push,
		pull  => pull,
		send  => send,
		recv  => recv
	);

	process(clock)
	begin
		if rising_edge(clock) then
			slot <= slot + 1;
		end if;
	end process;

	process
	begin
		send.addr <= x"00";
		send.data <= x"00000000";
		wait for 100 ns;
		send.addr <= x"02";
		send.data <= x"ffffffff";
		wait for 20 ns;
		send.addr <= x"01";
		send.data <= x"eeeeeeee";
		wait for 20 ns;
		send.addr <= x"07";
		send.data <= x"dddddddd";
		wait for 20 ns;
		send.addr <= x"03";
		send.data <= x"cccccccc";
		wait for 20 ns;
		send.addr <= x"00";
		send.data <= x"bbbbbbbb";
		wait for 20 ns;
		send.addr <= x"ff";
		send.data <= x"7fffffff";
		wait;
	end process;

end architecture;
