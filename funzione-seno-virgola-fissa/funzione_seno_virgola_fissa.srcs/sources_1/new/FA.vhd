library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is

    port(
        X :     in std_logic;
        Y :     in std_logic;
        CIN :   in std_logic;
        SUM :   out std_logic;
        COUT :  out std_logic
    );

end FA;

architecture Behavioral of FA is
begin

    SUM    <= X xor Y xor CIN;
    COUT <= (X and Y) or (X and CIN) or (Y and CIN);

end Behavioral;
