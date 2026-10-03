# Current Architecture Reference — Price Action Master

Este documento detalha a arquitetura técnica, fluxo de dados e design de componentes da aplicação **Price Action Master**, consolidada na versão de produção.

---

## 1. Visão Geral da Arquitetura

O Price Action Master é construído como um **interpretador orientado a dados (data-driven)** sobre o Flutter, com arquitetura **100% offline-first**.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                            FLUTTER PRESENTATION                             │
│                                                                             │
│  [ InicioWidget ] ──┬── [ Cursos & Timeline ] ── [ Step Renderers ]         │
│                     ├── [ CandlestickAtlasWidget ] ── [ High-Res Modal ]    │
│                     ├── [ CalculadorasWidget ] ── [ B3 / CME / Forex Cards ]│
│                     ├── [ TarotTraderWidget ] ── [ 3D Flip Card ]           │
│                     ├── [ CertificateViewerWidget ] ── [ SHA-256 Viewer ]   │
│                     └── [ AjustesWidget ] ── [ Share / Privacy / Links ]    │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
┌──────────────────────────────────────▼──────────────────────────────────────┐
│                              APPLICATION LOGIC                              │
│                                                                             │
│  • LocalCourseRepository (Lê JSONs dos assets)                              │
│  • LocalDataManager (SharedPreferences + JSONs no disco)                    │
│  • SpacedRepetitionEngine (Algoritmo Leitner com 5 caixas)                  │
│  • GenericVectorPainter (Renderizador Canvas 60 FPS com coords relativas)   │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
┌──────────────────────────────────────▼──────────────────────────────────────┐
│                             LOCAL DATA & ASSETS                             │
│                                                                             │
│  • content/courses/*.json (Candlesticks, SMC, Elliott, Figuras, Risco)     │
│  • content/tarot/tarot-trader-cartas.json (22 Arquétipos)                   │
│  • assets/images/candlesticks/*.png (20 Ilustrações + Gráficos Reais)       │
│  • SharedPreferences & Local Files (Quiz History, Tarot History, XP)        │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Camadas do Sistema

### A. Camada de Apresentação (UI)
1. **Inicio (`inicio_widget.dart`):** Hub central exibindo métricas de XP, nível atual, cards de acesso aos módulos (Cursos, Atlas de Candlesticks, Calculadoras, Tarot Trader), fila de Repetição Espaçada ativa e Card de Ecossistema Trading Plan.
2. **Cursos & Lições (`detalhe_curso_widget.dart`, `modulo_steps_widget.dart`):** Renderiza o conteúdo das etapas pedagógicas dinamicamente através de renderizadores dedicados (`LessonRenderer`, `ExampleRenderer`, `ExerciseRenderer`, `QuizRenderer`, `ChallengeRenderer`).
3. **Atlas de Candlesticks (`candlesticks_atlas_widget.dart`):** Catálogo de 20 padrões com filtros de sentimento (Bullish, Bearish, Indecision), visualização de anatomia, checklist de confirmação e modal para ampliação de gráficos reais de alta resolução.
4. **Calculadoras Multi-Mercado (`calculadoras_widget.dart`):** Simulador financeiro com filtros de categoria (`Todos`, `B3`, `Mercado Americano`, `Forex`). Suporta ticks, pontos, especificações de margem e simulador de lote/pips com taxas de conversão USD/BRL.
5. **Tarot Trader (`tarot_trader_widget.dart`):** Animação de flip 3D no eixo Y (450ms), calibração de viés diário e histórico de 90 dias.
6. **Visualizador de Certificados (`certificate_viewer_widget.dart`):** Renderiza o certificado digital com assinatura criptográfica SHA-256 e ementa do curso.

### B. Camada de Domínio e Dados Locais
1. **`LocalCourseRepository`:** Carrega e decodifica os arquivos JSON de `content/courses/` empacotados nos assets da aplicação, validando os tipos de cada módulo.
2. **`LocalDataManager` (`lib/backend/local_data_manager.dart`):**
   - Gerencia a persistência de XP, progresso de módulos, caixas de repetição espaçada e dados de tiragem do Tarot usando `SharedPreferences`.
   - Salva e recupera históricos transacionais locais em arquivos JSON no diretório de suporte da aplicação.
3. **`GenericVectorPainter`:** Renderizador vetorial nativo em Flutter Canvas que interpreta coordenadas relativas no intervalo `[0.0, 1.0]` para desenhar gráficos de candles, Order Blocks, Fair Value Gaps (FVG), ondas de Elliott e zonas de liquidez com suavização e 60 FPS.

---

## 3. Estratégia de Conteúdo e Autoria (Content SDK)

O conteúdo educacional é desacoplado do código-fonte Dart:
- **Schemas Rígidos:** `content/schemas/` valida a estrutura de cursos (`course.schema.json`) e cartas do Tarot (`tarot.schema.json`).
- **Ferramentas CLI:**
  - `tools/content_cli.py`: Cria cursos, módulos e lições padronizados.
  - `tools/content_validator.py`: Valida todo o conteúdo estático garantindo conformidade antes de qualquer build.

---

## 4. Integração com o Ecossistema Trading Plan

- **Logotipo Interativo:** Abre `https://www.tradingplan.com.br` no navegador externo através do `url_launcher`.
- **Card Promocional & Lead Magnet:** Promove planilhas de gestão e diários de trade na tela inicial e na tela de calculadoras.
- **Ajustes:**
  - Compartilhar aplicativo nativo com mensagem de convite.
  - Link direto para a Política de Privacidade (`https://tradingplan.com.br/pv/pam-privacy/`).

---

## 5. Garantia de Qualidade & Linter

- Análise estática contínua via `flutter analyze` mantendo **0 erros e 0 warnings**.
- Suíte de testes automatizados (`flutter test`) cobrindo parsers de dados, lógica do Tarot e gerenciamento de estado local.
