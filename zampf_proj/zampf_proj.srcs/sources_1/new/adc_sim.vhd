----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.10.2023 14:55:46
-- Design Name: 
-- Module Name: adc_sim - Behavioral
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

entity adc_sim is
Port (
	i_clk 	: in 	std_logic;
 	i_cs 	: in 	std_logic;
 	
 	o_miso0	: out 	std_logic;
 	o_miso1	: out 	std_logic );
end adc_sim;

architecture Behavioral of adc_sim is
signal r_adc_data 	: std_logic_vector(15 downto 0) := "0001010101010101";
signal r_adc_shift	: std_logic_vector(15 downto 0) := (others => '0');
signal r_data_byte 	: std_logic;
signal r_cnt		: integer RANGE 0 TO 15 := 0;

begin
process(i_cs, i_clk)
begin

if(i_cs = '0') then
if(falling_edge(i_clk)) then


o_miso0 <= r_adc_data(r_adc_data'high);

r_adc_data <= r_adc_data(r_adc_data'high - 1 downto r_adc_data'low) & r_adc_data(r_adc_data'high);


end if;
end if;

end process;


end Behavioral;
