----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2024 23:15:12
-- Design Name: 
-- Module Name: MEGHOST_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEGHOST_tb is
--  Port ( );
end MEGHOST_tb;

architecture Behavioral of MEGHOST_tb is

signal Sclk_25: std_logic; --el clk1_0 del pll
signal Srst:  std_logic;
signal SFilasghost    :  unsigned(4 downto 0); 
signal SColumnasGhost  :  unsigned(4 downto 0);



component MEghost is
  Port (
        en : in std_logic;
        rst : in STD_LOGIC;
        clk_25 : in STD_LOGIC;
        FilasGhost     : out unsigned(4 downto 0); 
        ColumnasGhost  : out unsigned(4 downto 0)
        );        
end component;

begin

         CeldaGHOST: MEghost 
            Port map (
            en =>'1',
            rst           =>srst,
            clk_25        =>Sclk_25,
            FilasGhost    =>sFilasGhost,
            ColumnasGhost =>sColumnasGhost
            );    
            
  
     process
        begin
           
           sclk_25 <= '1';
           wait for 8 ns / 2; -- Esperar medio periodo 
           sclk_25 <= '0';
           wait for 8 ns / 2; -- Esperar medio periodo 
   
   end process;
    srst <= '1', '0' after 20ns;
 
  --sbtn0 <= '0', '1' after 100ns, '0' after 110 ns , '1' after 650 ns;   
  --  sbtn0 <= '0', '1' after 100ns, '0' after 110 ns , '1' after 650 ns;         
          
            
end Behavioral;
