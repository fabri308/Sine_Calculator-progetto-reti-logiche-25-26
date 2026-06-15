
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SINE_CALCULATOR is
end TB_SINE_CALCULATOR;

architecture BEH of TB_SINE_CALCULATOR is

    component SINE_CALCULATOR is  
        port(   --input: angolo [0;90]   output: valore sin(ANGLE)
            ANGLE   : in  std_logic_vector(8 downto 0); 
            SINE    : out std_logic_vector(9 downto 0)
            );   
    end component;
    
        signal ANGLE   :  std_logic_vector(8 downto 0); 
        signal SINE    :  std_logic_vector(9 downto 0);
    
begin

    DUT : SINE_CALCULATOR port map(ANGLE, SINE);
    
    GEN : process
    begin
        
        ANGLE <= "000101101"; --45
        wait;
            
    
    end process;


end BEH;
