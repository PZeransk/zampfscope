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
    IMAGE_WIDTH : integer := 640;
    IMAGE_HEIGHT : integer := 480
  );
  port (
    i_clk       : in std_logic;
    i_x         : in integer range 0 to IMAGE_WIDTH;
    i_y         : in integer range 0 to IMAGE_HEIGHT;
    o_rgb       : out std_logic_vector(23 downto 0)
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
    -- r_sig <= ('0' & std_logic_vector(TO_UNSIGNED(i_y,10)(6 downto 0)));
    -- if(TO_UNSIGNED(i_y,10)(4 downto 3) = (not TO_UNSIGNED(i_x,10)(4 downto 3))) then
    --       r_sig(7) <= '1';
    -- end if;
    -- g_sig <= (TO_UNSIGNED(i_y,10)(6)& std_logic_vector(TO_UNSIGNED(i_x,10)(6 downto 0)));
    -- b_sig <= std_logic_vector(TO_UNSIGNED(i_y,10)(7 downto 0));
    r_sig <= std_logic_vector(TO_UNSIGNED(i_x, 8));
    g_sig <= std_logic_vector(TO_UNSIGNED(i_y, 8));
    b_sig <= (others => '0');
  end process;

  o_rgb <= (r_sig & g_sig & b_sig);

end architecture;