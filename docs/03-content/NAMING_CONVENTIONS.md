# Naming Conventions & Identifiers Reference

Para garantir a integridade referencial dos dados locais na plataforma, todas as entidades descritas pelo Content Architect devem seguir as convenções abaixo.

---

## 1. IDs de Cursos (Course IDs)
*   Formato: Minúsculo, sem acentos, sem espaços.
*   Exemplo: `smc`, `elliott`, `candlesticks`, `figuras`.
*   Nome do arquivo: `<course_id>.json`.

---

## 2. IDs de Módulos (Module IDs)
*   Formato: `<course_id>_m<numero_modulo>`.
*   Exemplo: `smc_m1` (módulo 1 do curso SMC).

---

## 3. IDs de Etapas Internas
*   **Lição:** `<module_id>_l<numero_licao>`. Ex: `smc_m1_l1`.
*   **Exemplo:** `<module_id>_e<numero_exemplo>`. Ex: `smc_m1_e1`.
*   **Exercício:** `<module_id>_ex<numero_exercicio>`. Ex: `smc_m1_ex1`.
*   **Quiz:** `<module_id>_q<numero_quiz>`. Ex: `smc_m1_q1`.
*   **Desafio:** `<module_id>_ch<numero_desafio>`. Ex: `smc_m1_ch1`.
