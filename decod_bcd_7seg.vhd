library ieee;
use ieee.std_logic_1164.all;

entity decod is
    port (
        BCD_IN : in  std_logic_vector(3 downto 0);
        SEG_OUT: out std_logic_vector(6 downto 0) -- a, b, c, d, e, f, g
    );
end entity decod;

architecture RTL of decod is
    -- Tabela de lookup (Anodo Comum): a b c d e f g
    constant SEGMENT_GND : std_logic_vector(6 downto 0) := "1111111"; 
    constant SEG_0 : std_logic_vector(6 downto 0) := "0000001";
    constant SEG_1 : std_logic_vector(6 downto 0) := "1001111";
    constant SEG_2 : std_logic_vector(6 downto 0) := "0010010";
    constant SEG_3 : std_logic_vector(6 downto 0) := "0000110";
    constant SEG_4 : std_logic_vector(6 downto 0) := "1001100";
    constant SEG_5 : std_logic_vector(6 downto 0) := "0100100";
    constant SEG_6 : std_logic_vector(6 downto 0) := "0100000";
    constant SEG_7 : std_logic_vector(6 downto 0) := "0001111";
    constant SEG_8 : std_logic_vector(6 downto 0) := "0000000";
    constant SEG_9 : std_logic_vector(6 downto 0) := "0000100";

begin
    -- implementaçao combinacional
    with BCD_IN select
        SEG_OUT <= SEG_0 when "0000",
                   SEG_1 when "0001",
                   SEG_2 when "0010",
                   SEG_3 when "0011",
                   SEG_4 when "0100",
                   SEG_5 when "0101",
                   SEG_6 when "0110",
                   SEG_7 when "0111",
                   SEG_8 when "1000",
                   SEG_9 when "1001",
                   SEGMENT_GND when others;
end architecture RTL;
