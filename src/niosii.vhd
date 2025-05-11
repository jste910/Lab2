LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;
USE work.TdmaMinTypes.ALL;

ENTITY niosii IS
    PORT (
        clk : IN STD_LOGIC; -- clk
        send : IN tdma_min_port; -- export
        recv : OUT tdma_min_port -- import
    );
END ENTITY niosii;

ARCHITECTURE rtl OF niosii IS
    -- component unsaved is
    --     port (
    --         clk_clk                                 : in  std_logic                     := 'X';             -- clk
    --         reset_reset_n                           : in  std_logic                     := 'X';             -- reset_n
    --         send_address_external_connection_export : out std_logic_vector(7 downto 0);                     -- export
    --         recv_address_external_connection_export : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
    --         send_data_external_connection_export    : out std_logic_vector(31 downto 0);                    -- export
    --         recv_data_external_connection_export    : in  std_logic_vector(31 downto 0) := (others => 'X')  -- export
    --     );
    -- end component unsaved;

BEGIN
    -- u0 : component unsaved
    -- port map (
    --     clk_clk                                 => clk,                                 --                              clk.clk
    --     reset_reset_n                           => '0',                           --                            reset.reset_n
    --     send_address_external_connection_export => send.addr, -- send_address_external_connection.export
    --     recv_address_external_connection_export => recv.addr, -- recv_address_external_connection.export
    --     send_data_external_connection_export    => send.data,    --    send_data_external_connection.export
    --     recv_data_external_connection_export    => recv.data     --    recv_data_external_connection.export
    -- );
    PROCESS (clk)
    BEGIN
        recv.addr <= send.addr;
        recv.data <= send.data;
    END PROCESS;
END ARCHITECTURE rtl;