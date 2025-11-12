library ieee;
use ieee.std_logic_1164.all;

entity cronometro_dig is
    port (

        CLK_50MHZ     : in  std_logic; 
        SYS_RST       : in  std_logic;

   
        BTN_START_RAW : in  std_logic;
        BTN_STOP_RAW  : in  std_logic;
        BTN_RESET_RAW : in  std_logic;

  
        SEG_OUT       : out std_logic_vector(6 downto 0); -- a, b, c, d, e, f, g
        AN_OUT        : out std_logic_vector(2 downto 0); -- Habilitação de Anodo (M_U, S_D, S_U)
        DP_OUT        : out std_logic                     -- Ponto decimal (DP)
    );
end entity cronometro_dig;

architecture Structural of cronometro_dig is

    
    component debounce is
        generic ( CLK_FREQ_MHZ : natural; DEBOUNCE_TIME_MS : natural );
        port ( CLK : in std_logic; RST : in std_logic; BUTTON_IN : in std_logic; BUTTON_OUT : out std_logic );
    end component;

    component div_clock_1Hz is
        port ( CLK : in std_logic; RST : in std_logic; CLK_1S_EN : out std_logic );
    end component;

    component clk_div_mux is
        port ( CLK : in std_logic; RST : in std_logic; CLK_MUX_EN : out std_logic );
    end component;

    component controle_crono is
        port ( CLK : in std_logic; RST : in std_logic; START_BTN : in std_logic; STOP_BTN : in std_logic; RESET_BTN : in std_logic; CLK_1S_EN : in std_logic; MIN_UNIT_OUT : out std_logic_vector(3 downto 0); SEC_DEC_OUT : out std_logic_vector(3 downto 0); SEC_UNIT_OUT : out std_logic_vector(3 downto 0) );
    end component;

    component decod is
        port ( BCD_IN : in std_logic_vector(3 downto 0); SEG_OUT : out std_logic_vector(6 downto 0) );
    end component;

    component mux_driver is 
        port ( CLK : in std_logic; RST : in std_logic; CLK_MUX_EN : in std_logic; MIN_UNIT_IN : in std_logic_vector(3 downto 0); SEC_DEC_IN : in std_logic_vector(3 downto 0); SEC_UNIT_IN : in std_logic_vector(3 downto 0); BCD_OUT : out std_logic_vector(3 downto 0); AN_OUT : out std_logic_vector(2 downto 0) );
    end component;

    -- Sinais internos
    signal rst_active_high : std_logic;
    signal btn_start_db    : std_logic;
    signal btn_stop_db     : std_logic;
    signal btn_reset_db    : std_logic;
    signal clk_1s_en_s     : std_logic;
    signal clk_mux_en_s    : std_logic;
    signal min_unit_s      : std_logic_vector(3 downto 0);
    signal sec_dec_s       : std_logic_vector(3 downto 0);
    signal sec_unit_s      : std_logic_vector(3 downto 0);
    signal bcd_to_decoder  : std_logic_vector(3 downto 0);
signal an_out_int : std_logic_vector(2 downto 0);

begin
    -- 0. Inversão do Reset (eu acho que nao vou ter que inverter isso)
    rst_active_high <= not SYS_RST;

    
    DB_START: debounce generic map (CLK_FREQ_MHZ => 50, DEBOUNCE_TIME_MS => 10)
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, BUTTON_IN => BTN_START_RAW, BUTTON_OUT => btn_start_db );

    DB_STOP: debounce generic map (CLK_FREQ_MHZ => 50, DEBOUNCE_TIME_MS => 10)
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, BUTTON_IN => BTN_STOP_RAW, BUTTON_OUT => btn_stop_db );

    DB_RESET: debounce generic map (CLK_FREQ_MHZ => 50, DEBOUNCE_TIME_MS => 10)
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, BUTTON_IN => BTN_RESET_RAW, BUTTON_OUT => btn_reset_db );

   
    DIV_1HZ: div_clock_1Hz
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, CLK_1S_EN => clk_1s_en_s );

    DIV_MUX: clk_div_mux 
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, CLK_MUX_EN => clk_mux_en_s ); 


    CONTROLLER: controle_crono
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, START_BTN => btn_start_db, STOP_BTN => btn_stop_db, RESET_BTN => btn_reset_db, CLK_1S_EN => clk_1s_en_s, MIN_UNIT_OUT => min_unit_s, SEC_DEC_OUT => sec_dec_s, SEC_UNIT_OUT => sec_unit_s );


    MUX_DRIVER_INST: mux_driver 
        port map ( CLK => CLK_50MHZ, RST => rst_active_high, CLK_MUX_EN => clk_mux_en_s, MIN_UNIT_IN => min_unit_s, SEC_DEC_IN => sec_dec_s, SEC_UNIT_IN => sec_unit_s, BCD_OUT => bcd_to_decoder, AN_OUT => an_out_int );


    DECODER: decod
        port map ( BCD_IN => bcd_to_decoder, SEG_OUT => SEG_OUT );

--pnt decimal ativo quando an_out está ativado
    AN_OUT <= an_out_int;
DP_OUT <= an_out_int(1);


end architecture Structural;
