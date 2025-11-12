library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div_mux is
    port (
        CLK       : in  std_logic;
        RST       : in  std_logic;
        CLK_MUX_EN: out std_logic  -- habilita o chaveamento do display
    );
end entity clk_div_mux;

architecture RTL of clk_div_mux is
	--cte para 1ms 
    constant COUNT_MAX : integer := 50000;
    signal count       : unsigned(15 downto 0) := (others => '0');
begin
    process (CLK, RST) is
    begin
        if RST = '1' then
            count      <= (others => '0');
            CLK_MUX_EN <= '0';
        elsif rising_edge(CLK) then
            if count = COUNT_MAX - 1 then
                count      <= (others => '0');
                CLK_MUX_EN <= '1';
            else
                count      <= count + 1;
                CLK_MUX_EN <= '0';
            end if;
        end if;
    end process;
end architecture RTL;
