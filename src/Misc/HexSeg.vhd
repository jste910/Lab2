library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity HexSeg is
	port (
		hex : in  std_logic_vector(3 downto 0);
		seg : out std_logic_vector(6 downto 0)
	);
end entity;

architecture rtl of HexSeg is
begin

	with hex select seg <=
		"1000000" when x"0",
		"1111001" when x"1",
		"0100100" when x"2",
		"0110000" when x"3",
		"0011001" when x"4",
		"0010010" when x"5",
		"0000010" when x"6",
		"1111000" when x"7",
		"0000000" when x"8",
		"0010000" when x"9",
		"0001000" when x"a",
		"0000011" when x"b",
		"1000110" when x"c",
		"0100001" when x"d",
		"0000110" when x"e",
		"0001110" when x"f",
		"1111111" when others;

end architecture;
