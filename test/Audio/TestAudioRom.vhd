library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity TestAudioRom is
end entity;

architecture sim of TestAudioRom is

	signal bclk   : std_logic := '1';
	signal adcdat : std_logic := '0';
	signal adclrc : std_logic := '0';

	signal rom_addr : unsigned(15 downto 0) := x"0000";
	signal rom_data : std_logic_vector(31 downto 0);

	signal channel_0 : signed(15 downto 0);
	signal channel_1 : signed(15 downto 0);

begin

	bclk  <= not bclk  after 162.5 ns;

	dut : entity ip.AudioRom
	port map (
		address => std_logic_vector(rom_addr),
		clock   => bclk,
		q       => rom_data
	);

	process(bclk)
		variable n : positive;
	begin
		if rising_edge(bclk) then
			if n /= 32 then
				n := n + 1;
			else
				n := 1;
				adclrc <= not adclrc;
			end if;
		end if;
	end process;

	process(bclk)
		variable last : std_logic;
	begin
		if rising_edge(bclk) then

			if adclrc = '0' and last = '1' then
				channel_0 <= signed(rom_data(23 downto 16) & rom_data(31 downto 24));
			elsif adclrc = '1' and last = '0' then
				channel_1 <= signed(rom_data(7 downto 0) & rom_data(15 downto 8));
				if rom_addr /= 47999 then
					rom_addr <= rom_addr + 1;
				else
					rom_addr <= (others => '0');
				end if;
			end if;

			last := adclrc;

		end if;
	end process;

end architecture;
