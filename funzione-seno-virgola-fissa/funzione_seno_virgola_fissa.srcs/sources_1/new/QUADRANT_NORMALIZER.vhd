library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity QUADRANT_NORMALIZER is

    port(   --input: angle[0;365]   output: angle[0;90] , neg signal
        ANGLE_IN :  in std_logic_vector (8 downto 0);
        NORM_ANGLE:  out std_logic_vector (6 downto 0);
        NEG:        out std_logic
        );

end QUADRANT_NORMALIZER;

architecture RTL of QUADRANT_NORMALIZER is

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


    --angle quadrant
    --signal UNDER90 : std_logic; 
    signal OVER90   : std_logic;
    signal OVER180  : std_logic;
    signal OVER270  : std_logic;
    signal QUAD     : std_logic_vector(2 downto 0); --000, 100, 110, 111
    
    signal TEMP     : std_logic_vector(2 downto 0); --temorary to negate RES(8)
    signal TERM1    : std_logic_vector(8 downto 0); --terms to calculate ANGLE_OUT
    signal TERM2    : std_logic_vector(8 downto 0); --using only 1 add/sub
    
    signal TEMP_OUT : std_logic_vector(8 downto 0);


begin
                                         -- uso soglie 91, 181, 271 perché cout indica se (ANGLE_IN >= soglia)
    U0 : ADD_SUB_N  generic map (N=>9)   -- soglia 91 = 001011011
                port map    (A => ANGLE_IN, B => "001011011",
                             S => '1', RES => open, COUT => OVER90);

    U1 : ADD_SUB_N  generic map (N=>9)   -- soglia 181 = 010110101
                port map    (A => ANGLE_IN, B => "010110101",
                             S => '1', RES => open, COUT => OVER180);

    U2 : ADD_SUB_N  generic map (N=>9)   -- soglia 271 = 100001111
                port map    (A => ANGLE_IN, B => "100001111",
                             S => '1', RES => open, COUT => OVER270);
                                      
    
    QUAD    <= OVER90 & OVER180 & OVER270;  --"000"=Q1 "100"=Q2 "110"=Q3 "111"=Q4
    --UNDER90 <= not (OVER90 or OVER180 or OVER270);
    
    NEG <= OVER180; -- se sono oltre 180 il seno è negativo NEG <= '1' when OVER180 = '1' else '0'
    
    --angle_out, identifico i due addendi e il segno, poi creo l'add/sub e scrivo il risultato
    with QUAD select
        TERM1 <= ANGLE_IN    when "000",  -- Q1: x
                 "010110100" when "100",  -- Q2: 180
                 ANGLE_IN    when "110",  -- Q3: x
                 "101101000" when "111",  -- Q4: 360
                 "000000000" when others; --debug

    with QUAD select
        TERM2 <= "000000000" when "000",  -- Q1: 0
                 ANGLE_IN    when "100",  -- Q2: x
                 "010110100" when "110",  -- Q3: 180
                 ANGLE_IN    when "111",  -- Q4: x
                 "000000000" when others; --debug       
    
     U3: ADD_SUB_N generic map(N => 9)
                    port map(   A => TERM1, 
                                B => TERM2, 
                                S => OVER90,
                                RES => TEMP_OUT, 
                                COUT => open);
    NORM_ANGLE <= TEMP_OUT(6 downto 0);                                

end RTL;
