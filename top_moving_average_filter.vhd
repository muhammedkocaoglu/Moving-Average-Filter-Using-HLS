----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Muhammed KOCOAĞLU
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top_moving_average_filter IS
    PORT (
        CLK       : IN STD_LOGIC;
        data_i    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        datavalid : IN STD_LOGIC;
        data_o    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataready : OUT STD_LOGIC
    );
END top_moving_average_filter;

ARCHITECTURE Behavioral OF top_moving_average_filter IS

    COMPONENT design_1_wrapper IS
        PORT (
            ap_clk_0        : IN STD_LOGIC;
            ap_ctrl_0_done  : OUT STD_LOGIC;
            ap_ctrl_0_idle  : OUT STD_LOGIC;
            ap_ctrl_0_ready : OUT STD_LOGIC;
            ap_ctrl_0_start : IN STD_LOGIC;
            ap_rst_0        : IN STD_LOGIC;
            average_0       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_in_0       : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_prev_0     : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL average_0       : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in_0       : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_prev_0     : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ap_ctrl_0_done  : STD_LOGIC                      := '0';
    SIGNAL ap_ctrl_0_idle  : STD_LOGIC                      := '0';
    SIGNAL ap_ctrl_0_start : STD_LOGIC                      := '0';

    TYPE states IS (
        S_IDLE,
        S_CALCULATE
    );
    SIGNAL state : states := S_IDLE;
    TYPE myarraytype IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_array : myarraytype := (OTHERS => (OTHERS => '0'));
BEGIN
    P_MAIN : PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            dataready <= '0';
            CASE state IS
                WHEN S_IDLE =>
                    IF datavalid = '1' THEN
                        state           <= S_CALCULATE;
                        data_array      <= data_i & data_array(0 TO 8);
                        ap_ctrl_0_start <= '1';
                    END IF;

                WHEN S_CALCULATE =>
                    IF ap_ctrl_0_done = '1' THEN
                        ap_ctrl_0_start <= '0';
                        dataready       <= '1';
                        data_o          <= average_0;
                        state           <= S_IDLE;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;
    design_1_wrapper_i : design_1_wrapper
    PORT MAP(
        ap_clk_0        => CLK,
        ap_ctrl_0_done  => ap_ctrl_0_done,
        ap_ctrl_0_idle  => ap_ctrl_0_idle,
        ap_ctrl_0_ready => OPEN,
        ap_ctrl_0_start => ap_ctrl_0_start,
        ap_rst_0        => '0',
        average_0       => average_0,
        data_in_0       => data_array(0),
        data_prev_0     => data_array(9)
    );

END Behavioral;
