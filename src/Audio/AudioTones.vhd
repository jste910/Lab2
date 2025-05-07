library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity AudioTones is
	port (
		bclk   : in  std_logic;
		adcdat : in  std_logic;
		adclrc : in  std_logic;

		clock  : in  std_logic;
		empty  : out std_logic;
		get    : in  std_logic;
		data   : out std_logic_vector(16 downto 0)
	);
end entity;

architecture rtl of AudioTones is

	signal fifo_put  : std_logic := '0';
	signal fifo_data : std_logic_vector(16 downto 0);

	signal rom_addr : unsigned(15 downto 0) := x"0000";
	signal rom_data : std_logic_vector(31 downto 0);

begin

	fifo : entity ip.AudioFifo
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

	rom : entity ip.AudioRom
	port map (
		address => std_logic_vector(rom_addr),
		clock   => bclk,
		q       => rom_data
	);

	process(bclk)
		variable last : std_logic;
	begin
		if rising_edge(bclk) then

			if adclrc = '0' and last = '1' then
				fifo_put  <= '1';
				fifo_data <= '0' & rom_data(23 downto 16) & rom_data(31 downto 24);
			elsif adclrc = '1' and last = '0' then
				fifo_put  <= '1';
				fifo_data <= '1' & rom_data(7 downto 0) & rom_data(15 downto 8);
				if rom_addr /= 47999 then
					rom_addr <= rom_addr + 1;
				else
					rom_addr <= (others => '0');
				end if;
			else
				fifo_put  <= '0';
				fifo_data <= (others => '0');
			end if;

			last := adclrc;

		end if;
	end process;

end architecture;
