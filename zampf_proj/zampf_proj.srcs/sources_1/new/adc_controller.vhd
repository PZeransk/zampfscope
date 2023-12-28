----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 19.10.2023 16:24:05
-- Design Name:
-- Module Name: adc_controller - Behavioral
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
-- F:\Programy\SUBLIME\Sublime Text 3\sublime_text.exe [file name] -l[line number]
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity adc_controller is
	GENERIC(
	C_resolution	:	integer	:= 8
	);
    Port (
    i_clk 			: in  STD_LOGIC;
    i_reset_n 		: in  std_logic;
    --i_enable_spi	: in  std_logic;
    i_trigger 	: in  std_logic;
    i_x_pixel 		: in  integer;
    
    i_miso_0		: in  std_logic;
    i_miso_1		: in  std_logic;
    o_spi_clk 		: out std_logic;
    o_cs 			: out std_logic;
        --i_clk_polarity  : in  std_logic;
   -- i_clk_phase 	: in  std_logic;
    o_meas_data_0		: out std_logic_vector(C_resolution - 1 downto 0);
    o_meas_data_1		: out std_logic_vector(C_resolution - 1 downto 0)
    );
end adc_controller;

architecture adc_Behavioral of adc_controller is
signal clock 		: std_logic;
signal r_cs  		: std_logic;
--signal r_miso0		: std_logic;
--signal r_miso1		: std_logic;
signal enable 		: std_logic := '1';
--signal clock_pol	: std_logic := '1';
--signal clock_phas   : std_logic := '1';
signal spi_clk 		: std_logic;
signal spi_data_0	: std_logic_vector(15 downto 0);
signal spi_data_1	: std_logic_vector(15 downto 0);
signal div_clk		: std_logic;
--signal trigger_n 	: std_logic := '0';


--signal o_h_sync  	: std_logic;
--signal o_v_sync  	: std_logic;
--signal o_disp_ena	: std_logic;
--signal o_r_sig		: std_logic_vector(2 downto 0);
--signal o_b_sig		: std_logic_vector(2 downto 0);
--signal o_g_sig		: std_logic_vector(2 downto 0);

begin

--divides clock C_cnt_div*2
--clk_divider	:	ENTITY work.clock_divider
--GENERIC MAP(
--	C_cnt_div	=> 5
--	)
--PORT MAP(
--	i_clk 		=> i_clk,
--	i_reset_n   => i_reset_n,
--	o_clk 		=> div_clk
--	);


master_spi_0 : ENTITY work.master_spi
GENERIC MAP(
	C_clk_ratio    => 10,
	C_data_length  => 16
	)
PORT MAP(
	i_clk		   => i_clk,
	i_reset_n	   => i_reset_n,
	--i_cs 		   =>
	--i_enable	   => i_enable_spi,
	i_enable	   => enable,
--	i_clk_polarity => clock_pol,
--	i_clk_phase	   => clock_phas,
	i_miso_0	   => i_miso_0,
	i_miso_1	   => i_miso_1,
	--i_address	   =>
	o_cs		   => r_cs,
	o_spi_clk	   => o_spi_clk,
	--o_mosi		   =>
	o_rx_data_0	   => spi_data_0,
	o_rx_data_1	   => spi_data_1
	);


--adc_sim1 : ENTITY work.adc_sim
--GENERIC MAP(C_data_length => 16)
--PORT MAP(
--	i_clk	=> spi_clk,
--	i_cs 	=> r_cs,
--	o_miso0	=> r_miso0,
--	o_miso1	=> r_miso1
--	);

--
IMAGE_GEN_TEST : ENTITY work.image_generator
PORT MAP(
	i_clk			=> i_clk,
	i_cs 			=> r_cs,
	i_reset_n		=> i_reset_n,
	i_trigger 		=> i_trigger,

	i_x_pixel		=> i_x_pixel,
	--i_h_sync		=>
	--i_v_sync		=> o_v_sync,
	i_spi_data0		=> spi_data_0,
	i_spi_data1		=> spi_data_1,
	o_image_data0	=> o_meas_data_0,
	o_image_data1 	=> o_meas_data_1,
	o_adc_enable  	=> enable
	--o_end_meas	=>
	--o_image_data	=>
	);
	o_cs <= r_cs;

end adc_Behavioral;
