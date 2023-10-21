----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2023 16:24:05
-- Design Name: 
-- Module Name: TOP - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( 
    i_clk : in STD_LOGIC;
    o_clk : out std_logic
    );
end TOP;

architecture Behavioral of TOP is
signal clock : std_logic;
begin

clk_div1 : ENTITY work.clock_divider
GENERIC MAP(
	C_cnt_div => 10
	)
PORT MAP(
	i_clk	=> i_clk,
	o_clk	=> o_clk
	);

end Behavioral;
