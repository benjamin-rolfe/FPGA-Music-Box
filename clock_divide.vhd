library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divide is
    port (
        clkIn   : in  std_logic;
        note_DIV: in  integer;
        clkOut  : out std_logic
    );
end clock_divide;

architecture rtl of clock_divide is
    signal counter : integer := 0;
    signal toggle  : std_logic := '0';
begin

    process(clkIn)
    begin
        if rising_edge(clkIn) then
            if note_DIV > 0 then
                if counter >= note_DIV-1 then
                    toggle <= not toggle;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                toggle <= '0';  -- for REST note
                counter <= 0;
            end if;
        end if;
    end process;

    clkOut <= toggle;


end rtl;
