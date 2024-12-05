----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2024 20:44:03
-- Design Name: 
-- Module Name: Top_VGA - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity Top_VGA is
 port (
        clk : in std_logic;
        rst : in std_logic;
        datap : out std_logic_vector(2 downto 0);
        dataN : out std_logic_vector(2 downto 0);
        ClkN : out std_logic;
        ClkP: out std_logic;
        btn0: in std_logic;
        btn1: in std_logic;
        btn2: in std_logic;
        btn3: in std_logic
               
);

end Top_VGA;
architecture Behavioral of Top_VGA is


--signal
 -- signal fan_fila: unsigned (5 downto 0) :="000101";
 -- signal fan_col: unsigned (5 downto 0) :="000101";
 -- signal pac_fila: unsigned (5 downto 0) :="000101";
 -- signal pac_col: unsigned (5 downto 0) :="000101";
  
 --desconocido uso ??  signal fan_fila: unsigned (5 downto 0) :="000101";
 --desconocido uso ??  signal fan_col: unsigned (5 downto 0) :="000101";
 --desconocido uso ??  signal pac_fila: unsigned (9 downto 0) :="0000000101";
 --desconocido uso ??  signal pac_col: unsigned (9 downto 0) :="0000000101";
    
   signal vdatargb: std_logic_vector( 23 downto 0 );

   signal filas_s : std_logic_vector(9 downto 0);   
   signal columnas_s : std_logic_vector(9 downto 0);  
   signal Visible_s : std_logic;
   signal Hsync_S:std_logic;  
   signal Vsync_S : std_logic; 

    signal clk_125M:std_logic;
    signal clk_25M:std_logic;
    
    --SENALES POSCON PACMA
    SIGNAL s_FilasPacman : unsigned(4 downto 0);
    signal s_ColumnasPacman : unsigned(4 downto 0);
    
    --SENALES POSCON GHOST
    SIGNAL s_FilasGhost : unsigned(4 downto 0);
    signal s_ColumnasGhost : unsigned(4 downto 0);
    
    --señales union con memoria
    signal sPSJ :std_logic_vector(3 downto 0) ;
    signal sdin :std_logic_vector(16-1 downto 0); 
    signal sdinG :std_logic_vector(16-1 downto 0);
    signal sdinB :std_logic_vector(16-1 downto 0);
    signal sdinR :std_logic_vector(16-1 downto 0);
    signal sdrres :  std_logic_vector(8-1 downto 0);
    signal sdinMapa: std_logic_vector(32-1 downto 0);
    signal sdinMapaGreen: std_logic_vector(32-1 downto 0);
    signal sdinMapaBlue: std_logic_vector(32-1 downto 0);
    
    signal sbtns: std_logic_vector(3 downto 0);--rotacionpsj
