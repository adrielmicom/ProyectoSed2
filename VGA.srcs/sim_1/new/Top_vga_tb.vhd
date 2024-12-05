----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2024 14:21:13
-- Design Name: 
-- Module Name: Top_vga_tb - Behavioral
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

entity Top_vga_tb is
--  Port ( );
end Top_vga_tb;

architecture Behavioral of Top_vga_tb is

--signal
signal sclk : std_logic := '0';
signal srst : std_logic := '0';
  signal sdatap :  std_logic_vector(2 downto 0);
  signal sdataN :  std_logic_vector(2 downto 0);
  signal sClkN :  std_logic;
  signal sClkP:  std_logic;   
--component


component Top_VGA is
 port (
        clk : in std_logic;
        rst : in std_logic;
        datap : out std_logic_vector(2 downto 0);
        dataN : out std_logic_vector(2 downto 0);
        ClkN : out std_logic;
        ClkP: out std_logic             
);

end component;

begin

    U1:Top_VGA 
    port map (
        clk    =>sclk,
        rst    =>srst,
        datap  =>sdatap,
        dataN  =>sdataN,
        ClkN   =>sClkN,
        ClkP   =>sClkP
    );

     process
        begin

           sclk <= '1';
           wait for 8 ns / 2; -- Esperar medio periodo 
           sclk <= '0';
           wait for 8 ns / 2; -- Esperar medio periodo 
   
   end process;
    
 Srst <= '1' , '0' after 100 ns, '1' after 600ns, '0' after 800ns; --, '1' after 50 ns;
  -- S_Psel_multi <= '0', '1' after 50 ns , '0' after 100 ns,'1' after 50 ns;

end Behavioral;
