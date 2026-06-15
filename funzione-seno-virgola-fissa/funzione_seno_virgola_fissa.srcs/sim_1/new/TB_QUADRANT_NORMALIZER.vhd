library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_QUADRANT_NORMALIZER is
end TB_QUADRANT_NORMALIZER;

architecture BEH of TB_QUADRANT_NORMALIZER is

    component QUADRANT_NORMALIZER is

    port(   --input: angle[0;365]   output: angle[0;90] , neg signal
        ANGLE_IN :  in std_logic_vector (8 downto 0);
        ANGLE_OUT:  out std_logic_vector (6 downto 0);
        NEG:        out std_logic
        );

    end component;
    
        signal ANGLE_IN :   std_logic_vector (8 downto 0);
        signal ANGLE_OUT:   std_logic_vector (6 downto 0);
        signal NEG:         std_logic;
    
    
begin

    DUT : QUADRANT_NORMALIZER port map(ANGLE_IN, ANGLE_OUT, NEG);
    
    GEN : process
    begin
        ANGLE_IN <= "000101101"; --
        wait for 20 ns;
        
        ANGLE_IN <= "001000000"; --64
        wait for 20 ns;        
        
        ANGLE_IN <= "010000111"; --135
        wait for 20 ns;        
        
        ANGLE_IN <= "011100001"; --225
        wait for 20 ns;     
        
        ANGLE_IN <= "100111011"; --315
        wait;           
    
    end process;
    

end BEH;
