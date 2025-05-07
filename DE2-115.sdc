create_clock -period 20.000ns [get_ports CLOCK_50]
create_clock -period 20.000ns [get_ports CLOCK2_50]
create_clock -period 20.000ns [get_ports CLOCK3_50]

create_clock -period "3.072 MHz" -name clk_audbck [get_ports AUD_BCLK]
create_clock -period "12.288 MHz" -name clk_audxck [get_ports AUD_XCK]

derive_pll_clocks
derive_clock_uncertainty
