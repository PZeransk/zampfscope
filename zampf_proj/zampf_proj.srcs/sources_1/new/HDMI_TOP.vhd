

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity HDMI_TOP is

port(
  clk_250MHZ         : in std_logic;
  i_reset              : in std_logic;
  o_curr_RGB         : out std_logic_vector(23 downto 0);
  o_tmds             : out std_logic_vector(7 downto 0);
  o_video_ena        : out std_logic
);
end HDMI_TOP;

architecture behavioral of HDMI_TOP is
  constant IMG_WIDTH        : integer   := 640;
  constant IMG_HEIGHT       : integer   := 480;

  signal reset_n            : std_logic := '1';
  signal curr_RGB           : std_logic_vector(23 downto 0);
  signal tmds_all           : std_logic_vector(7 downto 0);
  signal curr_x, curr_y     : integer;

  signal blanking           : std_logic;
  --signal image_cnt 	: integer range 0 to C_image_legnth := 0;
begin

  reset_n <= not i_reset;

  HDMI_if : entity work.HDMI_test
  generic map (
    img_width   => IMG_WIDTH,
    img_height  => IMG_HEIGHT
  )
  port map (
    i_pxl_clk   => clk_250MHZ,
    i_reset_n   => reset_n,
    o_tmds_all  => tmds_all,
    i_rgb_pixel => curr_RGB,
    o_curr_x    => curr_x,
    o_curr_y    => curr_y,
    blanking    => blanking
  );

  image_generator : entity work.HDMI_image_gen
  generic map (IMG_WIDTH, IMG_HEIGHT)
  port map (
    i_clk   => clk_250MHZ,  -- can be this clock, can be 25MHz clock... both will work i suppose?
    i_x     => curr_x,
    i_y     => curr_y,
    o_rgb   => curr_RGB
  );

  o_tmds <= tmds_all;
  o_video_ena <= not blanking;
  o_curr_RGB <= curr_RGB;
end architecture;