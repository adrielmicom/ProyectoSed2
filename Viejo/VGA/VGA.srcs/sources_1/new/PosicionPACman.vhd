----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2024 15:54:40
-- Design Name: 
-- Module Name: PosicionPACman - Behavioral
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
library xil_defaultlib;
use xil_defaultlib.racetrack_pkg.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PosicionPACman is
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
end PosicionPACman;

architecture Behavioral of PosicionPACman is

--signal
signal s_fc_100ms : std_logic; 
signal s_fc_500ms : std_logic;

signal S_EnCols : std_logic;
signal S_Enfils : std_logic;

signal S_ColsUP : std_logic;
signal S_filsUP : std_logic;

signal s_ConteoCols: std_logic_vector(4 downto 0);
signal s_Conteofils: std_logic_vector(4 downto 0);

signal s_fc_cols : std_logic;
signal s_fc_fils : std_logic;

signal jug_en_pista : std_logic;
--component
                                    
component ContadorUp_Down is
     generic(
        N_BITS : integer := 5; 
        MAX_VALOR : integer := 32 
 );
     port (
        en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        Up_Conta: in std_logic;
        cuenta : out std_logic_vector(N_BITS-1 downto 0);
        f_cuenta : out std_logic 
 );
             
  end component; 

begin

process(clk_25,rst)
begin
    -- Asegurarse de que el proceso esté sincronizado con el reloj
    if(rst='1') then
        S_Enfils <= '0';
        S_EnCols <= '0';
        S_filsUP <= '0';
        S_ColsUP <= '0';
    
    elsif rising_edge(clk_25) then
        S_Enfils <= '0';
        S_EnCols <= '0';
        -- enable
        if jug_en_pista ='1' then 
        
          if (s_fc_100ms = '1') then
               if (btn3 = '1' or btn2 = '1')  then 
                   S_Enfils <= '1';
               end if;
               
               if (btn1 = '1' or btn0 = '1') then
                   S_EnCols <= '1';
               end if;  
     
            -- conteo up o down
               if (btn2 = '1') then
                   S_filsUP <= '1';
               elsif (btn3 = '1') then
                   S_filsUP <= '0';
               end if;

               if (btn0 = '1') then
                   S_ColsUP <= '1';
               elsif (btn1 = '1') then
                   S_ColsUP <= '0';
               end if;
            end if;
       else 
             if (s_fc_500ms = '1' and s_fc_100ms='1') then  
                 if (btn3 = '1' or btn2 = '1')  then 
                     S_Enfils <= '1';
                 end if;
                 
                 if (btn1 = '1' or btn0 = '1') then
                     S_EnCols <= '1';
                 end if;  
 
             -- conteo up o down
                 if (btn2 = '1') then
                     S_filsUP <= '1';
                 elsif (btn3 = '1') then
                     S_filsUP <= '0';
                 end if;

                 if (btn0 = '1') then
                     S_ColsUP <= '1';
                 elsif (btn1 = '1') then
                     S_ColsUP <= '0';
                 end if;
             end if;
             end if;
   end if;  
  end process;


       --instantacion
       ContCols : ContadorUp_Down   
       generic map (
          MAX_VALOR => 32---33   ---LO TENIA QUITADO PORQUE GENERICO A 32
        )                   
        port map (               
          en    => S_EnCols,   
          clk    => clk_25,   
          rst  => rst,
          Up_Conta=>S_ColsUP, 
          cuenta  =>  s_conteocols,
          f_cuenta     =>  s_fc_cols    
        );   
        
        Contfils : ContadorUp_Down                     
       generic map (
          MAX_VALOR =>30-- 29   ---estaba a 30 
        )
                                       
        port map (               
          en    => s_EnFils,   
          clk    => clk_25,   
          rst  => rst,
          Up_Conta=>S_filsUP, 
          cuenta =>  s_conteofils,
          f_cuenta =>  s_fc_fils    
        );   

        ColumnasPacman <= unsigned(s_conteocols);
        FilasPacman <= unsigned(s_conteofils);


   
       Cont100ms: ContadorUp_Down                     
       generic map (
          N_BITS =>  22,  --podria quitarlo
          MAX_VALOR =>2500000---  necesito  2500000 para los 100ms para tb 30
        )                                    
        port map (               
          en    => '1',   
          clk    => clk_25,   
          rst  =>  rst,
          Up_Conta=>'1', 
          cuenta =>open,
          f_cuenta => s_fc_100ms   
        );   
        
        
       Cont500ms: ContadorUp_Down                     
       generic map (
          N_BITS =>  3,  --podria quitarlo
          MAX_VALOR =>5---  necesito  2500000 para los 100ms para tb 30
        )                                    
        port map (               
          en    => s_fc_100ms,   
          clk    => clk_25,   
          rst  =>  rst,
          Up_Conta=>'1', 
          cuenta =>open,
          f_cuenta =>s_fc_500ms   
        );   

jug_en_pista <= pista(to_integer(unsigned(s_conteofils)))(to_integer( unsigned(s_conteocols)));

end Behavioral;
