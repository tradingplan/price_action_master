# Price Action Master — Learning Platform & AI Workspace

Plataforma educacional e analítica **offline-first** de alta performance para o ensino prático de **Price Action**, **Smart Money Concepts (SMC)**, **Teoria das Ondas de Elliott**, **Figuras Gráficas**, **Gestão de Risco** e **Psicologia Operacional** aplicados ao mercado financeiro.

Este repositório está estruturado como um **AI Workspace** modular, separando a engenharia de renderização (Flutter) da modelagem de conteúdo educacional (JSON, Schemas e Ferramentas).

---

## 🏗️ Módulos e Recursos da Plataforma

```text
                               ┌─────────────────────────────┐
                               │     Price Action Master     │
                               └──────────────┬──────────────┘
                                              │
         ┌──────────────────┬─────────────────┼─────────────────┬──────────────────┐
         ▼                  ▼                 ▼                 ▼                  ▼
  [ 🎓 Cursos JSON ] [ 🕯️ Candlesticks ] [ 🧮 Calculadoras ] [ 🔮 Tarot Trader ] [ 📜 Certificados ]
         │                  │                 │                 │                  │
         ▼                  ▼                 ▼                 ▼                  ▼
  • Price Action     • 20 Padrões       • B3 (DOL, WIN...) • 22 Arquétipos    • SHA-256 Local
  • SMC              • Anatomia Técnica • CME (NQ, ES...)  • Viés Cognitivo   • Validador Offline
  • Elliott          • Gráficos Reais   • Forex & Pips     • Flip 3D (60fps)  • PDF / Visualizador
  • Figuras          • Modal Interativo • BRL & USD        • Histórico 90d
  • Gestão de Risco
```

### 1. 🎓 Cursos & Ementa Educacional (Data-Driven)
- **Disciplinas:** Candlesticks, Figuras Gráficas, Smart Money Concepts (SMC), Ondas de Elliott e Gestão de Risco.
- **Estrutura por Módulo:** Lição (`Lesson`), Exemplos (`Examples`), Exercícios (`Exercises`), Quizzes com feedback explicativo (`Quiz`) e Desafios com tempo (`Challenge`).
- **Diagramas Vetoriais a 60 FPS:** Renderização geométrica pura via `GenericVectorPainter` nativo no Canvas (`[0.0, 1.0]`), sem dependência de conexões de rede externas.

### 2. 🕯️ Atlas de Candlesticks & Galeria Gráfica
- **Catálogo de 20 Padrões Clássicos:** Doji, Martelo, Estrela Cadente, Engolfo de Alta/Baixa, Nuvem Negra, Bebê Abandonado, Pinbar, etc.
- **Análise Técnica Completa:** Anatomia da vela, psicologia do movimento, checklist de confirmação e força do sinal.
- **Gráficos Reais:** Imagens de alta resolução integradas localmente nos assets (`assets/images/candlesticks/`) com visualizador ampliado em modal interativo.

### 3. 🧮 Calculadoras de Mercado & Gestão de Risco
- **Filtros por Segmento:** `Todos`, `B3 🇧🇷`, `Mercado Americano 🇺🇸` e `Forex 💱`.
- **B3 (Mercado Futuro Brasileiro):** DOL (Dólar Cheio), WDO (Mini Dólar), IND (Índice Cheio), WIN (Mini Índice), CCM (Milho Futuro) e BITFUT (Bitcoin Futuro), com cálculo instantâneo de ticks e resultado em R$.
- **Mercado Americano (CME / COMEX / NYMEX):** NQ (E-mini Nasdaq), MNQ (Micro Nasdaq), ES (E-mini S&P 500), MES (Micro S&P), GC (Gold Futures), MGC (Micro Gold), CL (Crude Oil WTI) e MCL (Micro WTI), com cálculos em US$.
- **Simulador de Lucro Forex & Pips:** Suporte a pares principais (`EURUSD`, `GBPUSD`, `USDJPY`, `USDCHF`, `AUDUSD`, `USDCAD`, `NZDUSD`, `XAUUSD`, `HK50`), seleção da moeda da conta (USD / BRL), taxa de câmbio USD/BRL, direção Compra/Venda, cálculo em tempo real de pips e valor do pip.
- **Especificações de Contrato:** Modal detalhado com horários de negociação, margens requeridas, lote mínimo e código de vencimento.

### 4. 🔮 Tarot Trader (Psicologia & Gestão Emocional)
- **22 Arquétipos Comportamentais:** Baseados nos perfis psicológicos do trader sob estresse e euforia.
- **Calibração de Viés:** Identificação diária de polaridade (*Bull*, *Bear*, *Neutro*), cálculo dinâmico de `psych_load` (0-100%) e antídotos operacionais práticos.
- **Animação 3D:** Efeito de virada de carta (Flip 3D) com aceleração de hardware nativa.
- **Persistência Offline:** Histórico diário de tiragens mantido localmente por 90 dias com bonificação de +25 XP na primeira leitura diária.

### 5. 🔁 Sistema de Repetição Espaçada (Leitner System)
- Algoritmo local de repetição espaçada integrado ao `LocalDataManager`.
- Distribuição de questões em 5 caixas de revisão baseadas na taxa de acerto do usuário, gerando fila de revisão inteligente na tela inicial.

