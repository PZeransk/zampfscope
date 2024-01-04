
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

entity HDMI_TOP is
generic(
  C_data_res        : integer := 8
  );
port(
  clk_250MHZ         : in std_logic;
  i_reset            : in std_logic;
  i_miso_0           : in std_logic;
  i_miso_1           : in std_logic;
 -- i_enable_spi       : in std_logic;
  i_trigger          : in std_logic;
  o_spi_clk          : out std_logic;
  o_cs               : out std_logic;

  --o_curr_RGB         : out std_logic_vector(23 downto 0) :=(others => 'Z');
                                                        -- (7, 6 , 5, 4 , 3, 2 ,  1 ,  0)
  o_tmds             : out std_logic_vector(7 downto 0) -- (r, rn, g, gn, b, bn, clk, clkn)
 -- o_video_ena        : out std_logic
);
end HDMI_TOP;

architecture behavioral of HDMI_TOP is


component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  -- Status and control signals
  resetn             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;


 -- HDMI signals
  constant IMG_WIDTH        : integer range 0 to 640  := 640;
  constant IMG_HEIGHT       : integer range 0 to 480  := 480;

  signal reset_n            : std_logic := '1';
  signal curr_RGB           : std_logic_vector(23 downto 0) := (others => '0');
  signal tmds_all           : std_logic_vector(3 downto 0) := (others => '0');
  --signal curr_x             : integer range 0 to 640  := 640;
  signal curr_x             : integer range 0 to 640  := 0;
  signal curr_y             : integer range 0 to 480  := 480;
  signal blanking           : std_logic;

  --signal enable             : std_logic := '1';
  signal trigger            : std_logic := '0';
  signal meas_data_0        : std_logic_vector(C_data_res -1 downto 0) := (others => '0');
  signal meas_data_1        : std_logic_vector(C_data_res -1 downto 0) := (others => '0');


  signal locked             : std_logic;
  signal clk_out1           : std_logic;
  signal clk_100MHz         : std_logic;


   --signal image_cnt 	: integer range 0 to C_image_legnth := 0;
begin

--
--PLL : entity work.clk_wiz_0_clk_wiz
--port map(
--
--clk_out1 => clk2,
--clk_out2 => clk_100MHz,
--reset    => i_reset,
--locked   => locked,
--clk_in1  => clk_250MHZ
--
--  );

PLL : clk_wiz_0
   port map (
  -- Clock out ports
   clk_out1 => clk_out1,
   clk_out2 => clk_100MHz,
  -- Status and control signals
   resetn => reset_n,
   locked => locked,
   -- Clock in ports
   clk_in1 => clk_250MHZ
 );



    adc_controller1 : entity work.adc_controller
  generic map(
    C_resolution    => C_data_res
  )
  port map(
    i_clk           => clk_out1,
    i_reset_n       => reset_n,
    --i_enable_spi    => i_enable_spi,
    i_trigger       => trigger,
    i_x_pixel       => curr_x,
    i_miso_0        => i_miso_0,
    i_miso_1        => i_miso_1,
    o_spi_clk       => o_spi_clk,
    o_cs            => o_cs,
    o_meas_data_0   => meas_data_0,
    o_meas_data_1   => meas_data_1
  );

-- OBUFDS_COLOR: for i in 0 to 3 generate
--   OBUFDS_COLOR : OBUFDS
--   generic map (
--     IOSTANDARD => "TMDS_33", -- Specify the output I/O standard
--     SLEW => "FAST")          -- Specify the output slew rate
--   port map (
--     O => o_tmds(2*i),     -- Diff_p output (connect directly to top-level port)
--     OB => o_tmds(2*i + 1),   -- Diff_n output (connect directly to top-level port)
--     I => tmds_all(i)      -- Buffer input
--   );
-- end generate OBUFDS_COLOR;


    OBUFDS_R : OBUFDS
    generic map (
      IOSTANDARD => "TMDS_33", -- Specify the output I/O standard
      SLEW => "FAST")          -- Specify the output slew rate
    port map (
      O => o_tmds(7),     -- Diff_p output (connect directly to top-level port)
      OB => o_tmds(6),   -- Diff_n output (connect directly to top-level port)
      I => tmds_all(3)      -- Buffer input
    );
        OBUFDS_G : OBUFDS
    generic map (
      IOSTANDARD => "TMDS_33", -- Specify the output I/O standard
      SLEW => "FAST")          -- Specify the output slew rate
    port map (
      O => o_tmds(5),     -- Diff_p output (connect directly to top-level port)
      OB => o_tmds(4),   -- Diff_n output (connect directly to top-level port)
      I => tmds_all(2)      -- Buffer input
    );

    OBUFDS_B : OBUFDS
    generic map (
      IOSTANDARD => "TMDS_33", -- Specify the output I/O standard
      SLEW => "FAST")          -- Specify the output slew rate
    port map (
      O => o_tmds(3),     -- Diff_p output (connect directly to top-level port)
      OB => o_tmds(2),   -- Diff_n output (connect directly to top-level port)
      I => tmds_all(1)      -- Buffer input
    );

    OBUFDS_CLK : OBUFDS
    generic map (
      IOSTANDARD => "TMDS_33", -- Specify the output I/O standard
      SLEW => "FAST")          -- Specify the output slew rate
    port map (
      O => o_tmds(1),     -- Diff_p output (connect directly to top-level port)
      OB => o_tmds(0),   -- Diff_n output (connect directly to top-level port)
      I => tmds_all(0)      -- Buffer input
    );



 HDMI_if : entity work.HDMI_test
 generic map (
   img_width   => IMG_WIDTH,
   img_height  => IMG_HEIGHT
 )
 port map (
   i_pxl_clk   => clk_out1,
   i_reset_n   => reset_n,
   o_tmds_all  => tmds_all,
   i_rgb_pixel => curr_RGB,
   o_curr_x    => curr_x,
   o_curr_y    => curr_y,
   blanking    => blanking
 );

 image_generator_HDMI : entity work.HDMI_image_gen
 generic map (
   IMAGE_WIDTH   => IMG_WIDTH,
   IMAGE_HEIGHT  => IMG_HEIGHT,
   C_data_res    => C_data_res
   )
 port map (
   i_clk         => clk_out1,  -- can be this clock, can be 25MHz clock... both will work i suppose?
   --i_x           => curr_x,
   i_y           => curr_y,
   i_meas_data_0 => meas_data_0,
   i_meas_data_1 => meas_data_1,
   o_rgb         => curr_RGB
 );

  trigger <= NOT i_trigger;
  reset_n <= not i_reset;
  --o_tmds <= tmds_all;
  --o_clk  <= clk_250MHZ;
 -- o_video_ena <= not blanking;
 -- o_curr_RGB <= curr_RGB;
end architecture;