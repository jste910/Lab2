library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity TestAudioOut is
end entity;

architecture sim of TestAudioOut is

	signal clock  : std_logic := '1';
	signal full   : std_logic := '0';
	signal put    : std_logic := '0';
	signal data   : std_logic_vector(16 downto 0);

	signal bclk   : std_logic := '1';
	signal dacdat : std_logic := '0';
	signal daclrc : std_logic := '0';

begin

	clock <= not clock after 10 ns;
	bclk  <= not bclk  after 162.5 ns;

	dut : entity work.AudioOut
	port map (
		bclk   => bclk,
		dacdat => dacdat,
		daclrc => daclrc,

		clock  => clock,
		full   => full,
		put    => put,
		data   => data
	);

	process(bclk)
		variable n : positive;
	begin
		if rising_edge(bclk) then
			if n /= 32 then
				n := n + 1;
			else
				n := 1;
				daclrc <= not daclrc;
			end if;
		end if;
	end process;

	process
	begin
		put <= '0';
		data <= 'X' & x"dead";
		wait for 10400 ns;

		put <= '1';
		data <= '0' & x"1111";
		wait for 20 ns;
		data <= '1' & x"2222";
		wait for 20 ns;
		data <= '0' & x"3333";
		wait for 20 ns;
		data <= '1' & x"4444";
		wait for 20 ns;
		data <= '0' & x"f555";
		wait for 20 ns;
		data <= '1' & x"aaaf";
		wait for 20 ns;

		put <= '0';
		data <= 'X' & x"dead";
		wait for 41480 ns;

		put <= '1';
		data <= '0' & x"f001";
		wait for 20 ns;
		data <= '1' & x"800f";
		wait for 20 ns;

		put <= '0';
		data <= 'X' & x"dead";
		wait;
	end process;

end architecture;
