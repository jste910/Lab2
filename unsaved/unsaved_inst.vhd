	component unsaved is
		port (
			clk_clk                                 : in  std_logic                     := 'X';             -- clk
			recv_address_external_connection_export : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			recv_data_external_connection_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			send_address_external_connection_export : out std_logic_vector(7 downto 0);                     -- export
			send_data_external_connection_export    : out std_logic_vector(31 downto 0)                     -- export
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                              clk.clk
			recv_address_external_connection_export => CONNECTED_TO_recv_address_external_connection_export, -- recv_address_external_connection.export
			recv_data_external_connection_export    => CONNECTED_TO_recv_data_external_connection_export,    --    recv_data_external_connection.export
			send_address_external_connection_export => CONNECTED_TO_send_address_external_connection_export, -- send_address_external_connection.export
			send_data_external_connection_export    => CONNECTED_TO_send_data_external_connection_export     --    send_data_external_connection.export
		);