--component
    --pll
    
        component clock_gen is
            generic (
        CLKIN_PERIOD : real := 8.000; -- input clock period (8ns)
        CLK_MULTIPLY : integer := 8; -- multiplier
        CLK_DIVIDE : integer := 1; -- divider
        CLKOUT0_DIV : integer := 8; -- serial clock divider
        CLKOUT1_DIV : integer := 40 -- pixel clock divider
        );
            port(
        rst: in std_logic;
        clk_i : in std_logic; -- input clock
        clk0_o : out std_logic; -- serial clock
        clk1_o : out std_logic -- pixel clock
        );
        end component;
        
    --SYNC VGA
    
        COMPONENT sync_vga is 
        port (
            clk_25 : in std_logic;
            rst : in std_logic;
            fils : out std_logic_vector(9 downto 0);
            cols : out std_logic_vector(9 downto 0);
            Visible : out std_logic;
            Hsync: out std_logic;
            Vsync: out std_logic
         );
        END component;
    
    --PINTA
    
        component pinta_barras is
        Port (
          -- In ports
          visible      : in std_logic;
          col          : in unsigned(10-1 downto 0);
          fila         : in unsigned(10-1 downto 0);
          FilasPacman      : in unsigned(4 downto 0); 
          ColumnasPacman   : in unsigned(4 downto 0);
          FilasGhost     : in unsigned(4 downto 0); 
          ColumnasGhost  : in unsigned(4 downto 0);
          din : in std_logic_vector(16-1 downto 0);  --Entrada memoria personajes --sin uso al tener los colores
          dinb : in std_logic_vector(16-1 downto 0);
          ding : in std_logic_vector(16-1 downto 0);
          dinr : in std_logic_vector(16-1 downto 0); 
          dinMapa: in std_logic_vector(32-1 downto 0);
          dinMapaGreen: in std_logic_vector(32-1 downto 0);
          dinMapaBlue: in std_logic_vector(32-1 downto 0);
          
          btns: in std_logic_vector(3 downto 0); --botones
        -- Out ports
         -- drres        : out std_logic_vector(8-1 downto 0);
          PSJ : out std_logic_vector(3 downto 0) ;
          rojo         : out std_logic_vector(8-1 downto 0);
          verde        : out std_logic_vector(8-1 downto 0);
          azul         : out std_logic_vector(8-1 downto 0)
        );
        end component;
        
    --hdmi
    
        component hdmi_rgb2tmds is
        generic (
            SERIES6 : boolean := false
        );
        port(
            -- reset and clocks
            rst : in std_logic;
            pixelclock : in std_logic;  -- slow pixel clock 1x
            serialclock : in std_logic; -- fast serial clock 5x

            -- video signals
            video_data : in std_logic_vector(23 downto 0);
            video_active  : in std_logic;
            hsync : in std_logic;
            vsync : in std_logic;

            -- tmds output ports
            clk_p : out std_logic;
            clk_n : out std_logic;
            data_p : out std_logic_vector(2 downto 0);
            data_n : out std_logic_vector(2 downto 0)
        );
        end component;    
      
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
        
 --rotacion pacman
         component RotacionPSJ is
         Port (
               clk_25 : in STD_LOGIC;
               btn0: in std_logic;
               btn1: in std_logic;
               btn2: in std_logic;
               btn3: in std_logic;
               PSJ : in std_logic_vector(3 downto 0) ;  --diferenciar pacman ghost
               filas : in std_logic_vector(3 downto 0);   
               columnas :in  std_logic_vector(3 downto 0);
               btns: out std_logic_vector(3 downto 0);  
               drres: out std_logic_vector(8-1 downto 0)
               );    
        end component;
        
        
         
       --POSICION GHOST
       
       COMPONENT MEghost is
            Port (
            en : in std_logic;
            rst : in STD_LOGIC;
            clk_25 : in STD_LOGIC;
            FilasGhost     : out unsigned(4 downto 0); 
            ColumnasGhost  : out unsigned(4 downto 0)
            );        
        end component;   
          
 --MEMORIAS      --memoria 1 PSJ blanco negro sin uso cuando es a color
        COMPONENT ROM1b_1f_imagenes16_16x16_bn is
          port (
            clk  : in  std_logic;   -- reloj
            addr : in  std_logic_vector(8-1 downto 0);   --memoria hito2.3 tiene 16 filas 4 bits
            dout : out std_logic_vector(16-1 downto 0) 
          );
        end component;  
        
        --blue psj memoria
        Component ROM1b_1f_blue_imagenes16_16x16 is
        port (
          clk  : in  std_logic;   -- reloj
          addr : in  std_logic_vector(8-1 downto 0);
          dout : out std_logic_vector(16-1 downto 0) 
        );
        end component;
        
        --green psj memorai
         component ROM1b_1f_green_imagenes16_16x16 is
         port (
           clk  : in  std_logic;   -- reloj
           addr : in  std_logic_vector(8-1 downto 0);
           dout : out std_logic_vector(16-1 downto 0) 
         );
        end component;

        --roja psj memoria
         component ROM1b_1f_red_imagenes16_16x16 is
         port (
            clk  : in  std_logic;   -- reloj
            addr : in  std_logic_vector(8-1 downto 0);
            dout : out std_logic_vector(16-1 downto 0) 
          );
        end component ROM1b_1f_red_imagenes16_16x16;
        
--memorias  MAPAs
       
        COMPONENT ROM1b_1f_racetrack_1 is
         port (
           clk  : in  std_logic;   -- reloj
           addr : in  std_logic_vector(5-1 downto 0);
           dout : out std_logic_vector(32-1 downto 0) 
         );
       end component;
       
      component ROM1b_1f_green_racetrack_1 is
          port (
            clk  : in  std_logic;   -- reloj
            addr : in  std_logic_vector(5-1 downto 0);
            dout : out std_logic_vector(32-1 downto 0) 
          );
        end Component;
           
       Component ROM1b_1f_blue_racetrack_1 is
          port (
            clk  : in  std_logic;   -- reloj
            addr : in  std_logic_vector(5-1 downto 0);
            dout : out std_logic_vector(32-1 downto 0) 
          );
        end component;
               
     
begin

--PLL 
    PLL: clock_gen 
    port map(
    rst =>rst,
    clk_i =>clk , -- input clock
    clk0_o => clk_125M , -- serial clock
    clk1_o => clk_25M   -- pixel clock
    );


--SYNC VGA
        SYNCVGA: sync_vga 
        port MAP (
            clk_25 =>clk_25m,
            rst    =>rst,
            fils   =>filas_s,
            cols   =>columnas_s,
            Visible=> visible_s,
            Hsync  =>hsync_s,
            Vsync  =>vsync_s
         );  
 
