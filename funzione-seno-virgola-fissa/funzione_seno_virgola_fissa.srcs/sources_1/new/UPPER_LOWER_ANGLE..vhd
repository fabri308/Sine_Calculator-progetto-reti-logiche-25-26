library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UPPER_LOWER_ANGLE is

    port(   --input: angle[0;90]   output: nearest multiples of 8
        ANGLE   : in std_logic_vector(6 downto 0);
        
        UPPER   : out std_logic_vector(6 downto 0);
        LOWER   : out std_logic_vector(6 downto 0)
        );

end UPPER_LOWER_ANGLE;

architecture RTL of UPPER_LOWER_ANGLE is

    signal SLOT : std_logic_vector(3 downto 0);

begin

    SLOT <= ANGLE(6 downto 3);    --slot = angle/8  (shift 3)
    
    upper_lower_process : process(SLOT)
    begin
        case SLOT is    --tabulazione lower e upper angle
            when "0000" =>
                LOWER <= "0000000"; -- 0
                UPPER <= "0001000"; -- 8
            when "0001" =>
                LOWER <= "0001000"; -- 8
                UPPER <= "0010000"; -- 16
            when "0010" =>
                LOWER <= "0010000"; -- 16
                UPPER <= "0011000"; -- 24
            when "0011" =>
                LOWER <= "0011000"; -- 24
                UPPER <= "0100000"; -- 32
            when "0100" =>
                LOWER <= "0100000"; -- 32
                UPPER <= "0101000"; -- 40
            when "0101" =>
                LOWER <= "0101000"; -- 40
                UPPER <= "0110000"; -- 48
            when "0110" =>
                LOWER <= "0110000"; -- 48
                UPPER <= "0111000"; -- 56
            when "0111" =>
                LOWER <= "0111000"; -- 56
                UPPER <= "1000000"; -- 64
            when "1000" =>
                LOWER <= "1000000"; -- 64
                UPPER <= "1001000"; -- 72
            when "1001" =>
                LOWER <= "1001000"; -- 72
                UPPER <= "1010000"; -- 80
            when "1010" =>
                LOWER <= "1010000"; -- 80
                UPPER <= "1011000"; -- 88
            when others =>      --useless if angle is tabled
                LOWER <= (others => '1');
                UPPER <= (others => '1');
        end case;                
        
    end process;


end RTL;
