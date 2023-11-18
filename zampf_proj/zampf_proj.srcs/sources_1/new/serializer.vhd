----------------------------------------------------------------------------------
-- Company: WUT
-- Engineer: Michal Smol - Miszq
--
-- Create Date: 05.11.2023 23:04:16
-- Design Name:
-- Module Name: serializer - Behavioral
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

entity serializer is
  Generic (
    DATA_LEN  : integer := 10;
    BUS_LEN   : integer := 10
  );
  Port(
    i_clk       : in  std_logic;
    i_shift_clk : in  std_logic;
    i_data      : in  std_logic_vector(9 downto 0);
    o_bit       : out std_logic;
    o_n_bit     : out std_logic
  );
end entity;


architecture Behavioral of serializer is
  signal data_index   : integer range 0 to BUS_LEN := 0;
  signal inner_data   : std_logic;
begin

  process (i_shift_clk, i_clk)
  begin
    if(rising_edge(i_shift_clk)) then
      if(data_index = BUS_LEN - 1) then
        data_index <= 0;
      else
        data_index <= data_index + 1;
      end if;
    end if;

    if(rising_edge(i_clk)) then
      data_index <= 0;
    end if;
  end process;

  inner_data <= i_data(data_index) when data_index < DATA_LEN else '0';
  o_bit <= inner_data;
  o_n_bit <= not inner_data;

end Behavioral;