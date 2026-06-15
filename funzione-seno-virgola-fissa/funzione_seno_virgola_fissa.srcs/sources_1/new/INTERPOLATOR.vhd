library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity INTERPOLATOR is
    port(
        ANGLE   : in std_logic_vector(6 downto 0);  
        --U_ANGLE : in std_logic_vector(6 downto 0);  not used
        L_ANGLE : in std_logic_vector(6 downto 0);  
        U_SINE  : in std_logic_vector(9 downto 0);  -- sin value of upper angle
        L_SINE  : in std_logic_vector(9 downto 0);  -- sin value of lower angle
        
        RESULT  : out std_logic_vector(9 downto 0)
        );
        
end INTERPOLATOR;

architecture RTL of INTERPOLATOR is

    component ADD_SUB_N is
        --      A +- B = RES
        generic (N: positive := 8);
        port(
        A:      in std_logic_vector (N-1 downto 0);
        B:      in std_logic_vector (N-1 downto 0);
        S:      in std_logic;   -- S = 1 ==> substraction
        RES:    out std_logic_vector(N-1 downto 0);
        COUT:   out std_logic 
        ); 
    end component;    

    signal DELTA :  std_logic_vector(2 downto 0);   -- angle - lower_angle [1;7] (3 bit)
    signal TDELTA:  std_logic_vector(6 downto 0);   --temporary for delta
    signal DIFF  :  std_logic_vector(9 downto 0);   -- u_sine - l_sine           (10 bit)
    
    --segnali per 3 termini da sommare per ottenere il prodotto
    signal TERM0    :  std_logic_vector(11 downto 0);  -- [00 & DIFF]    x DELTA(0)
    signal TERM1    :  std_logic_vector(11 downto 0);  -- [0 & DIFF & 0] x DELTA(1)
    signal TERM2    :  std_logic_vector(11 downto 0);  -- [DIFF & 00]    x DELTA(2)
    signal TSUM     :  std_logic_vector(11 downto 0);  -- temporary for sum
    signal SUM      :  std_logic_vector(11 downto 0);  -- sum of term0, term1, term2,  in 12 bit
    signal SHIFTED  :  std_logic_vector(9  downto 0);  -- 0 & sum/8     add 0 per to have 10 bit 
    

begin

    
    U0 : ADD_SUB_N  generic map (N=>7)                  --DELTA   
                port map    (A => ANGLE, B => L_ANGLE,
                             S => '1', RES => TDELTA, COUT => open);
                DELTA <= TDELTA(2 downto 0);
                             
    U1 : ADD_SUB_N  generic map (N=>10)                 --DIFF
                port map    (A => U_SINE, B => L_SINE,
                             S => '1', RES => DIFF, COUT => open);
    TERM0 <= "00" & DIFF        when DELTA(0) = '1' else (others => '0');
    TERM1 <= "0"  & DIFF & '0'  when DELTA(1) = '1' else (others => '0'); 
    TERM2 <= DIFF & "00"        when DELTA(2) = '1' else (others => '0');      
                      
    --moltiplicazione = sum(term0, term1, term2) VALUTA POSSIBILITA CARRY SAVE                                                            
    U3 : ADD_SUB_N  generic map (N=>12)           
                port map    (A => TERM0, B => TERM1,
                             S => '0', RES => TSUM, COUT => open);   
                             
    U4 : ADD_SUB_N  generic map (N=>12)            
                port map    (A => TSUM, B => TERM2,
                             S => '0', RES => SUM, COUT => open);
    SHIFTED <= '0' & SUM(11 downto 3);    
                
    U5 : ADD_SUB_N  generic map (N=>10)                 --RESULT
                port map    (A => L_SINE, B => SHIFTED,
                             S => '0', RES => RESULT, COUT => open);                                                                      

    

end RTL;