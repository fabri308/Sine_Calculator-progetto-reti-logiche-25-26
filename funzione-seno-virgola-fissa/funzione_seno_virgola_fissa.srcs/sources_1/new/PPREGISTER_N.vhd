library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PPREGISTER_N is  --parallel parallel with sync reset

    generic (N: positive := 8);
    port(
        DIN : in std_logic_vector (N-1 downto 0);
        CLK : in std_logic;
        RST : in std_logic;
        DOUT: out std_logic_vector(N-1 downto 0)
        );

end PPREGISTER_N;

architecture RTL of PPREGISTER_N is

begin
    reg: process(CLK)
    begin
        if(CLK'event and CLK = '1') then
            if(RST = '1') then
                DOUT <= (others => '0');
            else 
                DOUT <= DIN;
            end if;
        end if;
    end process;

end RTL;
