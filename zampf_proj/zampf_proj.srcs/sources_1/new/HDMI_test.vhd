----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2023 23:04:16
-- Design Name: 
-- Module Name: HDMI_test - Behavioral
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

-- HARD CODED FOR 640x480 !! who would need more here?
entity HDMI_test is
Generic (
    frame_width     : integer := 800; -- it all starts like
    frame_height    : integer := 525; -- in vga controller
    img_width       : integer := 640;
    img_height      : integer := 480;
    hsync_start     : integer := 16;
    hsync_size      : integer := 96;
    vsync_start     : integer := 10;
    vsync_size      : integer := 2
);
Port ( 
    i_pxl_clk : in std_logic;
    i_reset_n : in std_logic;
    -- i_rgb_pixel : std_logic_vector (23 downto 0);
    o_r_pixel : out std_logic_vector(9 downto 0);
    o_g_pixel : out std_logic_vector(9 downto 0);
    o_b_pixel : out std_logic_vector(9 downto 0);
    o_tmds_clk: out std_logic
);
end HDMI_test;

architecture Behavioral of HDMI_test is
component clock_divider is
	Generic(
	C_cnt_div	:	  integer
	);
 	Port (
 	i_clk 		: in  std_logic;
 	o_clk		: out std_logic;
 	i_reset_n   : in std_logic
  	);
end component;


signal clk_pixel_x5 : std_logic;
signal Xvis : unsigned; -- range(0, img_width) -- variables that shows which 
signal Yvis : unsigned; -- range(0,img_height) -- pixel of screen is printed

begin
    clk_div_internal : clock_divider
    generic map (
        C_cnt_div => 5
    )
    port map (
        i_reset_n => i_reset_n,
        i_clk => i_pxl_clk,
        o_clk => clk_pixel_x5
    )
    
    process(i_pxl_clk, i_reset_n)
    begin
        if (i_reset_n = '0') then
            Xvis <= (others => '0');
            Yvis <= (others => '0');
        elsif(rising_edge(i_pxl_clk)) then
            
        end if;
    end process;
end Behavioral;
