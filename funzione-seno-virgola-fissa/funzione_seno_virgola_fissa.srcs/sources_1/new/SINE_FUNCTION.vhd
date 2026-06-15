library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_FUNCTION is

    port(
        ANGLE   :  in std_logic_vector(8 downto 0);
        CLK     :  in std_logic;
        RST     :  in std_logic;
        
        RESULT  : out std_logic_vector(9 downto 0)
        ); 

end SINE_FUNCTION;

architecture RTL of SINE_FUNCTION is
    --components
    
    component PPREGISTER_N is  --parallel parallel with sync reset
        generic (N: positive := 8);
        port(
            DIN : in std_logic_vector (N-1 downto 0);
            CLK : in std_logic;
            RST : in std_logic;
            DOUT: out std_logic_vector(N-1 downto 0)
            );
    end component;
    
    component QUADRANT_NORMALIZER is
    port(   --input: angle[0;365]   output: angle[0;90] , neg signal
        ANGLE_IN :   in std_logic_vector (8 downto 0);
        NORM_ANGLE:  out std_logic_vector (6 downto 0);
        NEG:         out std_logic
        );
    end component;
    
    component SINE_CALCULATOR is
    port(   --input: angolo [0;90]   output: valore sin(ANGLE)
        ANGLE   : in  std_logic_vector(6 downto 0); 
        SINE    : out std_logic_vector(9 downto 0)
        );
    end component;
    
    component SIGN_CORRECTOR is
    port(   --input: |sin(x)|   output: +/- sin(x)
        NEGATIVE    :  in std_logic;
        VALUE       :  in std_logic_vector(9 downto 0);
        RESULT      : out std_logic_vector(9 downto 0)
        );
    end component;
    
    
    signal D_OUT        : std_logic_vector(8 downto 0); 
    signal NORMALIZED7  : std_logic_vector(6 downto 0);
    signal NEG          : std_logic;
    signal ABS_SINE     : std_logic_vector(9 downto 0);
    signal FINAL_RES    : std_logic_vector(9 downto 0);
    

begin

    PP9     : PPREGISTER_N  generic map(N => 9)
                            port map(DIN => ANGLE, CLK => CLK, RST => RST, DOUT => D_OUT);
                            
    QN0     : QUADRANT_NORMALIZER port map(ANGLE_IN => D_OUT, NORM_ANGLE => NORMALIZED7 , NEG => NEG);  
    
    SCA     : SINE_CALCULATOR port map(ANGLE => NORMALIZED7, SINE => ABS_SINE);    
    
    SCO     : SIGN_CORRECTOR  port map(NEGATIVE => NEG, VALUE => ABS_SINE, RESULT => FINAL_RES);  
    
    PP10    : PPREGISTER_N  generic map(N => 10)
                            port map(DIN => FINAL_RES, CLK => CLK, RST => RST, DOUT => RESULT);         



end RTL;