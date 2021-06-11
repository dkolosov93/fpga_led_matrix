-- Author: Dimitrios Kolosov													-
-- 31/05/2021																		-
-- d.sotiropoulos@hotmail.com													-
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.my_defs.all;

entity led_matrix_controller is
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
end entity;


architecture rtl of led_matrix_controller is

---- LED matrix signals ----
signal matrix_state	: state := S1;										 		-- matrix state

signal row				: integer range 0 to 16		:= 0;		 		-- number of rows (16)
signal column			: integer range 0 to 32		:= 0;		 		-- number of columns (31)
signal newline 		: std_logic						:= '0';			-- is it new line or not?
signal matrix_frame	: integer range 0 to 1024	:= 0;		 		-- 8-bit resolution for pwm
signal address_a 		: integer range 0 to 1024	:= 0;		 -- ram address 1
signal address_b 		: integer range 0 to 1024	:= 0;		 -- ram address 2

begin

-- connect signals to 2-port RAM
rom_address_a <= std_logic_vector(to_unsigned(address_a,10));
rom_address_b <= std_logic_vector(to_unsigned(address_b,10));



-- STATE MACHINE
process(CLK_50MHZ, RESET)
variable delay	: integer range 0 to 50000 		 := 0;	 -- delay

begin

if RESET = '0' then
	address_a <= 0;
	address_b <= 0;
	matrix_state <= S0;
	R <= "00";
	G <= "00";
	B <= "00";
elsif CLK_50MHZ'event and CLK_50MHZ = '1' then	
	address_a <= (column + (row*32)) 		;
	address_b <= (512 + column + (row*32)) ;   -- address of ram2 start at 512 + / responsible for lower 32x16 part of matrix
									
if (CLK_25MHZ = '1') then
	
	case matrix_state is
	
	when S0 =>	-- shift data
	
					matrix_clk <= '1';	-- matrix clock 		
					
					------------------------------ RED -----------------------------------
					if (to_integer(unsigned(rom_data_a(23 downto 15))) > matrix_frame) then
						R(0) <= '1';
					else 
						R(0) <= '0';
					end if;
					
					if (to_integer(unsigned(rom_data_b(23 downto 15))) > matrix_frame) then
						R(1) <= '1';
					else 
						R(1) <= '0';
					end if;
					
					---------------------------- GREEN -----------------------------------
					if (to_integer(unsigned(rom_data_a(15 downto 8))) > matrix_frame) then
						G(0) <= '1';
					else 
						G(0) <= '0';
					end if;
					
					if (to_integer(unsigned(rom_data_b(15 downto 8))) > matrix_frame) then
						G(1) <= '1';
					else 
						G(1) <= '0';
					end if;
					
					---------------------------- BLUE ------------------------------------
					if (to_integer(unsigned(rom_data_a(7 downto 0))) > matrix_frame) then
						B(0) <= '1';
					else 
						B(0) <= '0';
					end if;
					
					if (to_integer(unsigned(rom_data_b(7 downto 0))) > matrix_frame) then
						B(1) <= '1';
					else 
						B(1) <= '0';
					end if;
					
					
					---------------------------- SHIFT DATA ------------------------------------
					if( column < 31) then  
						column <= column + 1;
					else	    
						column <= 0;     
						matrix_latch <= '1';
						matrix_oe_n  <= '1';
						matrix_row   <= std_logic_vector(to_unsigned(row,4));
						matrix_state <= S1;
					end if;
					
	when S1 =>	-- latch data
	
					matrix_latch <= '0';
					matrix_state <= S2;				
					
	when S2 =>	-- delay if new row is selected
					
					if (newline = '1') then			
						if	(delay < 5000) then
							delay := delay + 1;
						else
							matrix_oe_n <= '0';
							delay := 0;
							newline <='0';
							matrix_state <= S3;		
					   	end if;
					 else 
					 	matrix_oe_n <= '0';--------enable output
					 	matrix_state <= S3;
					 end if;
					 
	when S3 =>	-- PWM Generation
               if(matrix_frame < 255)then
				 		matrix_frame <= matrix_frame + 16;
				 	else
				 		newline <= '1';
						if (row < 15)then  -----
							row <= row + 1;
						else
							row <= 0;
						end if;
				    		matrix_frame <= 1;
				 	end if;
				 	matrix_state <= S0;

	when others => matrix_state <= S0;
	
	end case;

else
	matrix_clk <= '0';
end if;

end if;
end process;


end architecture;
