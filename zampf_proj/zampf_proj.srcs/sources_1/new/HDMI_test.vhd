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
use work.all;
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
  i_pxl_clk   : in std_logic;
  i_reset_n   : in std_logic;
  o_tmds_all  : out std_logic_vector(7 downto 0); -- (r, r, g, g, b, b, clk, clk)

  i_rgb_pixel : in std_logic_vector(23 downto 0);
  o_curr_x    : out integer range 0 to img_width;
  o_curr_y    : out integer range 0 to img_height
  );
end HDMI_test;

architecture Behavioral of HDMI_test is
-- component clock_divider is
--   GENERIC (
--   C_cnt_div	:	  integer
--   );
--    PORT (
--    i_clk 		: in  std_logic;
--    o_clk		: out std_logic;
--    i_reset_n   : in std_logic
--     );
-- end component;

-- component TMDS_encoder is
--   Generic (
--     DATA_LEN  : integer;
--     BUS_LEN   : integer
--   );
--   Port(
--     i_clk       : in std_logic;
--     i_shift_clk : in std_logic;
--     i_data      : in std_logic_vector(DATA_LEN downto 0);
--     o_bit       : out std_logic;
--     o_n_bit     : out std_logic
--   );
-- end component;

signal clk_pixel_x5 : std_logic;
signal x_img        : integer range 0 to img_width; -- range(0, img_width) -- variables that shows which
signal y_img        : integer range 0 to img_height; -- range(0,img_height) -- pixel of screen is printed
signal x_total      : integer range 0 to frame_width;
signal y_total      : integer range 0 to frame_height;
signal h_sync       : std_logic;
signal v_sync       : std_logic;
signal r_pixel    : std_logic_vector(9 downto 0);
signal g_pixel    : std_logic_vector(9 downto 0);
signal b_pixel    : std_logic_vector(9 downto 0);
signal TMDS_buff  : std_logic_vector(7 downto 0);
signal TDMS_ena   : std_logic;
begin
  clk_div_internal : ENTITY work.clock_divider
  generic map (
    C_cnt_div => 5
  )
  port map (
    i_reset_n => i_reset_n,
    i_clk => i_pxl_clk,
    o_clk => clk_pixel_x5
  );

  TMDS_red : ENTITY work.TMDS_encoder
  generic map(
    DATA_LEN    => 10,
    BUS_LEN     => 10)
  port map(
  i_clk         => clk_pixel_x5,
  i_shift_clk   => i_pxl_clk,
  i_data        => r_pixel,
  o_bit         => TMDS_buff(7),
  o_n_bit       => TMDS_buff(6)
  );

  TMDS_green : ENTITY work.TMDS_encoder
  generic map(
    DATA_LEN    => 10,
    BUS_LEN     => 10)
  port map(
  i_clk         => clk_pixel_x5,
  i_shift_clk   => i_pxl_clk,
  i_data        => g_pixel,
  o_bit         => TMDS_buff(5),
  o_n_bit       => TMDS_buff(4)
  );

  TMDS_blue : ENTITY work.TMDS_encoder
  generic map(
    DATA_LEN    => 10,
    BUS_LEN     => 10)
  port map(
  i_clk         => clk_pixel_x5,
  i_shift_clk   => i_pxl_clk,
  i_data        => b_pixel,
  o_bit         => TMDS_buff(3),
  o_n_bit       => TMDS_buff(2)
  );

  TMDS_buff(1) <= clk_pixel_x5;
  TMDS_buff(0) <= not clk_pixel_x5;
  o_tmds_all <= TMDS_buff;

  process(clk_pixel_x5, i_reset_n)
  begin
    if (i_reset_n = '0') then
      x_img <= 0;
      y_img <= 0;
      x_total <= 0;
      y_total <= 0;
    elsif(rising_edge(clk_pixel_x5)) then
      --(y_total, x_total) <= (0, x_total+1) when y_total = frame_width else (y_total + 1, x_total);
      if(x_total = frame_width - 1) then
        x_total <= 0;
        --x_img <= 0;
        y_total <= y_total + 1;
      else
        x_total <= x_total + 1;
        --if(x_img < img_width) then
        --  x_img <= x_img + 1;
        --end if;
      end if;

      if(y_total = frame_height - 1) then
        y_total <= 0;
        --y_img <= 0;
      end if;

      if (x_total < img_width) then
        x_img <= x_total;
      end if;

      if (y_total < img_height) then
        y_img <= y_total;
      end if;
    end if;
  end process;

  -- drawing process
  -- process(i_pxl_clk, y_total, x_total)
  -- begin
  --
  -- end process;

  -- get pixel process
  -- process(rising_edge(clk_pixel_x5))
  -- begin

  -- end process;

  -- signal assignment:
  o_curr_x <= x_img;
  o_curr_y <= y_img;
  h_sync <= '1' when (x_total >= img_width + hsync_start and x_total < img_width + hsync_start + hsync_size) else '0';
  v_sync <= '1' when (y_total >= img_height + vsync_start and y_total < img_height + vsync_start + vsync_size) else '0';

  r_pixel <= (i_rgb_pixel(23 downto 16) & "00") when rising_edge(clk_pixel_x5) else r_pixel;
  g_pixel <= (i_rgb_pixel(15 downto 8) & "00") when rising_edge(clk_pixel_x5) else g_pixel;
  b_pixel <= (i_rgb_pixel(7 downto 0) & h_sync & v_sync) when rising_edge(clk_pixel_x5) else b_pixel;

end Behavioral;
