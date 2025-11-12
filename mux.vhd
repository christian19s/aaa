library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_Driver is
    port (
        CLK        : in  std_logic;
        RST        : in  std_logic;
        CLK_MUX_EN : in  std_logic;  
        MIN_UNIT_IN: in  std_logic_vector(3 downto 0); -- M_U
        SEC_DEC_IN : in  std_logic_vector(3 downto 0); -- S_D
        SEC_UNIT_IN: in  std_logic_vector(3 downto 0); -- S_U
        BCD_OUT    : out std_logic_vector(3 downto 0); -- BCD para o Decoder
        AN_OUT     : out std_logic_vector(2 downto 0)  -- Habilitação de Anodo (ativo baixo)
    );
end entity MUX_Driver;

architecture RTL of MUX_Driver is

    signal D_SEL : unsigned(1 downto 0) := (others => '0');
begin

    process (CLK, RST) is
    begin
        if RST = '1' then
            D_SEL <= (others => '0');
        elsif rising_edge(CLK) then
            if CLK_MUX_EN = '1' then
                -- O contador de 2 bits avanca e cicla p/cada 1kHz
                D_SEL <= D_SEL + 1;
            end if;
        end if;
    end process;

    -- bcd a ser exibido
    with D_SEL select
        BCD_OUT <= MIN_UNIT_IN when "00", -- M_U
                   SEC_DEC_IN  when "01", -- S_D
                   SEC_UNIT_IN when others; -- S_U

    -- Habilitação dos Anodos ( 0 = ligado)
    -- AN_OUT(0) = M_U, AN_OUT(1) = S_D, AN_OUT(2) = S_U
    AN_OUT(0) <= '0' when D_SEL = "00" else '1';
    AN_OUT(1) <= '0' when D_SEL = "01" else '1';
    AN_OUT(2) <= '0' when D_SEL = "10" else '1';
end architecture RTL;
