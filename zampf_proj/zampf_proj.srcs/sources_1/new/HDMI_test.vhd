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
  vsync_size      : integer := 2;
  hpolarity       : std_logic := '0';
  vpolarity       : std_logic := '0'  
);
Port (
  i_pxl_clk   : in std_logic;
  i_reset_n   : in std_logic;                     -- (3, 2, 1,  0 )
  o_tmds_all  : out std_logic_vector(3 downto 0); -- (r, g, b, clk)

  i_rgb_pixel : in std_logic_vector(23 downto 0);
  o_curr_x    : out integer range 0 to img_width;
  o_curr_y    : out integer range 0 to img_height;
  blanking    : out std_logic
  );
end HDMI_test;

architecture Behavioral of HDMI_test is
constant r_index : integer := 2;
constant g_index : integer := 1;
constant b_index : integer := 0;

type rgb_array      is array (0 to 2) of std_logic_vector(7 downto 0);
type TMDS_data_out  is array (0 to 2) of std_logic_vector(9 downto 0);

signal clk_pixel_x5 : std_logic;
signal x_img        : integer range 0 to img_width := 0; -- range(0, img_width) -- variables that shows which
signal y_img        : integer range 0 to img_height := 0; -- range(0,img_height) -- pixel of screen is printed
signal x_total      : integer range 0 to frame_width := 0;
signal y_total      : integer range 0 to frame_height := 0;
signal h_sync       : std_logic := '0';
signal v_sync       : std_logic := '0';
signal rgb_pixel    : rgb_array := (others => (others => '0') ) ;
-- signal r_pixel      : std_logic_vector(7 downto 0);
-- signal g_pixel      : std_logic_vector(7 downto 0);
-- signal b_pixel      : std_logic_vector(7 downto 0);
signal tmds_signals : TMDS_data_out :=(others => (others => '0') ) ;

signal TDMS_ena     : std_logic;
signal video_enable : std_logic := '0';
--signal proceed_image: std_logic;

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

  TMDS_rgb_encoders: for i in 0 to 2 generate

    HV_SYNC : if (i = b_index) generate
      TMDS: entity work.TMDS_Encoder
        port map (
          PixelClk    => clk_pixel_x5,
          SerialClk   => '0',
          aRst        => '0',
          pDataOutRaw => tmds_signals(i),
          pDataOut    => rgb_pixel(i),
          pC0         => h_sync,
          pC1         => v_sync,
          pVde        => video_enable
        );
    end generate HV_SYNC;

    COLOR : if (i /= b_index) generate
      TMDS: entity work.TMDS_Encoder
        port map (
          PixelClk    => clk_pixel_x5,
          SerialClk   => '0',
          aRst        => '0',
          pDataOutRaw => tmds_signals(i),
          pDataOut    => rgb_pixel(i),
          pC0         => '0',
          pC1         => '0',
          pVde        => video_enable
        );
    end generate COLOR;

    -- serializer generate
    RGB_serializer : entity work.serializer
    port map (
      i_clk       => clk_pixel_x5,
      i_shift_clk => i_pxl_clk,
      i_data      => tmds_signals(i),
      o_bit       => o_tmds_all(i + 1)
      --o_n_bit     => o_tmds_all(6 - 2*i)
    );
  end generate TMDS_rgb_encoders;

  o_tmds_all(0) <= clk_pixel_x5;
  --o_tmds_all(0) <= not clk_pixel_x5;

  -- process(clk_pixel_x5, i_pxl_clk, i_reset_n)
  --   variable next_pxl_signal_state : integer range 0 to 3 := 3;
  -- begin
  --   if(i_reset_n ='0') then
  --       next_pxl_signal_state  := 3;
  --       proceed_image <= '0';
  --   else
  --     if(rising_edge(clk_pixel_x5)) then
  --       next_pxl_signal_state  := 0;
  --     elsif(rising_edge(i_pxl_clk) and next_pxl_signal_state  = 0) then
  --       next_pxl_signal_state  := 1;
  --       proceed_image <= '1';
  --     elsif(rising_edge(i_pxl_clk) and next_pxl_signal_state  = 1) then
  --       next_pxl_signal_state  := 3;
  --       proceed_image <= '0';
  --     end if;
  --   end if;
  -- end process;

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





  hv_sync_vena : process(clk_pixel_x5, i_reset_n)
  begin
    if (i_reset_n = '0') then
      h_sync <= '0';
      v_sync <= '0';
      video_enable <= '0';
    elsif (rising_edge(clk_pixel_x5)) then
      if (x_total >= img_width + hsync_start and x_total < img_width + hsync_start + hsync_size) then
        h_sync <= hpolarity;
      else
        h_sync <= not hpolarity;
      end if;

      if (y_total >= img_height + vsync_start and y_total < img_height + vsync_start + vsync_size) then
        v_sync <= vpolarity;
      else
        v_sync <= not vpolarity;
      end if;

      if (x_total < img_width) and (y_total < img_height) then
        video_enable <= '1';
      else
        video_enable <= '0';
      end if;
      -- this beauty cannot be compiled, sad :,(
      -- h_sync <= '1' when (x_total >= img_width + hsync_start and x_total < img_width + hsync_start + hsync_size);
      -- v_sync <= '1' when (y_total >= img_height + vsync_start and y_total < img_height + vsync_start + vsync_size);
      -- video_enable <= '1' when (x_total < img_width) and (y_total < img_height);
    end if;
  end process;

  rgb_latch_process: process(clk_pixel_x5)
  begin
    if rising_edge(clk_pixel_x5) then
      rgb_pixel(r_index) <= (i_rgb_pixel(23 downto 16));
      rgb_pixel(g_index) <= (i_rgb_pixel(15 downto 8));
      rgb_pixel(b_index) <= (i_rgb_pixel(7 downto 0));
    end if;
  end process;

  -- signal assignment:
  o_curr_x <= x_img;
  o_curr_y <= y_img;
  blanking <= not video_enable;

  --! WARNING: Asynchronous assigning pixel with clock will generate one clock tic delay!!

  --COLOR_ASSIGNMENT: for i in 0 to 2 generate
  --  rgb_pixel(i) <= (i_rgb_pixel((i + 1)*8 - 1 downto (i)*8)) when rising_edge(clk_pixel_x5) else rgb_pixel(i);
  --end generate COLOR_ASSIGNMENT;

  --should generate something like:
    --should generate something like:

  -- rgb_pixel(r_index) <= (i_rgb_pixel(23 downto 16)) when rising_edge(clk_pixel_x5) else rgb_pixel(r_index);
  -- rgb_pixel(g_index) <= (i_rgb_pixel(15 downto 8)) when rising_edge(clk_pixel_x5) else rgb_pixel(g_index);
  -- rgb_pixel(b_index) <= (i_rgb_pixel(7 downto 0)) when rising_edge(clk_pixel_x5) else rgb_pixel(b_index);


  --r_pixel <= (i_rgb_pixel(23 downto 16)) when rising_edge(clk_pixel_x5) else r_pixel;
  --g_pixel <= (i_rgb_pixel(15 downto 8))  when rising_edge(clk_pixel_x5) else g_pixel;
  --b_pixel <= (i_rgb_pixel(7 downto 0))   when rising_edge(clk_pixel_x5) else b_pixel;
  --rgb_pixel(r_index) <= r_pixel;
  --rgb_pixel(g_index) <= g_pixel;
  --rgb_pixel(b_index) <= b_pixel;

end Behavioral;
