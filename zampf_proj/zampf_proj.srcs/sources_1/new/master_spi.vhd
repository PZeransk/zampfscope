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
	C_clk_ratio 	: 	integer;
	C_data_length	:	integer
	);
PORT(
	i_clk			:	in 	std_logic;
	i_reset_n		:	in 	std_logic;
	--i_cs 			:	in 	std_logic;
	i_enable		:	in 	std_logic;
	i_clk_polarity	:	in  std_logic;
	i_clk_phase		:	in 	std_logic;
	i_miso_0		:	in 	std_logic;
	i_miso_1		:	in 	std_logic;
	--i_address		:	in 	std_logic_vector(C_data_length downto 0);

	o_bussy			:  	out	std_logic;
	o_cs			:	out std_logic;
	o_spi_clk		:	out std_logic;
	--o_mosi			:	out	std_logic;
	o_rx_data_0		:	out std_logic_vector(C_data_length - 1 downto 0);
	o_rx_data_1		:	out std_logic_vector(C_data_length - 1 downto 0)
	);
end master_spi;

architecture Behavioral of master_spi is
type T_spi_states is (IDLE,
					  TRANSFER);

SIGNAL r_current_state 	: T_spi_states 	:= IDLE;
SIGNAL r_cs_state		: std_logic;
SIGNAL clk_cnt 			: integer range 0 to C_data_length*2 + 1 := 0;
SIGNAL clk_cnt_ratio	: integer range 0 to C_clk_ratio   := 0;
SIGNAL r_rx_register0	: std_logic_vector(C_data_length - 1 downto 0) := (others => '0');
SIGNAL r_rx_register1	: std_logic_vector(C_data_length - 1 downto 0) := (others => '0');
SIGNAL r_clk_state		: std_logic := '0';


begin
process(i_clk, i_reset_n)
begin 

IF(i_reset_n = '0') then
	o_cs <= '1';
	o_rx_data_0 <= (others => '0');
	o_rx_data_1 <= (others => '0');
	--o_mosi <= 'Z';
	clk_cnt_ratio <= 0;
	r_current_state <= IDLE;

ELSIF(rising_edge(i_clk)) then
	CASE r_current_state IS 
	--IDLE STATE
		when IDLE => 
			o_cs <= '1';
			clk_cnt_ratio <= 0;
			clk_cnt <= 0;
			r_rx_register0 <= (others => '0');
			r_rx_register1 <= (others => '0');
			o_rx_data_0 <= r_rx_register0;
			o_rx_data_1 <= r_rx_register1;
			-- o_mosi <= 'Z';
			IF(i_enable = '1') THEN 
				r_clk_state <= i_clk_polarity;
				o_spi_clk <= r_clk_state;
				r_current_state <= TRANSFER;
			ELSE
				r_current_state <= IDLE;
			END IF;

	--TRANSFER STATE
		when TRANSFER =>
			
			if(clk_cnt_ratio = C_clk_ratio - 1) then
			o_cs <= '0';
				if(clk_cnt = C_data_length*2+2) then
					clk_cnt <= 0;
					o_rx_data_0 <= r_rx_register0;
					o_rx_data_1 <= r_rx_register1;
					o_cs <= '1';
					r_current_state <= IDLE;
				else
					clk_cnt <= clk_cnt + 1;
					r_clk_state <= NOT r_clk_state;
				end if;

				if(r_clk_state = i_clk_phase AND clk_cnt <= C_data_length*2) then
					r_rx_register0 <= r_rx_register0(r_rx_register0'high - 1 downto r_rx_register0'low) & i_miso_0;
					r_rx_register1 <= r_rx_register1(r_rx_register1'high - 1 downto r_rx_register1'low) & i_miso_1;
				end if;

				
				o_spi_clk <= r_clk_state;
				clk_cnt_ratio <= 0;
			else
				clk_cnt_ratio <= clk_cnt_ratio + 1;
				r_current_state <= TRANSFER;
			end if;

	END CASE;

end if;


end process;


end Behavioral;
