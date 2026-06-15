library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_ADD_SUB_N is
end TB_ADD_SUB_N;

architecture BEH of TB_ADD_SUB_N is

    component ADD_SUB_N is
        --      A +- B = RES
        generic (N: positive := 8);
        port(
            A:      in std_logic_vector (N-1 downto 0);
            B:      in std_logic_vector (N-1 downto 0);
            S:      in std_logic;   -- S = 1 ==> sottrazione
            RES:    out std_logic_vector(N-1 downto 0);
            COUT:   out std_logic 
            );   
    end component;    
    
    --segnali interni
    --N = 10 bit
    signal A10:      std_logic_vector (9 downto 0);
    signal B10:      std_logic_vector (9 downto 0);
    signal S10:      std_logic;   -- S = 1 ==> sottrazione
    signal RES10:    std_logic_vector(9 downto 0);
    signal COUT10:   std_logic;

begin

    DUT10 : ADD_SUB_N 
        generic map ( N => 10 )
        port map ( A => A10, B => B10, S => S10, RES => RES10, COUT => COUT10 );
        
    --process che genera i segnali
    GEN: process
    begin
        A10 <= "0000000000";
        B10 <= "0000000000";
        S10 <= '0';
        wait for 20 ns;
        
        A10 <= "0000000001";
        B10 <= "0000011001";
        S10 <= '0';
        wait for 20 ns;  
        
        A10 <= "0000011111";
        B10 <= "0001001100";
        S10 <= '0';
        wait for 20 ns;    
        
        A10 <= "1111111111";
        B10 <= "0000000001";
        S10 <= '0';
        wait for 20 ns;

        A10 <= "1111111111";
        B10 <= "1111111111";
        S10 <= '0';
        wait for 20 ns;                 
    
        A10 <= "0101010101";
        B10 <= "1010101010";
        S10 <= '1';
        wait for 20 ns;

        A10 <= "1111111110";
        B10 <= "0000000001";
        S10 <= '1';
        wait for 20 ns;

        A10 <= "1010101010";
        B10 <= "0101010101";
        S10 <= '1';
        wait;    
    
    end process;


end BEH;
