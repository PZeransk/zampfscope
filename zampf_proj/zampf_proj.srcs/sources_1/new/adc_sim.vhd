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
Generic(C_data_length	:	integer
	);
Port (
	i_clk 	: in 	std_logic;
 	i_cs 	: in 	std_logic;
 	
 	o_miso0	: out 	std_logic;
 	o_miso1	: out 	std_logic );
end adc_sim;

architecture Behavioral of adc_sim is
type 	t_sine_table is array (127 downto 0) of integer range 0 to 4096;
constant C_sine_LUT : t_sine_table := (
2048 ,2149 ,2250 ,2350 ,2450 ,2549 ,2647 ,2743 ,2837 ,2929 , 
3020 ,3108 ,3193 ,3276 ,3355 ,3431 ,3504 ,3574 ,3639 ,3701 , 
3759 ,3812 ,3862 ,3906 ,3946 ,3982 ,4013 ,4039 ,4060 ,4076 , 
4087 ,4094 ,4095 ,4091 ,4082 ,4069 ,4050 ,4026 ,3998 ,3965 , 
3927 ,3884 ,3837 ,3786 ,3730 ,3671 ,3607 ,3540 ,3468 ,3394 , 
3316 ,3235 ,3151 ,3064 ,2975 ,2883 ,2790 ,2695 ,2598 ,2500 , 
2400 ,2300 ,2199 ,2098 ,1997 ,1896 ,1795 ,1695 ,1595 ,1497 , 
1400 ,1305 ,1212 ,1120 ,1031 ,944 ,860 ,779 ,701 ,627 , 
556 ,488 ,424 ,365 ,309 ,258 ,211 ,168 ,130 ,97 , 
69 ,45 ,26 ,13 ,4 ,0 ,1 ,8 ,19 ,35 , 
56 ,82 ,113 ,149 ,189 ,234 ,283 ,336 ,394 ,456 , 
521 ,591 ,664 ,740 ,820 ,902 ,987 ,1075 ,1166 ,1258 , 
1353 ,1449 ,1546 ,1645 ,1745 ,1845 ,1946 ,2048
	); 

signal r_adc_data 		: std_logic_vector(C_data_length - 1 downto 0) := (others => '0');
signal r_adc_shift		: std_logic_vector(C_data_length - 1 downto 0) := (others => '0');
signal r_data_byte 		: std_logic;
signal r_table_cnt		: integer RANGE 0 TO 127 := 0;
signal data_byte_cnt	: integer RANGE 0 TO C_data_length := 0; -- 15 bitowy wektor

begin
process(i_cs, i_clk)
begin

if(rising_edge(i_cs)) then
if(r_table_cnt = 127) then
r_table_cnt <= 0;
o_miso0 <= 'Z';
o_miso1 <= 'Z';
else
o_miso0 <= 'Z';
o_miso1 <= 'Z';
r_table_cnt <= r_table_cnt + 1;
data_byte_cnt <= 0;

r_adc_data <= "0000" & std_logic_vector(to_unsigned(C_sine_LUT(r_table_cnt),12));
r_adc_shift(11 downto 0) 	<= std_logic_vector(to_unsigned(C_sine_LUT(r_table_cnt),12));
end if;
end if;



if(falling_edge(i_clk)) then
if(i_cs = '0') then
if(data_byte_cnt = C_data_length) then

else
	o_miso0 <= r_adc_data(r_adc_data'high);
	o_miso1 <= r_adc_data(r_adc_data'high);
	r_adc_data <= r_adc_data(r_adc_data'high - 1 downto r_adc_data'low) & '0';
	data_byte_cnt <= data_byte_cnt + 1;
end if;


end if;
end if;

end process;


end Behavioral;
