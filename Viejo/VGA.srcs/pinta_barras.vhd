--------------------------------------------------------------------------------
-- Felipe Machado Sanchez
-- Departameto de Tecnologia Electronica
-- Universidad Rey Juan Carlos
-- http://gtebim.es/~fmachado
--
-- Pinta barras para la XUPV2P

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pinta_barras is
  Port (
    -- In ports
    visible      : in std_logic;
    col          : in unsigned(10-1 downto 0);
    fila         : in unsigned(10-1 downto 0);
    FilasPacman      : in unsigned(4 downto 0); 
    ColumnasPacman   : in unsigned(4 downto 0);
    
    FilasGhost     : in unsigned(4 downto 0); 
    ColumnasGhost  : in unsigned(4 downto 0);
    
    din : in std_logic_vector(16-1 downto 0); --Entrada memoria personajes --sin uso al tener los colores
    dinb : in std_logic_vector(16-1 downto 0);
    ding : in std_logic_vector(16-1 downto 0);
    dinr : in std_logic_vector(16-1 downto 0);
    dinMapa: in std_logic_vector(32-1 downto 0);
    dinMapaGreen: in std_logic_vector(32-1 downto 0);
    dinMapaBlue: in std_logic_vector(32-1 downto 0);
    
    btns: in std_logic_vector(3 downto 0); --botones
    -- Out ports
    -- BORRAR int_fila: out std_logic_vector(4-1 downto 0);  --Me permite ir recorriendo la casilla de la memoria del personaje correspondiente
    PSJ : out std_logic_vector(3 downto 0) ;
    rojo         : out std_logic_vector(8-1 downto 0);
    verde        : out std_logic_vector(8-1 downto 0);
    azul         : out std_logic_vector(8-1 downto 0)
  );
end pinta_barras;

architecture behavioral of pinta_barras is

--constant c_bar_width : natural := 64;
signal pacman_fila : unsigned(4 downto 0);  -- de 0 a 29
signal pacman_col  : unsigned(4 downto 0);   -- de 0 a 31  

signal ghost_fila : unsigned(4 downto 0);  -- de 0 a 29
signal ghost_col  : unsigned(4 downto 0);   -- de 0 a 31  


-- signal SVfils : std_logic_vector(3 downto 0);
-- signal SVcols : std_logic_vector(3 downto 0);
--
-- Para los multiplos de 0 16 23 ...
 signal SfilsBitmenos :unsigned(3 downto 0); --bits menos significativos
 signal ScolsBitmenos :unsigned(3 downto 0);
 
 signal SfilsBitmas :unsigned(5 downto 0); --bits menos significativos
 signal ScolsBitmas :unsigned(5 downto 0);
 
 --signal pixel : integer range 0 to 1;
 signal pixel : std_logic;

begin

pacman_fila <= FilasPacman;
pacman_col <= ColumnasPacman;

ghost_fila<= FilasGhost;
ghost_col <= ColumnasGhost;
--- MIO 
--menos significativos para recorrer dentro de las cuadriculas
SfilsBitmenos <= unsigned(fila(3 downto 0));  --int fils 
ScolsBitmenos <= unsigned(col(3 downto 0));    -- int cols

--mas significativos me definen las cuadriculas
SfilsBitmas <= unsigned(fila(9 downto 4));  --cuad fils
ScolsBitmas <= unsigned(col(9 downto 4));   --cuad cols

--BORRAR  Para pasar a memoria
--BORRAR int_fila <= std_logic_vector(SfilsBitmenos);

 P_pinta: Process (visible, col, fila)
 begin
      
   rojo   <= (others=>'0');
   verde  <= (others=>'0');
   azul   <= (others=>'0');
   
  if visible = '1' then

        -- una linea blanca en los bordes
        if col > 512 then   
            azul   <= (others=>'0');
            verde <= (others=>'0');
            rojo  <= (others=>'0');
