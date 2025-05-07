library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity HexSeg6 is
	port (
		hexn : in  std_logic_vector(23 downto 0);
		seg0 : out std_logic_vector(6 downto 0);
		seg1 : out std_logic_vector(6 downto 0);
		seg2 : out std_logic_vector(6 downto 0);
		seg3 : out std_logic_vector(6 downto 0);
		seg4 : out std_logic_vector(6 downto 0);
		seg5 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture rtl of HexSeg6 is
begin

	hs0 : entity work.HexSeg
	port map (
		hex => hexn(3 downto 0),
		seg => seg0
	);

	hs1 : entity work.HexSeg
	port map (
		hex => hexn(7 downto 4),
		seg => seg1
	);

	hs2 : entity work.HexSeg
	port map (
		hex => hexn(11 downto 8),
		seg => seg2
	);

	hs3 : entity work.HexSeg
	port map (
		hex => hexn(15 downto 12),
		seg => seg3
	);

	hs4 : entity work.HexSeg
	port map (
		hex => hexn(19 downto 16),
		seg => seg4
	);

	hs5 : entity work.HexSeg
	port map (
		hex => hexn(23 downto 20),
		seg => seg5
	);

end architecture;
