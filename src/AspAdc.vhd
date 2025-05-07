library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity AspAdc is
	port (
		clock : in  std_logic;
		empty : in  std_logic;
		get   : out std_logic;
		data  : in  std_logic_vector(16 downto 0);

		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture rtl of AspAdc is

	signal addr_0   : std_logic_vector(3 downto 0) := "0010";
	signal addr_1   : std_logic_vector(3 downto 0) := "0010";
	signal rate_0   : std_logic_vector(1 downto 0) := "00";
	signal rate_1   : std_logic_vector(1 downto 0) := "00";
	signal enable_0 : std_logic := '0';
	signal enable_1 : std_logic := '0';

begin

	get <= not empty;

	process(clock)
	begin
		if rising_edge(clock) then

			if recv.data(31 downto 28) = "1010" then
				if recv.data(16) = '0' then
					addr_0   <= recv.data(23 downto 20);
					rate_0   <= recv.data(19 downto 18);
					enable_0 <= recv.data(17);
				else
					addr_1   <= recv.data(23 downto 20);
					rate_1   <= recv.data(19 downto 18);
					enable_1 <= recv.data(17);
				end if;
			end if;

		end if;
	end process;

	process(clock)
		variable new_data : boolean;
		variable tick_0 : unsigned(7 downto 0) := x"00";
		variable tick_1 : unsigned(7 downto 0) := x"00";
	begin
		if rising_edge(clock) then

			if new_data and data(16) = '0' and enable_0 = '1' then
				if tick_0 /= 0 then
					tick_0 := tick_0 - 1;
					send.addr <= (others => '0');
					send.data <= (others => '0');
				else
					case rate_0 is
						when "11"   => tick_0 := x"ff";
						when "10"   => tick_0 := x"0f";
						when "01"   => tick_0 := x"03";
						when others => tick_0 := x"00";
					end case;
					send.addr <= "0000" & addr_0;
					send.data <= "100000000000000" & data;
				end if;
			elsif new_data and data(16) = '1' and enable_1 = '1' then
				if tick_1 /= 0 then
					tick_1 := tick_1 - 1;
					send.addr <= (others => '0');
					send.data <= (others => '0');
				else
					case rate_1 is
						when "11"   => tick_1 := x"ff";
						when "10"   => tick_1 := x"0f";
						when "01"   => tick_1 := x"03";
						when others => tick_1 := x"00";
					end case;
					send.addr <= "0000" & addr_1;
					send.data <= "100000000000000" & data;
				end if;
			else
				send.addr <= (others => '0');
				send.data <= (others => '0');
			end if;

			new_data := empty = '0';
		end if;
	end process;

end architecture;
