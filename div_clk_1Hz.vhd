library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_clock_1Hz is
    port (
        CLK        : in  std_logic;
        RST        : in  std_logic;
        CLK_1S_EN  : out std_logic  
    );
end entity div_clock_1Hz;

architecture RTL of div_clock_1Hz is
    constant COUNT_MAX : integer := 50000000;
    signal count       : unsigned(25 downto 0) := (others => '0');
begin
    process (CLK, RST) is
    begin
        if RST = '1' then
            count     <= (others => '0');
            CLK_1S_EN <= '0';
        elsif rising_edge(CLK) then
            if count = COUNT_MAX - 1 then
                count     <= (others => '0');
                CLK_1S_EN <= '1';
            else
                count     <= count + 1;
                CLK_1S_EN <= '0';
            end if;
        end if;
    end process;
end architecture RTL;