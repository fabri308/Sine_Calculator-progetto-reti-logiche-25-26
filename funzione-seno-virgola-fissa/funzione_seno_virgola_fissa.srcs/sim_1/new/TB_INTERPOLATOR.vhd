library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_INTERPOLATOR is
end TB_INTERPOLATOR;

architecture BEH of TB_INTERPOLATOR is

    component INTERPOLATOR is
        port(
            ANGLE   : in std_logic_vector(8 downto 0);  
            --U_ANGLE : in std_logic_vector(8 downto 0);  not used
            L_ANGLE : in std_logic_vector(8 downto 0);  
            U_SINE  : in std_logic_vector(9 downto 0);  -- sin value of upper angle
            L_SINE  : in std_logic_vector(9 downto 0);  -- sin value of lower angle
            
            RESULT  : out std_logic_vector(9 downto 0)
            );
            
    end component;  
    
    signal ANGLE   : std_logic_vector(8 downto 0);  
    signal L_ANGLE : std_logic_vector(8 downto 0);  
    signal U_SINE  : std_logic_vector(9 downto 0);  -- sin value of upper angle
    signal L_SINE  : std_logic_vector(9 downto 0);  -- sin value of lower angle
    
    signal RESULT  : std_logic_vector(9 downto 0);  

begin

    DUT0 : INTERPOLATOR port map(ANGLE, L_ANGLE, U_SINE, L_SINE, RESULT);

    GEN : process
    begin
        
        wait for 10 ns;
        ANGLE   <= "000101101"; --45 = 180-135
        L_ANGLE <= "000101000"; --40
        U_SINE  <= "0010111110"; --sin(48)
        L_SINE  <= "0010100101"; -- sin (40)
        wait;
    end process;
            
            

end BEH;
