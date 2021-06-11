-- my defs
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package my_defs is

type state is (S0, S1, S2, S3);

-- component declaration

--	PLL
-- 12MHZ in
-- 25MHZ out
component pll
PORT(	areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC ;
		c1				: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 

);
end component;

-- 2-port ROM
-- 1024 words
-- 24bit out
-- bypassable output register
component rom
PORT(	address_a	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		address_b	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q_a			: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
		q_b			: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
end component;


component led_matrix_controller
port(		CLK_25MHZ 	: in std_logic;
			CLK_50MHZ 	: in std_logic;
			RESET 		: in std_logic;
			
			-- ROM input
			rom_address_a 	: out STD_LOGIC_VECTOR (9 DOWNTO 0);		-- upper address of ROM
			rom_address_b 	: out STD_LOGIC_VECTOR (9 DOWNTO 0);		-- lower address of ROM
			rom_data_a 		: in STD_LOGIC_VECTOR (23 DOWNTO 0);		-- outA: upper output of ROM
			rom_data_b 		: in STD_LOGIC_VECTOR (23 DOWNTO 0);		-- outb: lower output of ROM
						
			-- 32x32 MATRIX LED connections
			matrix_row 	 : out std_logic_vector(3 downto 0) := "0000"; 	-- A, B, C, D
			matrix_latch : out std_logic 							:= '0';		-- latch signal
			matrix_clk	 : out std_logic 							:= '0';		-- clock for LED matrix
			matrix_oe_n  : out std_logic 							:= '0';		-- Output Enable signal
			R	 			 : out std_logic_vector(1 downto 0) := "00";  	-- upper/lower red
			G	 			 : out std_logic_vector(1 downto 0) := "00";  	-- upper/lower green
			B	 			 : out std_logic_vector(1 downto 0) := "00"   	-- upper/lower blue
);
end component;



end package;