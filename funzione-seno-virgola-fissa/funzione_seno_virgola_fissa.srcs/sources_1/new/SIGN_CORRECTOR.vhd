library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIGN_CORRECTOR is

    port(   --input: |sin(x)|   output: +/- sin(x)
        NEGATIVE    :  in std_logic;
        VALUE       :  in std_logic_vector(9 downto 0);
        
        RESULT      : out std_logic_vector(9 downto 0)
        );
  
end SIGN_CORRECTOR;

architecture RTL of SIGN_CORRECTOR is

    component ADD_SUB_N is
        --      A +- B = RES
        generic (N: integer := 8);
        port(
        A:      in std_logic_vector (N-1 downto 0);
        B:      in std_logic_vector (N-1 downto 0);
        S:      in std_logic;   -- S = 1 ==> sottrazione
        RES:    out std_logic_vector(N-1 downto 0);
        COUT:   out std_logic 
        );
    end component;

begin            
    U0 : ADD_SUB_N      generic map (N=>10)
                    port map    (A      => (others => '0'),
                                 B      => VALUE, 
                                 S      => NEGATIVE,
                                 RES    => RESULT,
                                 COUT   => open --cout non serve
                                 );                                                        
end RTL;