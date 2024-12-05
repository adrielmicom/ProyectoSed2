----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2024 21:01:50
-- Design Name: 
-- Module Name: MEghost - Behavioral
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

entity MEghost is
  Port (
        en : std_logic;
        rst : in STD_LOGIC;
        clk_25 : in STD_LOGIC;
        FilasGhost     : out unsigned(4 downto 0); 
        ColumnasGhost  : out unsigned(4 downto 0)
        );        
end MEghost;

architecture Behavioral of MEghost is


--signal
signal s_fc_100ms : std_logic; 

signal S_ColsUP : std_logic;
signal S_filsUP : std_logic;

signal s_ConteoCols: std_logic_vector(4 downto 0);
signal s_Conteofils: std_logic_vector(4 downto 0);

signal s_fc_cols : std_logic;
signal s_fc_fils : std_logic;
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


type estados_Ghost is (Dig1,Dig2,Dig3,Dig4);
    signal e_act, e_sig : estados_ghost;

begin
P_SEQ_FSM: Process (rst, s_fc_100ms)
    begin
        if rst = '1' then
            e_act <= Dig1;
        elsif s_fc_100ms'event and s_fc_100ms='1' then
             if en = '1' then              
             e_act <= e_sig;             -- el estado siguiente sera nuestro estado actual
             end if;              
        end if;
end process;

P_COMB_FSM: Process (e_act,s_ConteoCols,s_Conteofils)
begin
    e_sig <= e_act;
    case e_act is
    when Dig1 =>
        if unsigned(s_ConteoCols) = 1 then --0---if col = to_unsigned(0,col'length) then
        e_sig <= dig2;
        elsif unsigned(s_Conteofils) = 1 then --0
        e_sig <= dig4;
        end if;
    when Dig2 =>
        if unsigned(s_ConteoCols) = 30 then --31 ---if col = to_unsigned(0,col'length) then
        e_sig <= dig1;
        elsif unsigned(s_Conteofils) = 1 then --0
        e_sig <= dig3;
        end if;
        
    when Dig3 =>
        if unsigned(s_ConteoCols) = 31 then --30---if col = to_unsigned(0,col'length) then
        e_sig <= dig4;
        elsif unsigned(s_Conteofils) = 28 then --29
        e_sig <= dig2;
        end if;

    when Dig4 =>
        if unsigned(s_ConteoCols) = 1 then --0---if col = to_unsigned(0,col'length) then
        e_sig <= dig3;
        elsif unsigned(s_Conteofils) = 28 then --29
        e_sig <= dig1;
        end if;     
    end case;
end process;

SALIDAS: Process (e_act) --,s_fc_100ms
begin
    --if s_fc_100ms'event and s_fc_100ms='1' then
    case e_act is
    when Dig1 =>
        S_filsUP <= '0';
        S_ColsUP <= '0';
    when Dig2 =>
        S_filsUP <= '0';
        S_ColsUP <= '1';
    when Dig3 =>
        S_filsUP <= '1';
        S_ColsUP <= '1';
    when Dig4 =>
        S_filsUP <= '1';
        S_ColsUP <= '0';
    end case;
  --  end if;
end process;


 --contadores  
       Cont100ms: ContadorUp_Down                     
       generic map (
          N_BITS =>  22,  --podria quitarlo 22
          MAX_VALOR =>2500000---  necesito  2500000 para los 100ms para tb 30
        )                                    
        port map (               
          en    => '1',   
          clk    => clk_25,   
          rst  =>  rst,
          Up_Conta=>'1', 
          cuenta =>open,
          f_cuenta =>  s_fc_100ms   
        );   

      ContCols : ContadorUp_Down                      
        port map (               
          en    => '1',   
          clk    => s_fc_100ms,   
          rst  => rst,
          Up_Conta=>S_ColsUP, 
          cuenta  =>  s_conteocols,
          f_cuenta     =>  s_fc_cols    
        );   
        
        Contfils : ContadorUp_Down                     
       generic map (
          MAX_VALOR => 30
        )
                                       
        port map (               
          en    => '1',
          clk    => s_fc_100ms,   
          rst  => rst,
          Up_Conta=>S_filsUP, 
          cuenta =>  s_conteofils,
          f_cuenta =>  s_fc_fils    
        );   

        ColumnasGhost <= unsigned(s_conteocols);
        FilasGhost <= unsigned(s_conteofils);


end Behavioral;
