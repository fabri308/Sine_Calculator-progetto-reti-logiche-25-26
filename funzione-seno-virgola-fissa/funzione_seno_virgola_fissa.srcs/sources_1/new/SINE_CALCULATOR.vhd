library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SINE_CALCULATOR is

    port(   --input: angolo [0;90]   output: valore sin(ANGLE)
        ANGLE   : in  std_logic_vector(6 downto 0); 
        SINE    : out std_logic_vector(9 downto 0)
        );

end SINE_CALCULATOR;

architecture RTL of SINE_CALCULATOR is

    component UPPER_LOWER_ANGLE is

    port(   --input: angle[0;90]   output: nearest multiples of 8
        ANGLE   : in std_logic_vector(6 downto 0);
        UPPER   : out std_logic_vector(6 downto 0);
        LOWER   : out std_logic_vector(6 downto 0)
        );

    end component;
    
    component LUT is
    port(
        ANGLE       : in std_logic_vector(6 downto 0);
        RESULT      : out std_logic_vector(9 downto 0);
        FOUND       : out std_logic
        );

    end component;
    
    component INTERPOLATOR is
    port(
        ANGLE   : in std_logic_vector(6 downto 0);  
        --U_ANGLE : in std_logic_vector(8 downto 0);  not used
        L_ANGLE : in std_logic_vector(6 downto 0); 
        U_SINE  : in std_logic_vector(9 downto 0); 
        L_SINE  : in std_logic_vector(9 downto 0); 
        RESULT  : out std_logic_vector(9 downto 0)
        );
    end component;
    
    --signals
    ---signal TEMP_UP_LOW  : std_logic_vector(6 downto 0);
    signal UPPERSIG     : std_logic_vector(6 downto 0);
    signal LOWERSIG     : std_logic_vector(6 downto 0);
    signal SINEUPPER    : std_logic_vector(9 downto 0);
    signal SINELOWER    : std_logic_vector(9 downto 0);
    signal LUTRESULT    : std_logic_vector(9 downto 0);
    signal TABLED       : std_logic;
    signal INTERPOLATED : std_logic_vector(9 downto 0);

begin

    --TEMP_UP_LOW <= ANGLE(6 downto 0);
    UL0: UPPER_LOWER_ANGLE  port map(ANGLE => ANGLE, UPPER => UPPERSIG, LOWER => LOWERSIG);
    L0 : LUT                port map(ANGLE => UPPERSIG, RESULT => SINEUPPER, FOUND => open);
    L1 : LUT                port map(ANGLE => LOWERSIG, RESULT => SINELOWER, FOUND => open);
    L2 : LUT                port map(ANGLE => ANGLE, RESULT => LUTRESULT, FOUND => TABLED);
    I0 : INTERPOLATOR       port map(ANGLE => ANGLE, L_ANGLE => LOWERSIG, U_SINE => SINEUPPER, L_SINE => SINELOWER, RESULT => INTERPOLATED);
    
    SINE <= LUTRESULT when TABLED = '1' else INTERPOLATED;


end RTL;
