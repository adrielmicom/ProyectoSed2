----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2024 18:13:09
-- Design Name: 
-- Module Name: PoscionPacman_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PoscionPacman_tb is

end PoscionPacman_tb;

architecture Behavioral of PoscionPacman_tb is
signal Sclk_25: std_logic; --el clk1_0 del pll
signal Sbtn0: std_logic;
signal Sbtn1: std_logic;
signal Sbtn2: std_logic;
signal Sbtn3: std_logic;
signal Srst:  std_logic;

signal SFilasPacman     :  unsigned(4 downto 0); 
signal SColumnasPacman  :  unsigned(4 downto 0);


     --POSICON PACMAN  
      COMPONENT PosicionPACman is
            port  (
            clk_25: in std_logic; --el clk1_0 del pll
            btn0: in std_logic;
            btn1: in std_logic;
            btn2: in std_logic;
            btn3: in std_logic;
            rst: in std_logic;
            --para ver las cuentas pero no haria falta
            FilasPacman      : out unsigned(4 downto 0); 
            ColumnasPacman   : out unsigned(4 downto 0)
            );   
        end component;  
          

begin

    --POSICON PACMA 
         CELDAPACMAN : PosicionPACman 
            port map  (
            clk_25 =>sclk_25, --el clk1_0 del pll
            btn0 =>Sbtn0 ,
            btn1 =>Sbtn1,
            btn2 =>Sbtn2 ,
            btn3 =>Sbtn3 ,
            rst=> srst,
            --para ver las cuentas pero no haria falta
            FilasPacman =>sFilasPacman, 
            ColumnasPacman => sColumnasPacman
            );   



     process
        begin
           
           sclk_25 <= '1';
           wait for 8 ns / 2; -- Esperar medio periodo 
           sclk_25 <= '0';
           wait for 8 ns / 2; -- Esperar medio periodo 
   
   end process;
    srst <= '1', '0' after 20ns;

    
  sbtn0 <= '0', '1' after 100ns, '0' after 110 ns , '1' after 650 ns;
  sbtn1 <= '0', '1' after 410ns, '0' after 420 ns , '1' after 650 ns;
  sbtn2 <= '0', '1' after 100ns, '0' after 110 ns , '1' after 1000 ns;
  sbtn3 <= '0', '1' after 410ns, '0' after 420 ns , '1' after 1000 ns;
    

end Behavioral;