--PINTA

            
        PINTAc: pinta_barras 
        Port map (
          -- In ports
          visible      =>visible_s,
          col          =>unsigned(columnas_s),
          fila         =>unsigned(filas_s),
          FilasPacman    =>s_FilasPacman , 
          ColumnasPacman =>s_ColumnasPacman,
          FilasGhost     =>s_FilasGhost,
          ColumnasGhost  =>s_ColumnasGhost,
          din=>sdin, 
          dinb=>sdinb,
          ding=>sding,
          dinr=>sdinr,
          dinmapa=>sdinmapa,
          dinMapaGreen =>sdinmapaGreen,
          dinMapaBlue  =>sdinmapaBlue,
          
          btns=>sbtns, --botones
          -- Out ports
          
          --drres=>sdrres,
          PSJ =>sPSJ,
          rojo         =>Vdatargb(23 downto 16),
          verde        =>Vdatargb(15 downto 8),
          azul         =>Vdatargb(7 downto 0)
        );

   
  --hdmi
         HDMI:hdmi_rgb2tmds 
        port map(
            -- reset and clocks
            rst        =>rst,
            pixelclock =>clk_25m, -- slow pixel clock 1x
            serialclock=>clk_125m,-- fast serial clock 5x

            -- video signals
            video_data   =>VdataRGB,
            video_active =>visible_S,
            hsync        =>hsync_s,
            vsync        =>vsync_s,

            -- tmds output ports
            clk_p  =>clkP,
            clk_n  =>clkN,
            data_p =>dataP,
            data_n =>dataN
        );

    --POSICON PACMA 
         CELDAPACMAN : PosicionPACman 
            port map  (
            clk_25 =>clk_25M, --el clk1_0 del pll
            btn0 =>btn0 ,
            btn1 =>btn1,
            btn2 =>btn2 ,
            btn3 =>btn3 ,
            rst=> rst,
            --para ver las cuentas pero no haria falta
            FilasPacman =>s_FilasPacman, 
            ColumnasPacman => s_ColumnasPacman
            );   
--rotacion pacman

         RTCPSJ : RotacionPSJ 
              port map  (
               clk_25  =>clk_25M,
               btn0    =>btn0,
               btn1    =>btn1,
               btn2    =>btn2,
               btn3    =>btn3,
               PSJ     =>sPSJ,
               filas   =>filas_s(3 downto 0),
               columnas=>columnas_s(3 downto 0),
               btns=>sbtns,
               drres   =>sdrres
               );   

        


    --POSICON GHOST
         CeldaGHOST: MEghost 
            Port map (   
            en =>'1',
            rst           =>rst,
            clk_25        =>clk_25M,
            FilasGhost    =>s_FilasGhost,
            ColumnasGhost =>s_ColumnasGhost
            );        

--MEMORIAS

     --Memoria 1 PSJ SIN USO AL TENER LAS DE COLOR
     --sdrres <= sPSJ & filas_s(3 downto 0);
     
         MemoriaPSJ: ROM1b_1f_imagenes16_16x16_bn 
          port map (
            clk  =>clk_25M,
            addr =>sdrres, --memoria hito2.3 tiene 16 filas 4 bits
            dout => sdin 
          ); 
        
        --blue psj memoria
        MemoriaPSJblue: ROM1b_1f_blue_imagenes16_16x16 
          port map (
            clk  =>clk_25M,
            addr =>sdrres, 
            dout => sdinb 
          ); 

        
        --green psj memorai
         MemoriaPSJgreen: ROM1b_1f_green_imagenes16_16x16 
          port map (
            clk  =>clk_25M,
            addr =>sdrres, 
            dout => sding 
          ); 

        --roja psj memoria
         cMemoriaPSJred: ROM1b_1f_red_imagenes16_16x16 
          port map (
            clk  =>clk_25M,
            addr =>sdrres, 
            dout => sdinr
          ); 
        
          
          
          
--drres <= PacMemori & std_logic_vector(SfilsBitmenos);

   --MEMORIAs  MAPAs       
        MemoriaMap: ROM1b_1f_racetrack_1
         port map(
           clk  =>clk_25M,
           addr =>filas_s(8 downto 4),
           dout =>sdinmapa
         );
       
      MemoriaMapGreen: ROM1b_1f_green_racetrack_1 
          port map (
            clk  =>clk_25M,
            addr =>filas_s(8 downto 4),
            dout =>sdinmapaGreen
          );
          
      MemoriaMapBlue: ROM1b_1f_blue_racetrack_1
          port map (
            clk  =>clk_25M,               
            addr =>filas_s(8 downto 4),   
            dout =>sdinmapaBlue
          );


end Behavioral;
