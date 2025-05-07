library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinInterface is
	generic (
		stages   : positive;
		identity : natural
	);
	port (
		clock : in  std_logic;
		slot  : in  std_logic_vector(stages-1 downto 0);
		push  : out tdma_min_data;
		pull  : in  tdma_min_data;

		send  : in  tdma_min_port;
		recv  : out tdma_min_port
	);
end entity;

architecture rtl of TdmaMinInterface is

	constant id : tdma_min_addr := std_logic_vector(to_unsigned(identity, tdma_min_addr'length));
	signal addr : tdma_min_addr;

	signal empty : std_logic;
	signal req   : std_logic := '0';
	signal ack   : std_logic := '0';
	signal enqu  : tdma_min_fifo;
	signal dequ  : tdma_min_fifo;

	signal todo  : tdma_min_port;
	signal ready : boolean;

begin

	addr <= id xor (id'high downto stages => '0') & slot;

	fifo : entity ip.TdmaMinFifo
	port map (
		clock => clock,
		data  => enqu,
		rdreq => ack,
		wrreq => req,
		q     => dequ,
		empty => empty,
		full  => open
	);

	-- Send interface connected to fifo
	enqu <= send.addr & send.data;
	req  <= send.data(send.data'high);

	-- Next packet for network
	todo.addr <= dequ(dequ'high downto todo.data'length);
	todo.data <= dequ(todo.data'range);

	-- Wait for network circuit
	ready <= empty = '0' and todo.addr = addr;
	ack   <= '1' when ready else '0';
	push  <= todo.data when ready else (others => '0');

	-- Receive interface connected to network
	process(clock)
	begin
		if rising_edge(clock) then
			recv.addr <= addr;
			recv.data <= pull;
		end if;
	end process;

end architecture;
