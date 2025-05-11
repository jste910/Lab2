
module unsaved (
	clk_clk,
	recv_address_external_connection_export,
	recv_data_external_connection_export,
	send_address_external_connection_export,
	send_data_external_connection_export);	

	input		clk_clk;
	input	[7:0]	recv_address_external_connection_export;
	input	[31:0]	recv_data_external_connection_export;
	output	[7:0]	send_address_external_connection_export;
	output	[31:0]	send_data_external_connection_export;
endmodule
