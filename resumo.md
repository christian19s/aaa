# 💾 Resumo do Projeto Cronômetro Digital VHDL (FPGA AX301)

Este documento resume a funcionalidade e a arquitetura do projeto de cronômetro, estruturado em torno da lógica BCD e multiplexação de displays de 7 segmentos.

---

## 1. 🧠 Core Lógico e Controle (`controle_crono.vhd`)

O módulo central do sistema, responsável pela contagem e gerenciamento de estado.

* **Função:** Contém a **Máquina de Estados Finita (FSM)** para gerenciar o comportamento sequencial do cronômetro.
* **Estados Principais:** **RUN** (contagem habilitada) e **STOP** (parado ou resetado).
* **Contagem BCD:** Gerencia os contadores BCD (`min_u`, `sec_d`, `sec_u`), que são incrementados pelo pulso de 1 segundo (`CLK_1S_EN_tb`).
* **Limite:** O cronômetro funciona de 0:00seg a 9:59seg.

---

## 2. ⏳ Subsistemas de Tempo e Entrada

Estes módulos garantem que o core lógico receba sinais limpos e cronometrados.

| Arquivo | Função Principal | Conexão com o Core |
| :--- | :--- | :--- |
| **`div_clk_1hz.vhd`** | Gera o pulso de **aproximadamente 1 segundo** (`CLK_1S_EN`). | Entrada de tempo para o `controle_crono`. |
| **`debounce.vhd`** | **Anti-Ricochete:** Limpa o ruído dos botões de **Start**, **Stop** e **Reset**. | Fornece comandos limpos para o `controle_crono`. |

---

## 3. 🖥️ Subsistemas de Display (7 Segmentos)

Gerenciam a visualização da saída BCD para os displays da FPGA AX301.

| Arquivo | Função Principal | Pinos FPGA Envolvidos |
| :--- | :--- | :--- |
| **`decod_bcd_7seg.vhd`** | Converte o valor BCD (4 bits) para os 7 sinais de segmento (`DIG[0]` a `DIG[7]`). | `DIG[0]` (Segmento A) a `DIG[7]` (Ponto Decimal). |
| **`mux_driver.vhd`** | Executa a **multiplexação** dos **3 displays utilizados**. | Controla os sinais de seleção de dígito (Ânodo) `SEL[0]`, `SEL[1]`, `SEL[2]`. |
| **`clk_div_mux.vhd`** | Gera o clock de alta frequência (rápido) para a chaveamento do `mux_driver`. | Fornece o clock de tempo para o `mux_driver`. |

---

## 4. 🧪 Simulação (Testbench)

* **Arquivo:** **`controle_crono_tb.vhd`**.
* **Uso:** Simula o comportamento do `controle_crono.vhd` e gera o arquivo `.ghw` para visualização no GTKWave.
* **Dica de Debug:** Agrupe os sinais internos (`min_u`, `sec_d`, `sec_u`) com o **Radix Decimal** para monitorar a contagem corretamente.
