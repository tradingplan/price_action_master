# Platform Development Roadmap

Visão estratégica para evolução da plataforma educacional e do ecossistema de ferramentas de trading.

---

## ✅ Fase 1: Arquitetura Orientada a Dados & Workspace (Concluída)
*   `[x]` Desacoplamento de dados JSON e renderizadores genéricos de tela.
*   `[x]` Estruturação formal do AI Workspace (`.agents/`).
*   `[x]` Implementação do Content CLI e Content Validator em `/tools/`.

---

## ✅ Fase 2: Expansão de Cursos, Gamificação & Certificados (Concluída)
*   `[x]` Expansão completa das 5 disciplinas (Candlesticks, SMC, Elliott, Figuras e Gestão de Risco).
*   `[x]` Implementação do sistema local de Repetição Espaçada (Leitner System com 5 caixas) e fila na Home.
*   `[x]` Emissão de Certificados Digitais com hash criptográfico SHA-256 e visualizador dedicado.
*   `[x]` Módulo Tarot Trader: 22 arquétipos psicológicos, viés diário, flip 3D e persistência local.

---

## ✅ Fase 3: Calculadoras Multi-Mercado & Consolidação (Concluída)
*   `[x]` Atlas de Candlesticks expandido com 20 padrões, ilustrações e gráficos reais de alta resolução.
*   `[x]` Calculadoras de Mercado B3 (DOL, WDO, IND, WIN, CCM, BITFUT) com especificações de contrato.
*   `[x]` Calculadoras Mercado Americano CME (NQ, MNQ, ES, MES, GC, MGC, CL, MCL) em US$.
*   `[x]` Simulador avançado de Lucro Forex & Pips (9 pares, moedas USD/BRL, taxa de câmbio).
*   `[x]` Filtros dinâmicos por categoria de mercado (`Todos`, `B3`, `Mercado Americano`, `Forex`).
*   `[x]` Integração com Ecossistema Trading Plan, Lead Magnets, Compartilhamento e Política de Privacidade.
*   `[x]` Hardening da base de código: 0 erros e 0 warnings no `flutter analyze`.

---

## 🚀 Próxima Fase: Publicação nas Lojas & Simulador Interativo (Q1 2027+)
*   `[ ]` Empacotamento de builds de produção para Google Play Store (.aab) e Apple App Store (.ipa).
*   `[ ]` Implementação de Cenários Operacionais (Case Studies) interativos baseados em replay de candles.
*   `[ ]` Pipeline CI no GitHub Actions para rodar o `content_validator.py` automaticamente a cada PR.
