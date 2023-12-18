----------------------------------------------------------------------------------
-- Company: WUT
-- Engineer: Michal Smol - Miszq
--
-- Create Date: 05.11.2023 23:04:16
-- Design Name:
-- Module Name: HDMI_imgae_gen - Behavioral
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

entity HDMI_image_gen is
  generic (
    IMAGE_WIDTH   : integer := 640;
    IMAGE_HEIGHT  : integer := 480;
    C_data_res    : integer := 8
  );
  port (
    i_clk         : in std_logic;
    i_x           : in integer range 0 to IMAGE_WIDTH;
    i_y           : in integer range 0 to IMAGE_HEIGHT;
    i_meas_data_0 : in std_logic_vector(C_data_res - 1 downto 0);
    i_meas_data_1 : in std_logic_vector(C_data_res - 1 downto 0);
    o_rgb         : out std_logic_vector(23 downto 0)
  );
end entity;


architecture behavioral of HDMI_image_gen is
signal r_sig : std_logic_vector(7 downto 0);
signal g_sig : std_logic_vector(7 downto 0);
signal b_sig : std_logic_vector(7 downto 0);
begin

  -- drawing process
  process (i_clk, i_x, i_y)
  begin
  if(rising_edge(i_clk)) then
    if(i_y = to_integer(unsigned(i_meas_data_0)) + 112) then
      r_sig <= "11111111";
      g_sig <= "11111111";
      b_sig <= (others => '0');
    elsif(i_y = to_integer(unsigned(i_meas_data_1)) + 142) then
      r_sig <= (others => '0');
      g_sig <= "11111111";
      b_sig <= (others => '0');
    elsif(i_y < 110)  then
      r_sig <= "11111111";
      g_sig <= "10011111";
      b_sig <= "11111111";
    elsif(i_y > 370)  then
      r_sig <= "11111111";
      g_sig <= "10011111";
      b_sig <= "11111111";
    elsif(i_x mod 64 = 0) then
      r_sig <= "01111111";
      g_sig <= "01111111";
      b_sig <= "01111111";
    elsif(i_y mod 48 = 0) then
      r_sig <= "01111111";
      g_sig <= "01111111";
      b_sig <= "01111111";
    else
      r_sig <= (others => '0');
      g_sig <= (others => '0');
      b_sig <= (others => '0');
    end if;

  end if;
  end process;

  o_rgb <= (r_sig & g_sig & b_sig);

end architecture;