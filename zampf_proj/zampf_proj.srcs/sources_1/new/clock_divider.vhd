----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 21.10.2023 11:41:06
-- Design Name:
-- Module Name: clock_divider -
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

entity clock_divider is
	Generic(
	C_cnt_div	:	  integer
	);
 	Port (
 	i_clk 		: in  std_logic;
 	o_clk		: out std_logic;
 	i_reset_n   : in std_logic
  	);
end clock_divider;

architecture clk_div of clock_divider is

SIGNAL r_cnt		:   integer RANGE 0 TO C_cnt_div - 1 := 0;
SIGNAL clock_state	:	std_logic := '0';

begin
process(i_clk, i_reset_n, clock_state)
begin

if(i_reset_n = '0') then
    r_cnt <= 0;
    clock_state <= '0';
elsif(rising_edge(i_clk)) then
	r_cnt <= r_cnt + 1;

	if(r_cnt = C_cnt_div-1) then
	clock_state <= NOT clock_state;
	r_cnt <= 0;
	end if;

end if;

end process;
o_clk <= clock_state;

end ;
