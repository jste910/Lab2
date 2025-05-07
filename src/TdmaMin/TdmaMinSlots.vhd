library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity TdmaMinSlots is
	generic (
		stages : positive
	);
	port (
		clock : in  std_logic;
		slot  : out std_logic_vector(stages-1 downto 0)
	);
end entity;

architecture rtl of TdmaMinSlots is

	signal count : unsigned(stages-1 downto 0) := (others => '0');

begin

	process(clock)
	begin
		if rising_edge(clock) then
			count <= count + 1;
		end if;
	end process;

	slot <= std_logic_vector(count);

end architecture;
