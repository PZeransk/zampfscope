----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2023 22:58:47
-- Design Name: 
-- Module Name: vga_controller - Behavioral
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

entity vga_controller is
  GENERIC(
  	C_pixel_bits	: INTEGER := 8;
    C_h_pulse  		: INTEGER := 96;    --horiztonal sync pulse width in pixels
    C_h_bp     		: INTEGER := 48;    --horiztonal back porch width in pixels
    C_h_pixels 		: INTEGER := 640;   --horiztonal display width in pixels
    C_h_fp     		: INTEGER := 16;    --horiztonal front porch width in pixels
    C_h_total  		: INTEGER := 800;
    C_h_pol    		: STD_LOGIC := '0';  --horizontal sync pulse polarity (1 = positive, 0 = negative)
    C_v_pulse  		: INTEGER := 2;      --vertical sync pulse width in rows
    C_v_bp     		: INTEGER := 33;     --vertical back porch width in rows
    C_v_pixels 		: INTEGER := 480;   --vertical display width in rows
    C_v_fp     		: INTEGER := 10;      --vertical front porch width in rows
    C_v_total  		: INTEGER := 525;
    C_v_pol    		: STD_LOGIC := '1'); --vertical sync pulse polarity (1 = positive, 0 = negative)
  PORT(
    i_pixel_clk : IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    i_reset_n   : IN   STD_LOGIC;  --active low asycnchronous reset
    i_adc_data0	: IN   STD_LOGIC_VECTOR(7 downto 0);
    i_adc_data1 : IN   STD_LOGIC_VECTOR(15 downto 0);
    o_h_sync    : OUT  STD_LOGIC;  --horiztonal sync pulse
    o_v_sync    : OUT  STD_LOGIC;  --vertical sync pulse
    o_disp_ena  : OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    o_r_sig		: OUT  STD_LOGIC_VECTOR(2 downto 0);
    o_b_sig		: OUT  STD_LOGIC_VECTOR(2 downto 0);
    o_g_sig		: OUT  STD_LOGIC_VECTOR(2 downto 0);
    o_data_clk	: OUT  STD_LOGIC;
    o_data_ack	: OUT  std_logic;
    o_new_line	: OUT  std_logic
  	);
end vga_controller;

architecture Behavioral of vga_controller is

signal h_pulses_cnt : integer range 0 to C_h_total := 0; -- horizostal pulses cnt
signal v_pulses_cnt : integer range 0 to C_v_total := 0; -- vertical pulses cnt
signal frames_cnt	: integer range 0 to 10 	   := 0;
signal temp_data	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal int_data	  	: integer range 0 to C_h_total := 0;
begin





process(i_pixel_clk, i_reset_n)
begin
o_data_clk <= NOT i_pixel_clk;
if(i_reset_n = '1') then
	h_pulses_cnt <= 0;
	v_pulses_cnt <= 0;
	o_h_sync <= '1';
	o_v_sync <= '1';

elsif(rising_edge(i_pixel_clk)) then

	if(h_pulses_cnt = C_h_total - 1) then
		h_pulses_cnt <= 0;
		v_pulses_cnt <= v_pulses_cnt + 1;
	else
		h_pulses_cnt <= h_pulses_cnt + 1;
	end if;


	if(v_pulses_cnt = C_v_total - 1) then
		v_pulses_cnt <= 0;
	end if;

	if(v_pulses_cnt < C_v_pixels) then
	o_v_sync <= '1';
		if(h_pulses_cnt < C_h_pixels) then 
		-- visible pixels 
		-- should be some data not just red

			o_data_ack <= '1';
			o_new_line <= '1';
			if(v_pulses_cnt = to_integer(unsigned(i_adc_data0)) + 40) then
				o_r_sig <= "111";
				o_b_sig <= "000";
				o_g_sig <= "000";
			else
				o_r_sig <= "000";
				o_b_sig <= "000";
				o_g_sig <= "000";
			end if;
		
		o_h_sync <= '1';
		elsif(h_pulses_cnt >= C_h_pixels AND h_pulses_cnt < C_h_pixels + C_h_fp) then 
		-- star blanking
		o_data_ack <= '0';
		o_new_line <= '0';
		o_h_sync <= '1';
		o_r_sig <= "000";
		o_b_sig <= "000";
		o_g_sig <= "000";	
		elsif(h_pulses_cnt >= C_h_pixels + C_h_fp AND h_pulses_cnt < C_h_pixels + C_h_fp + C_h_pulse) then
		-- start Hsync pulse
		o_h_sync <= '0';
	
	
		elsif(h_pulses_cnt >= C_h_total - C_h_bp) then
		-- end Hsync pulse
		o_h_sync <= '1';
		end if;

	elsif(v_pulses_cnt >= C_v_pixels AND v_pulses_cnt < C_v_pixels + C_v_fp) then
		o_v_sync <= '1';
		o_r_sig <= "000";
		o_b_sig <= "000";
		o_g_sig <= "000";	
	elsif(v_pulses_cnt >= C_v_pixels + C_v_fp AND v_pulses_cnt < C_v_pixels + C_v_fp + C_v_pulse) then
	o_v_sync <= '0';
	elsif(v_pulses_cnt >= C_v_total - C_v_bp) then
	o_v_sync <= '1';
	end if;
	
end if;


end process;


end Behavioral;
