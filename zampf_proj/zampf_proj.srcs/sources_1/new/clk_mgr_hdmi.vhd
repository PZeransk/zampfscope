library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity clk_mgr_hdmi is
    generic (
        RES_WORD : string := "HD1080P"
    );
    port(
        i_clk  : in  std_logic; --  input clock
        o_pixel_clk : out std_logic; -- serial clock
        o_serial_clk : out std_logic  --  pixel clock
    );
end clk_mgr_hdmi;

architecture rtl of clk_mgr_hdmi is
    signal pxl_clk, ser_clk : std_logic;
begin

clk_pxl: BUFG port map (I=>pxl_clk, O=>o_pixel_clk);
clk_ser: BUFG port map (I=>ser_clk, O=>o_serial_clk);

timing_hd1080p: if RES_WORD = "HD1080P" generate
begin
clock: entity work.clking_gen
  generic map (CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>59, CLK_DIVIDE=>5, CLKOUT0_DIV=>1, CLKOUT1_DIV=>10) -- 1080p
  port map (clk_i=>i_clk, clk0_o=>ser_clk, clk1_o=>pxl_clk);
end generate;

timing_hd720p: if RES_WORD = "HD720P" generate
begin
clock: entity work.clking_gen
    generic map (CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>59, CLK_DIVIDE=>5, CLKOUT0_DIV=>2, CLKOUT1_DIV=>20) -- 720p
    port map (clk_i=>i_clk, clk0_o=>ser_clk, clk1_o=>pxl_clk);
end generate;

timing_svga: if RES_WORD = "SVGA" generate
begin
clock: entity work.clking_gen
    generic map (CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>16, CLK_DIVIDE=>1, CLKOUT0_DIV=>5, CLKOUT1_DIV=>50) -- 800x600
    port map (clk_i=>i_clk, clk0_o=>ser_clk, clk1_o=>pxl_clk);
end generate;

timing_vga: if RES_WORD = "VGA" generate
begin
clock: entity work.clking_gen
    generic map (CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>8, CLK_DIVIDE=>1, CLKOUT0_DIV=>4, CLKOUT1_DIV=>40) -- 640x480
    port map (clk_i=>i_clk, clk0_o=>ser_clk, clk1_o=>pxl_clk );
end generate;

end rtl;