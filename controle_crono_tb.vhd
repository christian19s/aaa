library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_crono_tb is
end entity controle_crono_tb;

architecture Behavioral of controle_crono_tb is


    constant CLK_PERIOD        : time := 10 ns; 
    constant TEST_PULSE_PERIOD : time := 100 ns;  -- 1 segundo simulado (10x CLK_PERIOD)


    signal CLK_tb       : std_logic := '0';
    signal RST_tb       : std_logic := '0';
    signal START_BTN_tb : std_logic := '0';
    signal STOP_BTN_tb  : std_logic := '0';
    signal RESET_BTN_tb : std_logic := '0';
    signal CLK_1S_EN_tb : std_logic := '0';

    -- Saídas para monitoramento
    signal MIN_UNIT_OUT_tb : std_logic_vector(3 downto 0);
    signal SEC_DEC_OUT_tb  : std_logic_vector(3 downto 0);
    signal SEC_UNIT_OUT_tb : std_logic_vector(3 downto 0);

begin 

    UUT: entity work.controle_crono 
        port map (
            CLK          => CLK_tb,
            RST          => RST_tb,
            START_BTN    => START_BTN_tb,   
            STOP_BTN     => STOP_BTN_tb,
            RESET_BTN    => RESET_BTN_tb,
            CLK_1S_EN    => CLK_1S_EN_tb,
            MIN_UNIT_OUT => MIN_UNIT_OUT_tb,
            SEC_DEC_OUT  => SEC_DEC_OUT_tb,
            SEC_UNIT_OUT => SEC_UNIT_OUT_tb
        );


    CLK_GENERATOR: process
    begin
        loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process CLK_GENERATOR;

-- pulso acelerado
    PULSE_GENERATOR: process
    begin
        loop
            CLK_1S_EN_tb <= '0';
            wait for TEST_PULSE_PERIOD;
            CLK_1S_EN_tb <= '1';
            wait for CLK_PERIOD; -- O pulso fica ativo por apenas 1 ciclo de clock
        end loop;
    end process PULSE_GENERATOR;


    TEST_SEQUENCE: process
    begin
        -- Estado Inicial: Reset Assíncrono
        RST_tb <= '1';
        wait for CLK_PERIOD * 5;
        RST_tb <= '0';
        wait for CLK_PERIOD * 10; -- Aguarda estabilização

        -- 0:00 -> RUN
        START_BTN_tb <= '1';
        wait for CLK_PERIOD * 2;
        START_BTN_tb <= '0';

        -- Contar até ~0:25
        wait for TEST_PULSE_PERIOD * 25;

        -- TESTE 2: PARAR CONTAGEM 
        STOP_BTN_tb <= '1';
        wait for CLK_PERIOD * 2;
        STOP_BTN_tb <= '0';

	--verificar  em 10 pulsos
        wait for TEST_PULSE_PERIOD * 10;

        -- TESTE 3: CONTINUAR E TESTAR OVERFLOW DO MINUTO (STOP -> RUN)
        START_BTN_tb <= '1';
        wait for CLK_PERIOD * 2;
        START_BTN_tb <= '0';

        -- Contar de ~0:25 até ~1:05 (Mais 40 segundos, forçando M_U = 1)
        wait for TEST_PULSE_PERIOD * 40; 
        
        -- TESTE 4: RESETAR (Qualquer Estado -> STOP e 0:00)
        RESET_BTN_tb <= '1';
        wait for CLK_PERIOD * 2;
        RESET_BTN_tb <= '0';
        

        wait for TEST_PULSE_PERIOD * 5; 



        
        wait; 
        
    end process TEST_SEQUENCE;

end architecture Behavioral;
