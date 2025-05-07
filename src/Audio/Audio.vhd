library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

library work;
use work.TdmaMinTypes.all;

entity Audio is
	generic (
		enable_adc : boolean := true
	);
	port (
		ref_clock     : in    std_logic;
		fpga_i2c_sclk : out   std_logic;
		fpga_i2c_sdat : inout std_logic;
		aud_adcdat    : in    std_logic;
		aud_adclrck   : inout std_logic;
		aud_bclk      : inout std_logic;
		aud_dacdat    : out   std_logic;
		aud_daclrck   : inout std_logic;
		aud_xck       : out   std_logic;

		clock         : in    std_logic;
		adc_empty     : out   std_logic;
		adc_get       : in    std_logic;
		adc_data      : out   std_logic_vector(16 downto 0);
		dac_full      : out   std_logic;
		dac_put       : in    std_logic;
		dac_data      : in    std_logic_vector(16 downto 0)
	);
end entity;

architecture rtl of Audio is
begin

	audio_clock : entity ip.AudioClock
	port map (
		audio_clk_clk      => aud_xck,
		ref_clk_clk        => ref_clock,
		ref_reset_reset    => open,
		reset_source_reset => open
	);

	audio_control : entity work.AudioControl
	port map (
		clock => ref_clock,
		scl   => fpga_i2c_sclk,
		sda   => fpga_i2c_sdat
	);

	audio_tones : if not enable_adc generate
		audio_tones : entity work.AudioTones
		port map (
			bclk   => aud_bclk,
			adcdat => aud_adcdat,
			adclrc => aud_adclrck,

			clock  => clock,
			empty  => adc_empty,
			get    => adc_get,
			data   => adc_data
		);
	end generate;

	audio_adc : if enable_adc generate
		audio_adc : entity work.AudioIn
		port map (
			bclk   => aud_bclk,
			adcdat => aud_adcdat,
			adclrc => aud_adclrck,

			clock  => clock,
			empty  => adc_empty,
			get    => adc_get,
			data   => adc_data
		);
	end generate;

	audio_dac : entity work.AudioOut
	port map (
		bclk   => aud_bclk,
		dacdat => aud_dacdat,
		daclrc => aud_daclrck,

		clock  => clock,
		full   => dac_full,
		put    => dac_put,
		data   => dac_data
	);

end architecture;
