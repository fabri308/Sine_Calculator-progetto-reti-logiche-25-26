library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADD_SUB_N is
    --      A +- B = RES
    generic (N: positive := 8); --integer permetterebbe 0 e numeri negativi
    port(
        A:      in std_logic_vector (N-1 downto 0);
        B:      in std_logic_vector (N-1 downto 0);
        S:      in std_logic;   -- S = 1 ==> sottrazione
        RES:    out std_logic_vector(N-1 downto 0);
        COUT:   out std_logic 
        );
        
end ADD_SUB_N;
    
architecture STRUCT of ADD_SUB_N is
    
component FA is
    
    port(
        X :     in std_logic;
        Y :     in std_logic;
        CIN :   in std_logic;
        SUM :   out std_logic;
        COUT :  out std_logic
    );
    
end component;
    
signal CARRY : std_logic_vector(N downto 0);    --carry chain
signal B_NB  : std_logic_vector(N-1 downto 0);  --B oppure not B
    
begin
    
    B_NB     <= B xor (N-1 downto 0 => S); -- se S =1 -> complemento 1 + carry in
    CARRY(0) <= S;  --carry in -> 0 somma, 1 sottrazione
    
    GEN_FA : for I in 0 to N-1 generate
        U : FA port map(
                X   => A(I),
                Y   => B_NB(I),
                CIN => CARRY(I),
                SUM => RES(I),
                COUT=> CARRY(I+1)
                );
           end generate;
     
     COUT <= CARRY(N);
    
end STRUCT;
    