### 6. 📜 Certificados Digitais Criptográficos
- Emissão local e offline de certificados de conclusão de curso após término de todas as lições e avaliações.
- Assinatura criptográfica SHA-256 gerada no dispositivo e visualizador dedicado com QR Code e detalhes da ementa.

### 7. 🌐 Integração com Ecossistema Trading Plan
- **Acesso ao Portal Oficial:** Link direto e intuitivo para [tradingplan.com.br](https://www.tradingplan.com.br).
- **Lead Magnet Integrado:** Banners educacionais promovendo planilhas de trading e diários de bordo gratuitos.
- **Ajustes & Compliance:** Funcionalidade nativa de compartilhamento do aplicativo e link direto para a [Política de Privacidade Oficial](https://tradingplan.com.br/pv/pam-privacy/).

---

## 📂 Estrutura de Diretórios

O workspace está organizado para manutenção ágil por agentes de IA e desenvolvedores humanos:

*   [`.agents/`](file:///.agents/): Perfis e diretrizes de IA (Regras do workspace e constraints).
*   [`content/`](file:///content/):
    *   [`courses/`](file:///content/courses/): Banco de dados de cursos ativos (`candlesticks.json`, `figuras.json`, `smc.json`, `elliott.json`, `gestao_risco.json`).
    *   [`tarot/`](file:///content/tarot/): Catálogo declarativo do **Tarot Trader** (`tarot-trader-cartas.json`).
    *   [`schemas/`](file:///content/schemas/): Schemas JSON que validam a integridade dos cursos e cartas.
    *   [`examples/`](file:///content/examples/): Exemplos de JSONs para referência rápida.
*   [`docs/`](file:///docs/):
    *   [`00-project/`](file:///docs/00-project/): Changelogs, Roadmap, Contexto e Regras.
    *   [`01-platform/`](file:///docs/01-platform/): Especificações do SDK, Spaced Repetition e ADRs de arquitetura.
    *   [`02-learning/`](file:///docs/02-learning/): Guias pedagógicos e andragógicos.
    *   [`CURRENT_ARCHITECTURE.md`](file:///docs/CURRENT_ARCHITECTURE.md): Auditoria técnica e visão da arquitetura atual.
*   [`lib/`](file:///lib/): Código-fonte da aplicação Flutter (Páginas, Componentes, Backend local e Models).
*   [`assets/`](file:///assets/): Imagens em alta resolução de candlesticks, fontes e ícones locais.
*   [`templates/`](file:///templates/): Modelos JSON em branco para criação de novos módulos, lições e quizzes.
*   [`tools/`](file:///tools/): Utilitários CLI em Python (`content_cli.py`, `content_validator.py`).

---

## 🛠️ Ferramentas Editoriais (Content SDK)

### 1. Criar novo Conteúdo (Content CLI)
Gera automaticamente estruturas JSON em conformidade com as regras do projeto:
```bash
# Criar um novo curso
python tools/content_cli.py create-course <id_do_curso> "Nome do Curso" "Descrição Curta"

# Criar um novo módulo no curso
python tools/content_cli.py create-module <id_do_curso> <id_do_modulo> "Nome do Módulo" "Descrição" --xp 100

# Criar uma nova lição
python tools/content_cli.py create-lesson <id_do_curso> <id_do_modulo> <id_da_licao> "Título da Lição" "Conteúdo em Markdown"
```

### 2. Validar Estrutura e Schemas (Content Validator)
Valida a integridade de todas as lições, coordenadas vetoriais do Canvas e quizzes frente aos schemas oficiais:
```bash
python tools/content_validator.py
```

---

## 🚀 Como Executar o Projeto Flutter

### Pré-requisitos
*   **Flutter SDK** (versão 3.x stable).
*   **Python 3.x** (para validação e ferramentas de conteúdo).

### Passo a Passo
1.  Obtenha as dependências do projeto:
    ```bash
    flutter pub get
    ```
2.  Execute a suíte de testes automatizados:
    ```bash
    flutter test
    ```
3.  Execute a análise estática do linter:
    ```bash
    flutter analyze
    ```
4.  Execute a aplicação no dispositivo de destino:
    ```bash
    # Para Chrome / Web
    flutter run -d chrome

    # Para Emulador ou Dispositivo Físico Android
    flutter run -d android
    ```

---

## 🛡️ Diretrizes Técnicas Fundamentais

1. **Offline-First de Custo Zero:** O catálogo educacional, calculadoras, galeria visual e tarot funcionam 100% sem conexão com a internet.
2. **Persistência Local Dedicada:** Todo o estado persistido do usuário é gravado localmente via `LocalDataManager` (SharedPreferences e JSONs locais).
3. **Diagramas Vetoriais em Canvas:** `CustomPainter` nativo desenhando esquemas gráficos pedagógicos a 60 FPS com coordenadas relativas.
4. **Nenhum Placeholder:** Todas as telas, calculadoras e lições possuem dados, cálculos e imagens reais prontos para uso em produção.

---

## 🌐 Landing Page & Guias de Publicação

- **Landing Page Oficial do App:** Desenvolvida em [`landing/`](landing) com simuladores de gráficos e calculadoras B3 em tempo real.
- **Guia Completo de Publicação:** Consulte [`docs/GUIA_PUBLICACAO_STORES_E_LANDING_PAGE.md`](docs/GUIA_PUBLICACAO_STORES_E_LANDING_PAGE.md) para o passo a passo de deploy na Hostinger, lançamento na Apple App Store (iOS) e atualização na Google Play Store (Android).
