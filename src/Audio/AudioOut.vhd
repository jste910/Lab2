library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity AudioOut is
	port (
		bclk   : in  std_logic;
		dacdat : out std_logic;
		daclrc : in  std_logic;

		clock  : in  std_logic;
		full   : out std_logic;
		put    : in  std_logic;
		data   : in  std_logic_vector(16 downto 0)
	);
end entity;

architecture rtl of AudioOut is

	signal fifo_empty : std_logic;
	signal fifo_get   : std_logic;
	signal fifo_data  : std_logic_vector(16 downto 0);

	signal channel_0 : std_logic_vector(15 downto 0) := (others => '0');
	signal channel_1 : std_logic_vector(15 downto 0) := (others => '0');
	signal shift     : std_logic_vector(15 downto 0) := (others => '0');

begin

	fifo_get <= not fifo_empty;

	fifo : entity ip.AudioFifo
	port map (
		data    => data,
		rdclk   => bclk,
		rdreq   => fifo_get,
		wrclk   => clock,
		wrreq   => put,
		q       => fifo_data,
		rdempty => fifo_empty,
		wrfull  => full
	);

	process(bclk)
		variable new_data : boolean;
	begin
		if rising_edge(bclk) then

			if new_data then
				if fifo_data(16) = '0' then
					channel_0 <= fifo_data(15 downto 0);
				else
					channel_1 <= fifo_data(15 downto 0);
				end if;
			end if;

			new_data := fifo_get = '1';
		end if;
	end process;

	process(bclk)
		variable last : std_logic;
	begin
		if rising_edge(bclk) then

			if daclrc /= last then
				if daclrc = '0' then
					shift <= channel_0;
				else
					shift <= channel_1;
				end if;
			else
				shift <= shift(14 downto 0) & '0';
			end if;
			last := daclrc;

		end if;
	end process;

	dacdat <= shift(15);

end architecture;
