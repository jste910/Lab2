library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity AudioControl is
	port (
		clock : in    std_logic;
		scl   : out   std_logic;
		sda   : inout std_logic
	);
end entity;

architecture rtl of AudioControl is

	constant ticks : positive := 125; -- 50MHz / 400kHz

	signal scl_clk : std_logic := '1';
	signal sda_clk : std_logic := '1';

	signal scl_drive : std_logic := '0';
	signal sda_drive : std_logic := '0';
	signal sda_bit   : std_logic := '0';

	type states is (
		idle,
		start,
		devi_out,
		devi_ack,
		addr_out,
		addr_ack,
		data_out,
		data_ack,
		stop
	);
	signal state : states := idle;

	-- Input
	signal valid : std_logic := '0';
	signal addr  : std_logic_vector(6 downto 0);
	signal data  : std_logic_vector(8 downto 0);

	-- Output
	signal ready   : std_logic := '1';
	signal success : std_logic := '0';

begin

	-- Clock generation
	process(clock)
		variable tick : positive := 1;
	begin
		if rising_edge(clock) then

			case tick is
				when ticks/4 =>
					scl_clk <= '1';
					sda_clk <= '0';
				when ticks/4*2 =>
					scl_clk <= '0';
					sda_clk <= '0';
				when ticks/4*3 =>
					scl_clk <= '0';
					sda_clk <= '1';
				when ticks =>
					scl_clk <= '1';
					sda_clk <= '1';
				when others =>
					null;
			end case;

			if tick /= ticks then
				tick := tick + 1;
			else
				tick := 1;
			end if;

		end if;
	end process;

	-- State machine
	process(sda_clk)
		variable bits    : std_logic_vector(23 downto 0);
		variable index   : natural;
		variable failure : std_logic;
	begin
		if rising_edge(sda_clk) then
			case state is

				when idle =>
					if valid = '0' then
						state <= idle;
					else
						bits := "00110100" & addr & data;
						ready <= '0';
						success <= '0';
						state <= start;
					end if;

				when start =>
					index := 23;
					sda_bit <= bits(index);
					state <= devi_out;

				when devi_out =>
					if index /= 16 then
						index := index - 1;
						sda_bit <= bits(index);
						state <= devi_out;
					else
						sda_bit <= '0';
						state <= devi_ack;
					end if;

				when devi_ack =>
					index := index - 1;
					sda_bit <= bits(index);
					state <= addr_out;

				when addr_out =>
					if index /= 8 then
						index := index - 1;
						sda_bit <= bits(index);
						state <= addr_out;
					else
						sda_bit <= '0';
						state <= addr_ack;
					end if;

				when addr_ack =>
					index := index - 1;
					sda_bit <= bits(index);
					state <= data_out;

				when data_out =>
					if index /= 0 then
						index := index - 1;
						sda_bit <= bits(index);
						state <= data_out;
					else
						sda_bit <= '0';
						state <= data_ack;
					end if;

				when data_ack =>
					state <= stop;

				when stop =>
					ready <= '1';
					success <= not failure;
					state <= idle;

			end case;
		elsif falling_edge(sda_clk) then
			case state is

				when start =>
					failure := '0';
					scl_drive <= '1';

				when devi_ack =>
					if sda /= '0' then
						failure := '1';
					end if;

				when addr_ack =>
					if sda /= '0' then
						failure := '1';
					end if;

				when data_ack =>
					if sda /= '0' then
						failure := '1';
					end if;

				when stop =>
					scl_drive <= '0';

				when others =>
					null;

			end case;
		end if;
	end process;

	-- Bus control
	with state select sda_drive <=
		'0' when idle,
		'1' when start,
		'1' when devi_out,
		'0' when devi_ack,
		'1' when addr_out,
		'0' when addr_ack,
		'1' when data_out,
		'0' when data_ack,
		'1' when stop;

	-- Lines will float high and drive low
	scl <= 'Z' when scl_drive = '0' or scl_clk = '1' else '0';
	sda <= 'Z' when sda_drive = '0' or sda_bit = '1' else '0';

	-- Configure WM8731 audio CODEC
	process(scl_clk)
		variable count : natural := 0;
	begin
		if rising_edge(scl_clk) then
			if count /= 480 then
				count := count + 1;
			end if;
			case count is

				-- Reset
				when 40 =>
					valid <= '1';
					addr <= "0001111";
					data <= "000000000";

				-- Left line in
				when 80 =>
					valid <= '1';
					addr <= "0000000";
					data <= "000010111";

				-- Right line in
				when 120 =>
					valid <= '1';
					addr <= "0000001";
					data <= "000010111";

				-- Left line out
				when 160 =>
					valid <= '1';
					addr <= "0000010";
					data <= "001111001";

				-- Right line out
				when 200 =>
					valid <= '1';
					addr <= "0000011";
					data <= "001111001";

				-- Analogue path control
				when 240 =>
					valid <= '1';
					addr <= "0000100";
					data <= "000010010";

				-- Digital path control
				when 280 =>
					valid <= '1';
					addr <= "0000101";
					data <= "000000001";

				-- Power save mode
				when 320 =>
					valid <= '1';
					addr <= "0000110";
					data <= "001100010";

				-- Interface format
				when 360 =>
					valid <= '1';
					addr <= "0000111";
					data <= "011000010";

				-- Sampling control
				when 400 =>
					valid <= '1';
					addr <= "0001000";
					data <= "000000000";

				-- Set active
				when 440 =>
					valid <= '1';
					addr <= "0001001";
					data <= "000000001";

				when others =>
					valid <= '0';

			end case;
		end if;
	end process;

end architecture;
