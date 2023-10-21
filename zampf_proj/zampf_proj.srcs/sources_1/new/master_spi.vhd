----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2023 19:43:54
-- Design Name: 
-- Module Name: master_spi - Behavioral
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
use IEEE.NUMERIC_STD.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity master_spi is
GENERIC(
	C_data_length	:	integer	:=	16
	);
PORT(
	i_clk			:	in 	std_logic;
	i_reset_n		:	in 	std_logic;
	i_ss 			:	in 	std_logic;
	i_enable		:	in 	std_logic;
	i_clk_polarity	:	in  std_logic;
	i_clk_phase		:	in 	std_logic;
	i_miso_0		:	in 	std_logic;
	i_miso_1		:	in 	std_logic;
	i_address		:	in 	std_logic_vector(C_data_length downto 0);

	o_bussy			:  	out	std_logic;
	o_rx_data_0		:	out std_logic_vector(C_data_length downto 0);
	o_rx_data_1		:	out std_logic_vector(C_data_length downto 0)
	);
end master_spi;

architecture Behavioral of master_spi is

begin
process(i_clk, i_reset_n)

end process;


end Behavioral;
