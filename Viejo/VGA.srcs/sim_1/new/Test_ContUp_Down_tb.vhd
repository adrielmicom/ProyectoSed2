----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2024 11:00:08
-- Design Name: 
-- Module Name: Test_ContUp_Down_tb - Behavioral
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

entity Test_ContUp_Down_tb is
--  Port ( );
end Test_ContUp_Down_tb;

architecture Behavioral of Test_ContUp_Down_tb is

signal s_en : std_logic := '0';
signal s_clk : std_logic := '0';
signal s_rst : std_logic := '0';
signal s_Up_Conta: std_logic := '0';
signal s_cuenta : std_logic_vector(7 downto 0) := (others => '0');
signal s_f_cuenta : std_logic := '0'; 

signal s2_en : std_logic := '0';
signal s2_clk : std_logic := '0';
signal s2_rst : std_logic := '0';
signal s2_cuenta : std_logic_vector(7 downto 0) := (others => '0');
signal s2_f_cuenta : std_logic := '0'; 

constant clk_period : time := 8 ns;  --1seg 10**6
 
 --COMPONENTES     declaracion
                                     
component ContadorUp_Down is
     generic(
        N_BITS : integer := 10; 
        MAX_VALOR : integer := 10 
 );
     port (
        en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        Up_Conta: in std_logic;
        cuenta : out std_logic_vector(N_BITS-1downto 0);
        f_cuenta : out std_logic 
 );
             
  end component; 
   
begin
       --instantacion
       U1 : ContadorUp_Down
        generic map (
          N_BITS =>  10, 
          MAX_VALOR => 10
        )
                            
        port map (               
          en    => s_en,   
          clk    => s_clk,   
          rst  =>  s_rst,
          Up_Conta=>s_Up_Conta, 
          cuenta  =>  s_cuenta,
          f_cuenta     =>  s_f_cuenta    
        );                       

--     U2 : Contador                    
--       port map (               
--         en    => s2_en,   
--         clk    => s_clk,   
--         rst  =>  s2_rst, 
--         cuenta  =>  s2_cuenta,
--         f_cuenta =>  s2_f_cuenta    
--       );   
   
        
      --ESTIMULOS
      
     process
        begin

           s_clk <= '1';
           wait for 8 ns / 2; -- Esperar medio periodo 
           s_clk <= '0';
           wait for 8 ns / 2; -- Esperar medio periodo 
   
   end process;

-- Generador de reloj
 --   process
 --   begin
 --       while true loop
 --           s_clk <= '1';
 --           wait for clk_period / 2; -- Esperar medio periodo 
 --           s_clk <= '0';
 --           wait for clk_period / 2; -- Esperar medio periodo 
 --       end loop;
 --   end process;

    -- Inicialización de señales y estímulos
--   process
--   begin
       -- Inicializar señales

       s_en <= '0', '1' after 50 ns;
       s_Up_Conta <= '0', '1' after 100ns;
--       s2_en <= '0', '1' after 100 ns;
--       s_rst <= '1';
--       s2_en <= '0';
 --      s2_rst <= '0', '1' after 150 ns;
--       
--       wait for 2 * clk_period; -- Esperar un tiempo antes de cambiar el reset
--
--       s_rst <= '0'; -- Desactivar reset
--       s2_rst <= '0'; -- Desactivar reset para el segundo contador
--       s_en <= '1'; -- Habilitar el primer contador
--       s2_en <= '1'; -- Habilitar el segundo contador
--
--       wait; -- Terminar el proceso de estímulos
--   end process;


end Behavioral;