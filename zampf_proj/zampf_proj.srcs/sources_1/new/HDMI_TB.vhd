----------------------------------------------------------------------------------
-- Company: WUT
-- Engineer: Michal Smol - Miszq
--
-- Create Date: 05.11.2023 23:04:16
-- Design Name:
-- Module Name: HDMI_TB - Behavioral
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity HDMI_TB is
end HDMI_TB;

architecture behavioral of HDMI_TB is
  constant IMG_WIDTH        : integer   := 640;
  constant IMG_HEIGHT       : integer   := 480;
  constant clock_period     : time      := 4 ns;

  signal clk_250MHz         : std_logic := '0';
  signal reset_n            : std_logic := '1';
  signal curr_RGB           : std_logic_vector(23 downto 0);
  signal tmds_all           : std_logic_vector(7 downto 0);
  signal curr_x, curr_y     : integer;
begin

DUT : entity work.HDMI_test
generic map (
  img_width   => IMG_WIDTH,
  img_height  => IMG_HEIGHT
)
port map (
  i_pxl_clk   => clk_250MHz,
  i_reset_n   => reset_n,
  o_tmds_all  => tmds_all,
  i_rgb_pixel => curr_RGB,
  o_curr_x    => curr_x,
  o_curr_y    => curr_y
);

image_generator : entity work.HDMI_image_gen
generic map (IMG_WIDTH, IMG_HEIGHT)
port map (
  i_clk   => clk_250MHz,  -- can be this clock, can be 25MHz clock... both will work
  i_x     => curr_x,
  i_y     => curr_y,
  o_rgb   => curr_RGB
);

clk_sim: process
begin
  clk_250MHz <= '0';
  wait for clock_period/2;
  clk_250MHz <= '1';
  wait for clock_period/2;
end process;

end architecture;