--psj   a color    
 --       elsif ScolsBitmas = pacman_col  and SfilsBitmas = pacman_fila then      
 --             PSJ<="0011";
 --             if dinb(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'1');
 --                  verde <= (others=>'0');
 --                  rojo  <= (others=>'0');  
 --             elsif ding(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'1');
 --                  rojo  <= (others=>'0'); 
 --             elsif dinr(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'0');                    
 --                  rojo  <= (others=>'1');
 --             else
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'0');
 --                  rojo  <= (others=>'0');  
 --             end if;
 --             
 --       elsif ScolsBitmas = ghost_col  and SfilsBitmas = ghost_fila then
 --             PSJ<="0100";      
 --             if dinb(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'1');
 --                  verde <= (others=>'0');
 --                  rojo  <= (others=>'0'); 
 --             elsif ding(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'1');
 --                  rojo  <= (others=>'0'); 
 --             elsif dinr(TO_INTEGER(ScolsBitmenos))='1' then
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'0');                    
 --                  rojo  <= (others=>'1');
 --             else
 --                  azul   <=(others=>'0');
 --                  verde <= (others=>'0');
 --                  rojo  <= (others=>'0');   
 --             end if;  
   --MAPA COLOR                 
        else
           if dinmapaGreen(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
                if dinmapa(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
                     azul   <= (others=>'1');
                     verde <=  (others=>'1');
                     rojo  <=  (others=>'1');
                else
                     azul   <= (others=>'0');
                     verde <=  (others=>'1');
                     rojo  <=  (others=>'0');                
                end if;
            
            elsif dinmapaBlue(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
                azul   <= (others=>'1');
                verde <=  (others=>'0');
                rojo  <=  (others=>'0');              
            else
                azul   <= (others=>'0');
                verde <=  (others=>'0');
                rojo  <=  (others=>'1');            
            end if;
            
--PSJ a color
           if ScolsBitmas = pacman_col  and SfilsBitmas = pacman_fila then      
              PSJ<="0011";
               case btns is
        
               when "0001" => -- Solo btn0 está presionado derecha
                  if dinb(TO_INTEGER(not(ScolsBitmenos)))='0' then
                  azul   <=(others=>'0');
                  verde <= (others=>'1');
                  rojo  <= (others=>'1');
                  end if;                     
               when "0010" => -- Solo btn1 está presionado izqu
                  if dinb(TO_INTEGER(ScolsBitmenos))='0' then
                  azul   <=(others=>'0');
                  verde <= (others=>'1');
                  rojo  <= (others=>'1');
                  end if;                      
               when "0100" => -- Solo btn2 está presionado  abajo
                  if dinb(TO_INTEGER(not(SfilsBitmenos)))='0' then
                  azul   <=(others=>'0');
                  verde <= (others=>'1');
                  rojo  <= (others=>'1');
                  end if;                       
               when "1000" => -- Solo btn3 está presionado   arriba 
                  if dinb(TO_INTEGER(SfilsBitmenos))='0' then
                  azul   <=(others=>'0');
                  verde <= (others=>'1');
                  rojo  <= (others=>'1');
                  end if;                      
                                      
               when others =>                      --quieto
                  if dinb(TO_INTEGER(not(ScolsBitmenos)))='0' then
                  azul   <=(others=>'0');
                  verde <= (others=>'1');
                  rojo  <= (others=>'1');
                  end if;   
               end case;
              
           end if;  
                        
           if ScolsBitmas = ghost_col  and SfilsBitmas = ghost_fila then
              PSJ<="0100"; 
              if dinb(TO_INTEGER(ScolsBitmenos))='1' and ding(TO_INTEGER(ScolsBitmenos))='1' and dinr(TO_INTEGER(ScolsBitmenos))='1' then  
        --        if dinmapaGreen(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
        --        if dinmapa(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
        --             azul   <= (others=>'1');
        --             verde <=  (others=>'1');
        --             rojo  <=  (others=>'1');
        --        else
        --             azul   <= (others=>'0');
        --             verde <=  (others=>'1');
        --             rojo  <=  (others=>'0');                
        --        end if;
        --    
        --    elsif dinmapaBlue(TO_INTEGER(unsigned(col(8 downto 4))))='1' then
        --        azul   <= (others=>'1');
        --        verde <=  (others=>'0');
        --        rojo  <=  (others=>'0');              
        --    else
        --        azul   <= (others=>'0');
        --        verde <=  (others=>'0');
        --        rojo  <=  (others=>'1');            
        --    end if;
              else
                    if dinb(TO_INTEGER(ScolsBitmenos))='0' then
                        azul   <=(others=>'1');
                        verde <= (others=>'0');
                        rojo  <= (others=>'0');
                        -- else
                        -- azul <=(others=>'0');
                    end if;
                   if ding(TO_INTEGER(ScolsBitmenos))='0'and dinr(TO_INTEGER(ScolsBitmenos))='0' then
                        azul   <=(others=>'0');
                        verde <= (others=>'0');
                        rojo  <= (others=>'1');
                    end if;
                  
                  -- if ding(TO_INTEGER(ScolsBitmenos))='1' then
                  --      verde <= (others=>'1');
                  --      else
                  --      verde<=(others=>'0');                    
                  -- end if;
                  -- if dinr(TO_INTEGER(ScolsBitmenos))='0' then
                  --      rojo  <= (others=>'1'); 
                  --      else
                  --      rojo <=(others=>'0');
                  -- end if;  
              end if;               
           end if; 
                -- VERSION BLANCO Y NEGRO
                             --- pinto mapa y rescalado   
                             --  pixel<= dinMapa(TO_INTEGER(unsigned(col(8 downto 4))));
                             --  azul   <= (others=>pixel);
                             --  verde <= (others=>pixel);
                             --  rojo  <= (others=>pixel);    
                             --personajes blaanco y negro
                             --      if ScolsBitmas = pacman_col  and SfilsBitmas = pacman_fila then      
                             --         PSJ<="0011";                                   
                             --          pixel<= din(TO_INTEGER(ScolsBitmenos));
                             --         -- if din(TO_INTEGER(ScolsBitmenos))='0' then
                             --          azul   <= (others=>'1');
                             --          verde <= (others=>'0');
                             --          rojo  <= (others=>'0');
                             --         -- end if;
                             --
                             --      end if;  
                             --        
                             --      if ScolsBitmas = ghost_col  and SfilsBitmas = ghost_fila then
                             --          PSJ<="0100";      
                             --          pixel<= din(TO_INTEGER(ScolsBitmenos));
                             --          azul   <= (others=>pixel);
                             --          verde <= (others=>pixel);
                             --          rojo  <= (others=>pixel);
                             --      end if;
  
  
   --cuadridula        
  --  elsif  SfilsBitmenos = 0 OR ScolsBitmenos = 0 then
  --      azul   <= (others=>'0');
  --      verde <= (others=>'0');
  --      rojo  <= (others=>'0');
  --      else
  --      verde <= (others=>'1');
  --      rojo  <= (others=>'1');
  --      azul   <= (others=>'1');
         
        end if;         
  end if;
  end process;




----LO DEL PROFE
---P_pinta: Process (visible, col, fila)
---begin
---  rojo   <= (others=>'0');
---  verde  <= (others=>'0');
---  azul   <= (others=>'0');
---  if visible = '1' then
---    -- una linea blanca en los bordes
---    if col = 0 OR col = 640 -1 OR
---      fila=0 OR fila= 480 -1 then
---      rojo   <= (others=>'1');
---      verde  <= (others=>'1');
---      azul   <= (others=>'1');
---    elsif fila >= 256 and fila < 256 + c_bar_width then 
---      -- esto solo tiene sentido para la XUPV2P
---      rojo   <= std_logic_vector(col(8-1 downto 0));
---      verde  <= std_logic_vector(col(8-1 downto 0));
---      azul   <= std_logic_vector(col(8-1 downto 0));
---      if col >= 256 then
---        rojo   <= std_logic_vector(col(8-1 downto 0));
---        verde  <= std_logic_vector(resize(255-col(7 downto 0),8));
---        azul   <= (others=>'0');
---      end if;
---      if col >= 512 then -- rayas horizontales
---        rojo   <= (others=>not(fila(0))); 
---        verde  <= (others=>not(fila(0))); 
---        azul   <= (others=>not(fila(0))); 
---      end if;
---    elsif fila >= 256+c_bar_width and fila < 256 + 2*c_bar_width then 
---      rojo   <= std_logic_vector(resize(255 - col(7 downto 0),8));
---      verde  <= std_logic_vector(resize(255 - col(7 downto 0),8));
---      azul   <= std_logic_vector(resize(255 - col(7 downto 0),8));
---      if col >= 256 then
---        rojo  <=std_logic_vector(resize(255 - col(7 downto 0),8)); 
---        verde <=(others=>'0');
---        azul  <= std_logic_vector(col(8-1 downto 0));
---      end if;
---      if col >= 512 then  -- puntos
---        rojo   <= (others=>col(0) xor fila(0));
---        verde  <= (others=>col(0) xor fila(0));
---        azul   <= (others=>col(0) xor fila(0));
---      end if;
---    elsif col/c_bar_width = 0 then
---      -- columna 0 sera blanca, columna 1 negra, ...
---      rojo   <= (others=>not(col(0))); 
---      verde  <= (others=>not(col(0))); 
---      azul   <= (others=>not(col(0))); 
---    elsif col/c_bar_width = 1 then
---      --blanco
---      rojo   <= (others=>'1');
---      verde  <= (others=>'1');
---      azul   <= (others=>'1');
---    elsif col/c_bar_width = 2 then
---      --amarillo
---      rojo   <= (others=>'1');
---      verde  <= (others=>'1');
---      azul   <= (others=>'0');
---    elsif col/c_bar_width = 3 then
---      --cian
---      rojo   <= (others=>'0');
---      verde  <= (others=>'1');
---      azul   <= (others=>'1');
---    elsif col/c_bar_width = 4 then
---      --verde
---      rojo   <= (others=>'0');
---      verde  <= (others=>'1');
---      azul   <= (others=>'0');
---    elsif col/c_bar_width = 5 then
---      --magenta
---      rojo   <= (others=>'1');
---      verde  <= (others=>'0');
---      azul   <= (others=>'1');
---    elsif col/c_bar_width = 6 then
---      --rojo
---      rojo   <= (others=>'1');
---      verde  <= (others=>'0');
---      azul   <= (others=>'0');
---    elsif col/c_bar_width = 7 then
---      --azul
---      rojo   <= (others=>'0');
---      verde  <= (others=>'0');
---      azul   <= (others=>'1');
---    elsif col/c_bar_width = 8 then
---      --negro
---      rojo   <= (others=>'0');
---      verde  <= (others=>'0');
---      azul   <= (others=>'0');
---    else
---      -- columna 639 sera blanca, 638 negra, ...
---      rojo   <= (others=>col(0)); 
---      verde  <= (others=>col(0)); 
---      azul   <= (others=>col(0)); 
---    end if;
---  end if;
--- end process;
--- 
  
end Behavioral;

