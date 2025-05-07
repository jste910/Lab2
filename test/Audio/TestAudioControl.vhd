library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity TestAudioControl is
end entity;

architecture sim of TestAudioControl is

	signal clock : std_logic := '1';

	signal scl   : std_logic;
	signal sda   : std_logic;

begin

	clock <= not clock after 10 ns;

	dut : entity work.AudioControl
	port map (
		clock => clock,
		scl   => scl,
		sda   => sda
	);

end architecture;
