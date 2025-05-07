library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestDac is
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture sim of TestDac is

	signal channel_0 : signed(15 downto 0);
	signal channel_1 : signed(15 downto 0);

begin

	process(clock)
	begin
		if rising_edge(clock) then
			if recv.data(31 downto 28) = "1000" then
				if recv.data(16) = '0' then
					channel_0 <= signed(recv.data(15 downto 0));
				else
					channel_1 <= signed(recv.data(15 downto 0));
				end if;
			end if;
		end if;
	end process;

end architecture;
