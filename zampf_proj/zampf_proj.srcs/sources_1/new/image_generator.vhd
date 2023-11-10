----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2023 18:40:10
-- Design Name: 
-- Module Name: image_generator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image_generator is
Generic(
	C_data_length	:	integer := 16;
	C_resolution	:	integer	:= 8;
	C_pixel_widht	: 	integer := 340;
	C_pixel_height	:	integer := 256;
	C_image_h		:	integer	:= 480;
	C_image_v		:	integer := 640
	);
Port ( 
	i_clk			:	in 	std_logic;
	i_cs 			:	in 	std_logic;
	i_reset_n		:	in 	std_logic;
	--i_trigger_n 	:	in 	std_logic;
	--i_h_sync		: 	in 	std_logic;
	i_v_sync		:	in 	std_logic;
	i_spi_data0		:	in 	std_logic_vector(C_data_length - 1 downto 0);
	i_spi_data1		:	in 	std_logic_vector(C_data_length - 1 downto 0)
	--o_end_meas		:	out	std_logic;
	--o_image_data	:	out	std_logic
	);
end image_generator;

architecture Behavioral of image_generator is
type T_IMAGE 		is array (0 to C_pixel_widht - 1) of integer;
type T_IMAGE_BINARY	is array (0 to C_pixel_height - 1) of std_logic_vector(C_pixel_widht - 1 downto 0);

signal measurment_status	: std_logic;
signal r_spi_data : std_logic_vector(C_resolution - 1 downto 0) := (others => '0');
signal pixel_height	: integer range 0 to C_pixel_height := 0;
signal pixel_cnt	: integer range 0 to C_pixel_widht := 0;
signal MY_IMAGE		: T_IMAGE;

begin
gen_image : process(i_clk, i_reset_n, i_cs) is
begin
--this should generate integer vector for vga controller
if(i_reset_n = '1') then

elsif(falling_edge(i_cs)) then

		r_spi_data <= i_spi_data0(i_spi_data0'low + 11 downto i_spi_data0'low + 4);
		pixel_height <= to_integer(unsigned(r_spi_data));
end if;	


end process; -- gen_image

-- this should send integers to vga controller after every Hsync pulse
send_image : process(i_cs, i_v_sync) is
begin

	if (i_v_sync = '0') then
		pixel_cnt <= 0;
	elsif (rising_edge(i_cs)) then
		if (pixel_cnt < C_pixel_widht - 1) then
		MY_IMAGE(pixel_cnt) <= pixel_height;
		pixel_cnt <= pixel_cnt + 1;
		end if;
	end if;
end process; -- send_image

-- this should reset counter of pulses after every Vsync
reset_counter : process(i_v_sync) is
begin
	if (falling_edge(i_v_sync)) then
	--	pixel_cnt <= 0;
	end if;
end process; -- reset_counter


end Behavioral;
