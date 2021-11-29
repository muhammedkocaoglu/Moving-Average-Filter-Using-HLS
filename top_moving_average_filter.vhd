----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2021 09:49:05 PM
-- Design Name: 
-- Module Name: moving_average_filter - Behavioral
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

entity top_moving_average_filter is
port (
	CLK			: in std_logic;
	data_i		: in std_logic_vector(31 downto 0);
	datavalid	: in std_logic;
	data_o		: out std_logic_vector(31 downto 0);
	dataready	: out std_logic
);
end top_moving_average_filter;

architecture Behavioral of top_moving_average_filter is

    component design_1_wrapper is
        port (
          ap_clk_0 : in STD_LOGIC;
          ap_ctrl_0_done : out STD_LOGIC;
          ap_ctrl_0_idle : out STD_LOGIC;
          ap_ctrl_0_ready : out STD_LOGIC;
          ap_ctrl_0_start : in STD_LOGIC;
          ap_rst_0 : in STD_LOGIC;
          average_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
          data_in_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
          data_prev_0 : in STD_LOGIC_VECTOR ( 31 downto 0 )
        );
      end component;
signal average_0        : STD_LOGIC_VECTOR ( 31 downto 0 ) := (others => '0');    
signal data_in_0        : STD_LOGIC_VECTOR ( 31 downto 0 ) := (others => '0');    
signal data_prev_0      : STD_LOGIC_VECTOR ( 31 downto 0 ) := (others => '0');  
signal ap_ctrl_0_done   : STD_LOGIC := '0';
signal ap_ctrl_0_idle   : STD_LOGIC := '0';
signal ap_ctrl_0_start  : STD_LOGIC := '0';  

type states is (
	S_IDLE, 
	S_CALCULATE
);
signal state : states := S_IDLE;
	
	
type myarraytype is array (0 to 9) of std_logic_vector(31 downto 0);
signal data_array : myarraytype := (others => (others => '0'));
begin
P_MAIN: process(CLK)
begin
if rising_edge(CLK) then
	dataready	<= '0';
	case state is 
		when S_IDLE =>
			if datavalid = '1' then
				state	<= S_CALCULATE;
				data_array	<= data_i & data_array(0 to 8);
				ap_ctrl_0_start	<= '1';
			end if;
			
		when S_CALCULATE =>
			if ap_ctrl_0_done = '1' then
				ap_ctrl_0_start	<= '0';
				dataready		<= '1';
				data_o		<= average_0;
				state	<= S_IDLE;
			end if;
	end case;
end if;
end process;


    design_1_wrapper_i: design_1_wrapper 
        port map (
          ap_clk_0          => CLK,
          ap_ctrl_0_done    => ap_ctrl_0_done,
          ap_ctrl_0_idle    => ap_ctrl_0_idle,
          ap_ctrl_0_ready   => open,
          ap_ctrl_0_start   => ap_ctrl_0_start,
          ap_rst_0          => '0',
          average_0         => average_0,
          data_in_0         => data_array(0),
          data_prev_0       => data_array(9)
        );

end Behavioral;
