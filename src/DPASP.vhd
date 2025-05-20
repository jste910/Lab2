LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.TdmaMinTypes.ALL;

ENTITY DpASP IS
    PORT (
        clock : IN STD_LOGIC;
        send : OUT tdma_min_port;
        recv : IN tdma_min_port
    );
END ENTITY;

ARCHITECTURE sim OF DpASP IS

    SIGNAL channel_0 : signed(15 DOWNTO 0);
    SIGNAL channel_1 : signed(15 DOWNTO 0);
    TYPE sampleArray IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL samples_0 : sampleArray := (OTHERS => (OTHERS => '0')); -- array to store the last 4 samples
    SIGNAL idx_0 : INTEGER := 0; -- goes from 0 to 3 and loops
    SIGNAL sum_0 : INTEGER := 0;
    SIGNAL tmp_0 : INTEGER := 0;
    SIGNAL samples_1 : sampleArray := (OTHERS => (OTHERS => '0')); -- array to store the last 4 samples
    SIGNAL idx_1 : INTEGER := 0; -- goes from 0 to 3 and loops
    SIGNAL sum_1 : INTEGER := 0;
    SIGNAL tmp_1 : INTEGER := 0;
    SIGNAL dest_0 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dest_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL next_0 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL next_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mode_0 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mode_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

BEGIN

    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF (recv.data(31 DOWNTO 28) = "1000") THEN -- check if the incoming is audio data
                -- ledr <= recv.data(31 DOWNTO 28);

                IF (recv.data(16) = '0') THEN -- check if the incoming data is from channel 0
                    -- we are happy to proceed
                    sum_0 <= sum_0 - to_integer(signed(samples_0(idx_0))) + to_integer(signed(recv.data(15 DOWNTO 0))); -- add the new data to the sum
                    samples_0(idx_0) <= recv.data(15 DOWNTO 0); -- store the sample in the array
                    -- calculate the average
                    IF ((sum_0/2) > 4096) THEN
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(4096, 16)); -- limit the average to 4096
                        -- channel_0 <= to_signed(4096);
                        tmp_0 <= 4096;
                    ELSIF ((sum_0/2) < -4096) THEN
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(sum_0/2, 16)); -- limit the average to -4096
                        -- channel_0 <= signed(-4096);
                        tmp_0 <= - 4096;
                    ELSE
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(-4096, 16)); -- send the average
                        -- channel_0 <= signed(sum_0 / 2);
                        tmp_0 <= sum_0 / 2;
                    END IF;
                    -- send.data(31 DOWNTO 16) <= STD_LOGIC_VECTOR(to_unsigned(8192, 16)); -- set the other bits to 0
                    -- send.data(16) <= recv.data(16); -- set the channel bit to the same as the incoming data
                    -- other misc operations
                    idx_0 <= (idx_0 + 1) MOD 4; -- increment the index
                    -- send.addr <= "0000" & next_0;
                ELSE -- right
                    -- we are happy to proceed
                    sum_1 <= sum_1 - to_integer(signed(samples_1(idx_1))) + to_integer(signed(recv.data(15 DOWNTO 0))); -- add the new data to the sum
                    samples_1(idx_1) <= recv.data(15 DOWNTO 0); -- store the sample in the array
                    -- calculate the average
                    IF ((sum_1/2) > 4096) THEN
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(4096, 16)); -- limit the average to 4096
                        -- channel_1 <= signed(4096);
                        tmp_1 <= 4096;
                    ELSIF ((sum_1/2) < -4096) THEN
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(sum_1/2, 16)); -- limit the average to -4096
                        -- channel_1 <= signed(-4096);
                        tmp_1 <= - 4096;
                    ELSE
                        send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(-4096, 16)); -- send the average
                        -- channel_1 <= signed(sum_1 / 2);
                        tmp_1 <= sum_1 / 2;
                    END IF;
                    -- send.data(31 DOWNTO 16) <= STD_LOGIC_VECTOR(to_unsigned(0, 16)); -- set the other bits to 0
                    -- send.data(16) <= recv.data(16); -- set the channel bit to the same as the incoming data
                    -- other misc operations
                    idx_1 <= (idx_1 + 1) MOD 4; -- increment the index
                    -- send.addr <= STD_LOGIC_VECTOR(to_unsigned(next_1, tdma_min_addr'length));
                    -- send.addr <= "0000" & next_1;

                END IF;


                -- we are happy to proceed
                -- sum_0 <= sum_0 - to_integer(signed(samples_0(idx_0))) + to_integer(signed(recv.data(15 DOWNTO 0))); -- add the new data to the sum
                -- samples_0(idx_0) <= recv.data(15 DOWNTO 0); -- store the sample in the array
                -- calculate the average
                -- IF ((sum_0/2) > 4096) THEN
                --     send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(2048, 16)); -- limit the average to 4096
                --     -- channel_0 <= to_signed(4096);
                --     tmp_0 <= 4096;
                -- ELSIF ((sum_0/2) <- 4096) THEN
                --     send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(2048, 16)); -- limit the average to -4096
                --     -- channel_0 <= signed(-4096);
                --     tmp_0 <= - 4096;
                -- ELSE
                --     send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(2048, 16)); -- send the average
                --     -- channel_0 <= signed(sum_0 / 2);
                --     tmp_0 <= sum_0 / 2;
                -- END IF;

                -- send.data <= recv.data;
                -- send.data <= "1011" & "1001" & "1011" & "0011" & "1111" & "1111" & "1111" & "1111";
                -- send.data <= "1000" & "1011" & "1010" & "0011" & "1111" & "1111" & "1111" & "1111";
                -- Works send.data <= "1011" & "0000" & "1011" & "1011" & "1111" & "1111" & "1111" & "1111";
                -- send.data <= "1000" & "0011" & "0011" & "1011" & "1111" & "1111" & "1111" & "1111";
                -- Fails send.data <= "1000" & "1011" & "1011" & "1011" & "1111" & "1111" & "1111" & "1111";
                -- Fails send.data <= "1000" & "0000" & "1011" & "0001" & "1111" & "1111" & "1111" & "1111";

                -- send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(4096, 16)); -- limit the average to 4096
                -- -- send.data(31 DOWNTO 16) <=recv.data(31 DOWNTO 16); -- set the other bits to 0
                -- send.data(31 DOWNTO 16) <= "1011111111111111" and recv.data(31 DOWNTO 16); -- set the other bits to 0
                -- other misc operations
                idx_0 <= (idx_0 + 1) MOD 4; -- increment the index
                -- send.addr <= "0000" & next_0;
                -- send.addr <= "00001011";
                send.addr <= x"01";
                -- send.data <= recv.data; -- send the data to the next module
                send.data(31 DOWNTO 16) <= recv.data(31 DOWNTO 16); -- set the other bits to 0
                -- send.data(15 DOWNTO 0) <= recv.data(15 DOWNTO 0); -- send the average
                -- send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(4096, 16)); -- send the average
                -- send.data(15 DOWNTO 0) <= samples_0(idx_0);
                -- send.data(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(4096, 16)); -- send the average
                -- send.data <= recv.data(31 DOWNTO 16) & STD_LOGIC_VECTOR(to_signed(4096, 16)); -- send the data to the next module
                -- ledr <= recv.data(19 DOWNTO 16);
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;