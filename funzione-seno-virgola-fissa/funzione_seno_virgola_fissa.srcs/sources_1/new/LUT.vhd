library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity LUT is
    port(
        ANGLE       : in std_logic_vector(6 downto 0);
        
        RESULT      : out std_logic_vector(9 downto 0);
        FOUND       : out std_logic

        );

end LUT;

architecture RTL of LUT is

begin

    lut_process : process(ANGLE)
    begin

        case ANGLE is   --tabulazione angoli %8
            when "0000000" =>          -- 0°
                RESULT <= "0000000000"; FOUND <= '1';
            when "0001000" =>          -- 8°
                RESULT <= "0000100100"; FOUND <= '1';
            when "0010000" =>          -- 16°
                RESULT <= "0001000111"; FOUND <= '1';
            when "0011000" =>          -- 24°
                RESULT <= "0001101000"; FOUND <= '1';
            when "0100000" =>          -- 32°
                RESULT <= "0010001000"; FOUND <= '1';
            when "0101000" =>          -- 40°
                RESULT <= "0010100101"; FOUND <= '1';
            when "0110000" =>          -- 48°
                RESULT <= "0010111110"; FOUND <= '1';
            when "0111000" =>          -- 56°
                RESULT <= "0011010100"; FOUND <= '1';
            when "1000000" =>          -- 64°
                RESULT <= "0011100110"; FOUND <= '1';
            when "1001000" =>          -- 72°
                RESULT <= "0011110011"; FOUND <= '1';
            when "1010000" =>          -- 80°
                RESULT <= "0011111100"; FOUND <= '1';
            when "1011000" =>          -- 88°
                RESULT <= "0100000000"; FOUND <= '1';
            when "1011001" =>          -- 89°
                RESULT <= "0100000000"; FOUND <= '1';
            when "1011010" =>          -- 90°
                RESULT <= "0100000000"; FOUND <= '1';
            when others =>
                RESULT <= (others => '1'); FOUND <= '0';
        end case;
        

        
    end process;

end RTL;
