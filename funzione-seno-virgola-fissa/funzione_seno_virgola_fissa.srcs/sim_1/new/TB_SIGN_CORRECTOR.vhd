library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SIGN_CORRECTOR is
end TB_SIGN_CORRECTOR;

architecture BEH of TB_SIGN_CORRECTOR is

    component SIGN_CORRECTOR is
        port(   --input: |sin(x)|   output: +/- sin(x)
            NEGATIVE    : in std_logic;
            VALUE       : in std_logic_vector(9 downto 0);
            
            RESULT      : out std_logic_vector(9 downto 0)
            );
    end component;
    
    signal NEGATIVE    : std_logic;
    signal VALUE       : std_logic_vector(9 downto 0);
    signal RESULT      : std_logic_vector(9 downto 0);    

begin

    DUT : SIGN_CORRECTOR port map ( NEGATIVE, VALUE, RESULT);
    
    GEN : process 
    begin   
        NEGATIVE    <= '0';
        VALUE       <= "0000010110";
        wait for 20 ns;      
        
        NEGATIVE    <= '0';         
        VALUE       <= "1111111111";
        wait for 20 ns;
        
        NEGATIVE    <= '1';         
        VALUE       <= "1111110010";
        wait for 20 ns;
        
        NEGATIVE    <= '1';         
        VALUE       <= "1000010100";
        wait for 20 ns;
        
        NEGATIVE    <= '1';         
        VALUE       <= "1100101110";
        wait for 20 ns;
        
        NEGATIVE    <= '1';         
        VALUE       <= "1111100001";
        wait for 20 ns;
        
        NEGATIVE    <= '1';         
        VALUE       <= "1000000011";
        wait;    
                  
    end process;


end BEH;

