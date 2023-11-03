----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2023 20:46:11
-- Design Name: 
-- Module Name: TB - Behavioral
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

entity TB is
 --Port ( );
end TB;

architecture Behavioral of TB is
signal clk 		: std_logic := '0';
signal rst 		: std_logic := '0';
signal enable 	: std_logic := '1';

constant clock_period : time := 20 ns; 

begin

uut: ENTITY work.TOP
PORT MAP(
	i_clk 			=> clk,
	i_reset 	 	=> rst,
	i_enable_spi 	=> enable
	);

clk_process : process
begin
	clk <= '0';
	wait for clock_period/2;
	clk <= '1';
	wait for clock_period/2;

end process; -- clk_process

end Behavioral;
