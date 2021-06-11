-- Author: Dimitrios Kolosov													-
-- 31/05/2021																		-
-- d.sotiropoulos@hotmail.com													-
-------------------------------------------------------------------

-------------------------------------------------------------------
-- PIN OUT MAX1000																-
--																						-
-- SIGNAL		IO			Description											-
-------------------------------------------------------------------
-- CLK12M		H6			12MHz Clock											-
-- LED1		 	A8			PLL Locked signal									-
-- LED2		 	A9			Heartbeat(based on clock div					-
-- LED3			A11																-
-- LED4			A10																-
-- LED5			B10																-
-- LED6			C9																	-
-- LED7			C10																-
-- LED8			D8																	-
-- RESET			E7			 Reset												-
-- BTN			E6																	-
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-- Signals		Matrix		IO		||	Signals		Matrix		IO		-	
-------------------------------------------------------------------
--	R0				AIN5 			F1		||	G0			 	D10			K12	-
--	B0				AIN6 			E4		|| GND		 	GND			GND	-
--	R1				D0   			H8		|| G1			 	D9				K11	-
--	B1				D1   			K10	|| GND		 	GND			GND	-
--	A				D2 			H5		|| B			 	D8				J13	-
--	C				D3 			H4		|| D			 	D7				J12	-
-- CLK			D4 			J1		|| LAT		 	D6				L12	-
--	OE				D5 			J2		|| GND		 	GND			GND	-
-------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.my_defs.all;

entity top is
generic( main_CLK						: integer := 12_000_000	-- main input clock (HZ)
);
port(		-- general
			CLK12M 	: in 	std_logic;
			LED		: out std_logic_vector(7 downto 0) := (others => '0');
			RESET 	: in 	std_logic;
			BTN 		: in 	std_logic;
			
			-- 32x32 MATRIX LED connections
			matrix_row 	 : out std_logic_vector(3 downto 0) := "0000"; 	-- A, B, C, D
			matrix_latch : out std_logic 							:= '0';		-- latch signal
			matrix_clk	 : out std_logic 							:= '0';		-- clock for LED matrix
			matrix_oe_n  : out std_logic 							:= '0';		-- Output Enable signal
			R	 			 : out std_logic_vector(1 downto 0) := "00";  	-- upper/lower red
			G	 			 : out std_logic_vector(1 downto 0) := "00";  	-- upper/lower green
			B	 			 : out std_logic_vector(1 downto 0) := "00"   	-- upper/lower blue
);
end entity;




architecture rtl of top is

---- LED matrix signals ----
signal pll_25mhz     : std_logic 						 := '0';		 -- clock enable from clock_div component
signal pll_50mhz     : std_logic 						 := '0';		 -- clock enable from clock_div component

signal row				: integer range 0 to 16 		 := 0;		 -- number of rows (16)
signal column			: integer range 0 to 32 		 := 0;		 -- number of columns (31)
signal newline 		: std_logic 						 := '0';		 -- is it new line or not?
signal matrix_frame	: integer range 0 to 1024		 := 0;		 -- 8-bit resolution for pwm
signal address_a 		: integer range 0 to 1024 		 := 0;		 -- ram address 1
signal address_b 		: integer range 0 to 1024 		 := 0;		 -- ram address 2
signal matrix_state	: state := S1;										 -- matrix state

---- internal 2-port ROM signals ----
signal rom_address_a		: STD_LOGIC_VECTOR (9 DOWNTO 0);		-- upper address of ROM
signal rom_address_b		: STD_LOGIC_VECTOR (9 DOWNTO 0);		-- lower address of ROM
signal rom_q_a				: STD_LOGIC_VECTOR (23 DOWNTO 0);	-- outA: upper output of ROM
signal rom_q_b				: STD_LOGIC_VECTOR (23 DOWNTO 0);	-- outB: lower output of ROM

begin

-- component instantiation								
c0 : pll  						port map(not RESET, CLK12M, pll_25mhz, pll_50mhz, LED(0));

c1 : rom  						port map(rom_address_a, rom_address_b,  pll_25mhz, rom_q_a, rom_q_b);

c2 : led_matrix_controller port map( 		CLK_25MHZ 		=> pll_25mhz,
														CLK_50MHZ 		=> pll_50mhz,
														RESET 			=> RESET,
														rom_address_a 	=> rom_address_a,
														rom_address_b 	=> rom_address_b,
														rom_data_a 		=> rom_q_a,
														rom_data_b 		=> rom_q_b,
														matrix_row 	 	=> matrix_row,
														matrix_latch 	=> matrix_latch,
														matrix_clk	 	=> matrix_clk,
														matrix_oe_n  	=> matrix_oe_n,
														R	 				=> R,
														G	 			 	=> G,
														B	 			 	=> B						);
								
			


end architecture;
