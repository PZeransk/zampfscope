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
	C_pixel_widht	: 	integer := 640;
	C_pixel_height	:	integer := 256;
	C_image_h		:	integer	:= 640;
	C_image_v		:	integer := 640
	);
Port ( 
	i_clk			:	in 	std_logic;
	i_cs 			:	in 	std_logic;
	i_reset_n		:	in 	std_logic;
	i_trigger_n 	:	in 	std_logic;

	i_x_pixel 		: 	in  integer;
	--i_h_sync		: 	in 	std_logic;
	--i_v_sync		:	in 	std_logic;
	i_spi_data0		:	in 	std_logic_vector(C_data_length - 1 downto 0);
	i_spi_data1		:	in 	std_logic_vector(C_data_length - 1 downto 0);
	o_image_data0	:	out std_logic_vector(C_resolution - 1 downto 0);
	o_image_data1	:	out std_logic_vector(C_resolution - 1 downto 0);
	o_adc_enable 	: 	out std_logic
	--o_end_meas		:	out	std_logic;
	--o_image_data	:	out	std_logic
	);
end image_generator;

architecture Behavioral of image_generator is
type T_IMAGE 		is array (0 to C_pixel_widht - 1) of std_logic_vector(C_resolution - 1 downto 0);
TYPE T_states		is (IDLE,
						MEASURE,
						SEND
						);
--type T_IMAGE_BINARY	is array (0 to C_pixel_widht - 1) of std_logic_vector(C_pixel_height - 1 downto 0);

signal measurment_status	: std_logic;
signal r_spi_data0 			: std_logic_vector(C_resolution - 1 downto 0) := (others => '0');
signal r_spi_data1 			: std_logic_vector(C_resolution - 1 downto 0) := (others => '0');
signal pixel_height			: integer range 0 to C_pixel_height := 0;
signal pixel_cnt			: integer range 0 to C_pixel_widht := 0;
signal data_send_cnt		: integer range 0 to C_pixel_widht := 0;
--signal v_data_reg	: std_logic_vector(C_pixel_height - 1 downto 0) := (others => '0');
signal MY_IMAGE_0		: T_IMAGE;
signal MY_IMAGE_1		: T_IMAGE;
signal image_state : T_states;
--signal MY_BIN_IMG	: T_IMAGE_BINARY := (others => (others => '0'));

begin





gen_image : process(i_clk, i_reset_n, i_cs, i_trigger_n) is
begin
--this should generate integer vector for vga controller
if(i_reset_n = '1') then

pixel_cnt <= 0;

else 
case image_state is
	
	when IDLE =>
		if(i_trigger_n = '1') then
		pixel_cnt <= 0;
		data_send_cnt <= 0;
		o_image_data0 <= (others => 'Z'); -- maybe as 0 later
		o_adc_enable <= '1';
		
		else
		image_state <= MEASURE;
		end if;
	when MEASURE =>

		if(i_trigger_n = '0') then
		o_adc_enable <= '1';
			if(falling_edge(i_cs)) then
			
					if (pixel_cnt < C_pixel_widht) then
	
					r_spi_data0 <= i_spi_data0(i_spi_data0'low + 11 downto i_spi_data0'low + 4);
					r_spi_data1 <= i_spi_data1(i_spi_data1'low + 11 downto i_spi_data1'low + 4);
					MY_IMAGE_0(pixel_cnt) <= r_spi_data0;
					MY_IMAGE_1(pixel_cnt) <= r_spi_data1;
					--pixel_height <= to_integer(unsigned(r_spi_data0));
	
					pixel_cnt <= pixel_cnt + 1;
	
					--v_data_reg(pixel_height) <= '1';
					--MY_BIN_IMG(pixel_cnt) <= v_data_reg;
					else
					image_state <= SEND;
	
					o_adc_enable <= '0';
					end if;
			
			end if;
		else
		image_state <= IDLE;
		end if;
	when SEND =>
		if(i_trigger_n = '0') then
		if(rising_edge(i_clk)) then
			
				o_image_data0 <= MY_IMAGE_0(i_x_pixel);
				o_image_data1 <= MY_IMAGE_1(i_x_pixel);
		end if;
		else
		image_state <= IDLE;
		end if;

end case;
end if;	




end process; -- gen_image

-- this should send integers to vga controller after every Hsync pulse
--send_image : process(i_clk, measurment_status) is
--begin
--	
--if (rising_edge(i_clk)) then
--	if (measurment_status = '0') then
--	
--
--		if(data_send_cnt = C_pixel_widht -1) then
--			data_send_cnt <= 0;
--		else
--			o_image_data0 <= MY_IMAGE_0(data_send_cnt);
--			data_send_cnt <= data_send_cnt + 1;
--		end if;
--	--MY_IMAGE_0(pixel_cnt) <= pixel_height;
--	--pixel_cnt <= pixel_cnt + 1;
--	--v_data_reg <= (others => '0');
--	end if;
--end if;
--end process; -- send_image

-- this should reset counter of pulses after every Vsync
--reset_counter : process(i_v_sync) is
--begin
--	if (falling_edge(i_v_sync)) then
--	--	pixel_cnt <= 0;
--	end if;
--end process; -- reset_counter


end Behavioral;
