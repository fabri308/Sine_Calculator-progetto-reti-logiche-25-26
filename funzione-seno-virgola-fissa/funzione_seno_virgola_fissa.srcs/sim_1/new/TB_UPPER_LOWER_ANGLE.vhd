
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TB_UPPER_LOWER_ANGLE is
end TB_UPPER_LOWER_ANGLE;

architecture Behavioral of TB_UPPER_LOWER_ANGLE is

    component UPPER_LOWER_ANGLE is
        port(   --input: angle[0;90]   output: nearest multiples of 8
            ANGLE   : in std_logic_vector(6 downto 0);
            
            UPPER   : out std_logic_vector(8 downto 0);
            LOWER   : out std_logic_vector(8 downto 0)
            );
    end component;
    
    signal ANGLE   : std_logic_vector(6 downto 0);
    signal UPPER   : std_logic_vector(8 downto 0);
    signal LOWER   : std_logic_vector(8 downto 0);    

begin

    DUT : UPPER_LOWER_ANGLE port map(ANGLE, UPPER, LOWER);
    
    GEN : process 
    begin
        wait for 1 ns;
        ANGLE <= "0000101";
        wait for 20 ns;
        
        ANGLE <= "0101101";
        wait for 20 ns;
        
        ANGLE <= "0001110";
        wait for 20 ns;
        
        ANGLE <= "0101101";
        wait;
    
    end process;


end Behavioral;
