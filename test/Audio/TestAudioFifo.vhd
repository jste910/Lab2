library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity TestAudioFifo is
end entity;

architecture sim of TestAudioFifo is

	signal clock  : std_logic := '1';
	signal empty  : std_logic := '1';
	signal get    : std_logic := '0';
	signal data   : std_logic_vector(16 downto 0);

	signal bclk      : std_logic := '1';
	signal fifo_put  : std_logic := '0';
	signal fifo_data : std_logic_vector(16 downto 0);

	signal ready : boolean := false;
	signal send  : std_logic_vector(16 downto 0);

begin

	clock <= not clock after 10 ns;
	bclk  <= not bclk  after 162.5 ns;

	dut : entity ip.AudioFifo
	port map (
		data    => fifo_data,
		rdclk   => clock,
		rdreq   => get,
		wrclk   => bclk,
		wrreq   => fifo_put,
		q       => data,
		rdempty => empty,
		wrfull  => open
	);

	ready <= true after 2600 ns;
	get <= not empty when ready else '0';

	process(clock)
		variable new_data : boolean;
	begin
		if rising_edge(clock) then

			if new_data then
				send <= data;
			else
				send <= (others => '-');
			end if;

			new_data := get = '1';
		end if;
	end process;

	process
	begin
		fifo_put <= '0';
		fifo_data <= 'X' & x"dead";
		wait for 650 ns;

		fifo_put <= '1';
		fifo_data <= '0' & x"1111";
		wait for 325 ns;
		fifo_data <= '1' & x"2222";
		wait for 325 ns;
		fifo_data <= '0' & x"3333";
		wait for 325 ns;
		fifo_data <= '1' & x"4444";
		wait for 325 ns;

		fifo_put <= '0';
		fifo_data <= 'X' & x"dead";
		wait for 3250 ns;

		fifo_put <= '1';
		fifo_data <= '0' & x"5555";
		wait for 325 ns;
		fifo_data <= '1' & x"6666";
		wait for 325 ns;
		fifo_data <= '0' & x"7777";
		wait for 325 ns;
		fifo_data <= '1' & x"8888";
		wait for 325 ns;

		fifo_put <= '0';
		fifo_data <= 'X' & x"dead";
		wait;
	end process;

end architecture;
