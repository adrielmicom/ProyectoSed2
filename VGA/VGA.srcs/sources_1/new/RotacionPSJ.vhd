----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2024 18:01:52
-- Design Name: 
-- Module Name: RotacionPSJ - Behavioral
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

entity RotacionPSJ is
--  Port ( );
  Port (
        clk_25 : in STD_LOGIC;
        btn0: in std_logic;
        btn1: in std_logic;
        btn2: in std_logic;
        btn3: in std_logic;
        PSJ : in std_logic_vector(3 downto 0) ;  --diferenciar pacman ghost
        filas : in std_logic_vector(3 downto 0);   
        columnas : in std_logic_vector(3 downto 0); 
        btns: out std_logic_vector(3 downto 0); 
        drres: out std_logic_vector(8-1 downto 0)
        );    

--cost psj
--fila sincro vga de 3 a 0
--columna vga
--saco ddres sincro vga de 3 a 0  manipulada
end RotacionPSJ;
architecture Behavioral of RotacionPSJ is

signal sbtns: std_logic_vector(3 downto 0); -- Vector de 4 bits para almacenar los botones

begin

process(clk_25,btn0, btn1, btn2, btn3)
    begin
    btns<=sbtns;
    if PSJ="0011" then
        sbtns <= btn3 & btn2 & btn1 & btn0; -- Concatenar de más significativo a menos significativo
        case sbtns is
        
            when "0001" => -- Solo btn0 está presionado derecha   --filas not columnas   
                drres <= PSJ & filas;
            when "0010" => -- Solo btn1 está presionado izqu
                drres <= PSJ & filas; --
            when "0100" => -- Solo btn2 está presionado  abajo
                drres <= PSJ & columnas; 
            when "1000" => -- Solo btn3 está presionado   arriba 
                drres <= PSJ & columnas;-- Acción cuando btn3 está presionado
            when others =>                      --quieto
                drres <= PSJ & not(filas);
               --drres <= PSJ & filas(3 downto 0); -- Acción por defecto (quieto)
            end case;

    else
    drres <= PSJ & filas(3 downto 0);
    end if;

end process;

end Behavioral;
