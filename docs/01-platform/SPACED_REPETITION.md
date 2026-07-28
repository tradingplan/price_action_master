# Spaced Repetition (Repetição Espaçada) System Specification

Este documento define as regras matemáticas do sistema de **Repetição Espaçada** do **Price Action Master**, utilizado para sugerir revisões periódicas de conceitos.

---

## 1. Funcionamento Baseado no Sistema Leitner

As lições e perguntas são classificadas em caixas (boxes) virtuais de 1 a 5 no banco de progresso local:

*   **Box 1:** Revisão diária (conceitos errados recentemente no Quiz).
*   **Box 2:** Revisão a cada 3 dias (conceitos acertados 1 vez).
*   **Box 3:** Revisão a cada 7 dias (conceitos acertados 2 vezes consecutivas).
*   **Box 4:** Revisão a cada 14 dias.
*   **Box 5:** Conhecimento sedimentado (revisar a cada 30 dias).

---

## 2. Ações do Motor de Repetição

*   **Acerto no Quiz:** O ID da lição correspondente é promovido para a próxima Box (Box N+1).
*   **Erro no Quiz:** O ID da lição retorna imediatamente para a **Box 1** para garantir revisão rápida.
*   **Indicação de Alerta na Home:** Na tela inicial, o app exibirá alertas do tipo: *"É hora de revisar: Estruturas BOS e CHoCH (recomenda-se leitura rápida)"* baseado no cálculo de dias passados.
