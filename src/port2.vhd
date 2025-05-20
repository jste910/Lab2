LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY port2 IS
	PORT (
		clk : IN STD_LOGIC; -- clk
		reset : IN STD_LOGIC -- reset_n
	);
END ENTITY port2;

ARCHITECTURE Behavioral OF port2 IS

	component NiosAttempt is
		port (
			clk_clk       : in std_logic := 'X'; -- clk
			reset_reset_n : in std_logic := 'X'  -- reset_n
		);
	end component NiosAttempt;
BEGIN
	u0 : component NiosAttempt
		port map (
			clk_clk       => clk,       --   clk.clk
			reset_reset_n => reset  -- reset.reset_n
		);


	END ARCHITECTURE Behavioral;