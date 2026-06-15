library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity TB_SINE_FUNCTION is
end TB_SINE_FUNCTION;

architecture BEH of TB_SINE_FUNCTION is

    component SINE_FUNCTION is    
        port(
            ANGLE   :  in std_logic_vector(8 downto 0);
            CLK     :  in std_logic;
            RST     :  in std_logic;
            
            RESULT  : out std_logic_vector(9 downto 0)
            );     
    end component;
    
    signal ANGLE  : std_logic_vector(8 downto 0);
    signal CLK    : std_logic := '0';
    signal RST    : std_logic := '0';
    signal RESULT : std_logic_vector(9 downto 0);

begin

    DUT : SINE_FUNCTION
    port map(
        ANGLE  => ANGLE,
        CLK    => CLK,
        RST    => RST,
        RESULT => RESULT
    );

    CLK_GEN : process
    begin
        loop
            CLK <= '0'; wait for 2500 ps;   --clock 5 ns;
            CLK <= '1'; wait for 2500 ps;
        end loop;
    end process CLK_GEN;        
    
    GEN : process
    begin

--        RST <= '1';
--        wait for 130 ns;
--        wait until rising_edge(CLK);
--        wait until rising_edge(CLK);
        
--        ANGLE <= "000000000";
--        wait until rising_edge(CLK);
--        ANGLE <= "000000001";

--        wait until rising_edge(CLK);
--        ANGLE <= "000000011";
--        wait until rising_edge(CLK);        
--        ANGLE <= "000000100";
--        RST <= '0';  
--        wait until rising_edge(CLK); 
--        ANGLE <= "000000101";
--        wait until rising_edge(CLK);
--        ANGLE <= "000000110";
--        wait until rising_edge(CLK);    
--                ANGLE <= "000000111";
--        wait until rising_edge(CLK);
--                ANGLE <= "000001000";
--        wait until rising_edge(CLK);
--                ANGLE <= "000001001";
--        wait until rising_edge(CLK);    
        
        
    
        for I in 0 to 359 loop
            ANGLE <= std_logic_vector(to_unsigned(I, 9));    
            wait until rising_edge(CLK);
        end loop;               
    
        -- Pipeline flush: 2 cycles to let last result propagate
        wait until rising_edge(CLK);
        wait until rising_edge(CLK);
        wait until rising_edge(CLK);
 
        wait;    
    
    end process;
    

end BEH;
