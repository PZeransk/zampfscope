----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 18.01.2024 23:43:09
-- Design Name:
-- Module Name: hdmi_configuration_type - Behavioral
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
package hdmi_conf_type is
  type HDMI_configuration_type is record
    frame_width     : integer ;
    frame_height    : integer ;
    img_width       : integer ;
    img_height      : integer ;
    hsync_start     : integer ;
    hsync_size      : integer ;
    vsync_start     : integer ;
    vsync_size      : integer ;
    hpolarity       : std_logic ;
    vpolarity       : std_logic ;
  end record HDMI_configuration_type;

  --constant configuration_string : string := "VGA";  -- possibilities: "HD1080P", "HD720P", "SVGA", "VGA"

  constant HD1080P_conf : HDMI_configuration_type := (
    frame_width       =>  2200,
    frame_height      =>  1125,
    img_width         =>  1920,
    img_height        =>  1080,
    hsync_start       =>  88,
    hsync_size        =>  44,
    vsync_start       =>  4,
    vsync_size        =>  5,
    hpolarity         => '1',
    vpolarity         => '1'
  );

  constant HD720P_conf : HDMI_configuration_type := (
    frame_width       =>  1648,
    frame_height      =>  750,
    img_width         =>  1280,
    img_height        =>  720,
    hsync_start       =>  72,
    hsync_size        =>  80,
    vsync_start       =>  3,
    vsync_size        =>  5,
    hpolarity         => '1',
    vpolarity         => '1'
  );

  constant SVGA_conf : HDMI_configuration_type := (
    frame_width       =>  1056,
    frame_height      =>  628,
    img_width         =>  800,
    img_height        =>  600,
    hsync_start       =>  40,
    hsync_size        =>  128,
    vsync_start       =>  1,
    vsync_size        =>  4,
    hpolarity         => '1',
    vpolarity         => '1'
  );

  constant VGA_conf : HDMI_configuration_type := (
    frame_width       =>  800,
    frame_height      =>  525,
    img_width         =>  640,
    img_height        =>  480,
    hsync_start       =>  16,
    hsync_size        =>  96,
    vsync_start       =>  10,
    vsync_size        =>  2,
    hpolarity         => '0',
    vpolarity         => '0'
  );

--hdmi_conf_generic: case configuration_string generate
--when "HD1080P" =>
--  constant current_hdmi_conf : HDMI_configuration_type := HD1080P_conf;
--when "HD720P" =>
--  constant current_hdmi_conf : HDMI_configuration_type := HD720P_conf;
--when "SVGA" =>
--  constant current_hdmi_conf : HDMI_configuration_type := SVGA_conf;
--when "VGA" =>
--  constant current_hdmi_conf : HDMI_configuration_type := VGA_conf;
--end generate;


-- if configuration_string = "VGA" generate
--   constant current_hdmi_conf : HDMI_configuration_type := VGA_conf;
-- end generate;
--
-- elsif configuration_string = "HD1080P" generate
--   constant current_hdmi_conf : HDMI_configuration_type := HD1080P_conf;
-- end generate;
--
-- if configuration_string = "HD720P" generate
--   constant current_hdmi_conf : HDMI_configuration_type := HD720P_conf;
-- end generate;
--
-- if configuration_string = "SVGA" generate
--   constant current_hdmi_conf : HDMI_configuration_type := SVGA_conf;
-- end generate;

end package hdmi_conf_type;