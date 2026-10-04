# Guia Completo: Estrutura de Conteúdo e Edição do Aplicativo

Este documento serve como referência técnica e editorial para alterar textos, links, banners, cursos, quizzes, catálogos e ferramentas do **Price Action Master**.

---

## 1. Banners e Links do TradingPlan (Banners Marcados)

Todos os banners institucionais e promocionais estão centralizados na pasta [`lib/components/`](file:///d:/projects/tradingplan/price_action_master/lib/components).

### 🟢 1.1. Banner Promocional Rotativo (`TradingPlanPromoBanner`)
- **Arquivo:** [`lib/components/trading_plan_promo_banner.dart`](file:///d:/projects/tradingplan/price_action_master/lib/components/trading_plan_promo_banner.dart)
- **Localização no App:** Exibido no rodapé da **Home** e no final da lista da aba **Cursos**.
- **Link padrão:** `https://www.tradingplan.com.br` (definido no parâmetro `url: 'https://www.tradingplan.com.br'` na linha 35).

#### Como editar os textos, tags e ícones das mensagens rotativas:
No arquivo [`trading_plan_promo_banner.dart`](file:///d:/projects/tradingplan/price_action_master/lib/components/trading_plan_promo_banner.dart#L46-L65), localize a lista `_allPromos`:

```dart
static const List<PromoContent> _allPromos = [
  PromoContent(
    icon: Icons.auto_graph_rounded,
    title: 'Planilhas & Diário de Trade',
    tag: 'GRÁTIS',
    description: 'Leve sua gestão a sério. Baixe planilhas e diários de trade no portal tradingplan.com.br',
  ),
  PromoContent(
    icon: Icons.public_rounded,
    title: 'Ecossistema Trading Plan',
    tag: 'OFICIAL',
    description: 'Análises de mercado, setups diários e ferramentas exclusivas no portal tradingplan.com.br',
  ),
  PromoContent(
    icon: Icons.calculate_rounded,
    title: 'Ferramentas & Gestão de Risco',
    tag: 'ACESSAR',
    description: 'Acesse simuladores de lote, checklists operacionais e gestão no portal tradingplan.com.br',
  ),
];
```
> **Dica:** Você pode adicionar novas frases, alterar o texto da tag (ex: `GRÁTIS`, `NOVO`, `PRO`) ou mudar a URL de destino de qualquer instância.

---

### 🟢 1.2. Banner da Logo do Trading Plan (`TradingPlanLogoWidget`)
- **Arquivo:** [`lib/components/trading_plan_logo/trading_plan_logo_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/components/trading_plan_logo/trading_plan_logo_widget.dart)
- **Localização no App:** Rodapé inferior da Home.
- **Link de destino:** Linha 39:
  ```dart
  final uri = Uri.parse('https://www.tradingplan.com.br');
  ```
- **Imagem exibida:** `assets/images/TP-logo-website-URL-500x60-white.png` (Linha 55).

---

### 📱 1.3. Espaço de Anúncios / Ad Banner Placeholder (`AdBannerPlaceholder`)
- **Arquivo:** [`lib/components/ad_banner_placeholder.dart`](file:///d:/projects/tradingplan/price_action_master/lib/components/ad_banner_placeholder.dart)
- **Localização no App:** Posicionado entre o banner promocional e a logo do TradingPlan na Home.
- **Finalidade:** Espaço reservado para futura monetização com *Google AdMob / Unity Ads*.
- **Como integrar AdMob:** Quando for integrar o SDK oficial (`google_mobile_ads`), substitua o conteúdo do `child` deste container pelo `AdWidget(ad: bannerAd)`.

---

## 2. Estrutura e Edição dos Cursos

Todos os cursos funcionam **100% offline** e seus dados estão estruturados em arquivos JSON limpos na pasta [`content/courses/`](file:///d:/projects/tradingplan/price_action_master/content/courses).

### 📁 Arquivos de Cursos Disponíveis:
1. [`content/courses/analise_tecnica.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/analise_tecnica.json) — Análise Técnica Clássica
2. [`content/courses/candlesticks.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/candlesticks.json) — Velas Japonesas
3. [`content/courses/figuras.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/figuras.json) — Figuras Gráficas
4. [`content/courses/smc.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/smc.json) — Smart Money Concepts (SMC)
5. [`content/courses/elliott.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/elliott.json) — Teoria das Ondas de Elliott
6. [`content/courses/gestao_risco.json`](file:///d:/projects/tradingplan/price_action_master/content/courses/gestao_risco.json) — Gestão de Risco & Psicologia
7. [`content/courses/wyckoff.json`](file:///d:/projects/tradingplan/price_master/content/courses/wyckoff.json) — Metodologia Wyckoff

### 📝 Como Editar ou Criar Módulos de um Curso:
Abra o arquivo `.json` correspondente. A estrutura básica é:

```json
{
  "id": "analise_tecnica",
  "title": "Análise Técnica Clássica",
  "description": "Fundamentos da Teoria de Dow, suportes, resistências e tendências.",
  "modules": [
    {
      "id": "modulo_1",
      "title": "Teoria de Dow e Estrutura de Mercado",
      "description": "Os 6 princípios fundamentais de Charles Dow.",
      "lessons": [
        {
          "id": "licao_1_1",
          "title": "Princípio 1: Os Preços Descontam Tudo",
          "content": "# Os Preços Descontam Tudo\n\nTodo o conhecimento disponível...",
          "diagramType": "dow_theory_chart"
        }
      ]
    }
  ]
}
```
- **Campos:**
  - `title`: Título do curso ou módulo.
  - `description`: Resumo exibido nos cards.
  - `content`: Conteúdo pedagógico formatado em Markdown (títulos `#`, listas `-`, negrito `**`, blocos de alerta).

---

## 3. Estrutura e Edição dos Quizzes (Simulados)

- **Arquivo:** [`assets/jsons/quiz.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/quiz.json)
- **Localização no App:** Aba **Quiz** (`QuizWidget`).
- **Comportamento:** O app seleciona aleatoriamente questões a cada rodada e permite filtrar por categorias (Geral, Candlesticks, Figuras, SMC, Elliott).

### Como Adicionar ou Modificar Perguntas:
Abra [`assets/jsons/quiz.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/quiz.json) e adicione um novo objeto na lista `questions`:

```json
{
  "id": "q26",
  "category": "Candlesticks",
  "question": "Qual padrão de candle indica forte rejeição de preços baixos após uma tendência de baixa?",
  "options": [
    "Estrela Cadente",
    "Martelo",
    "Marubozu de Baixa",
    "Harami de Baixa"
  ],
  "correctIndex": 1,
  "explanation": "O Martelo possui sombra inferior longa (pelo menos 2x o corpo) e indica entrada de força compradora após a mínima."
}
```
- `options`: Lista com as 4 alternativas de resposta.
- `correctIndex`: Índice da resposta correta (0 = 1ª opção, 1 = 2ª opção, 2 = 3ª opção, 3 = 4ª opção).
- `explanation`: Explicação didática exibida após a resposta do usuário.

---

## 4. Estrutura e Edição de Catálogos (Candles, Figuras, Conceitos)

Localizados na pasta [`assets/jsons/`](file:///d:/projects/tradingplan/price_action_master/assets/jsons):

| Arquivo | Conteúdo | Tela do App |
| :--- | :--- | :--- |
| [`candlesticks.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/candlesticks.json) | Catálogo completo de padrões de candlestick (alta, baixa, reversão, continuação). | Aba **Candlesticks** (`VelasJaponesasWidget`) |
| [`figuras.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/figuras.json) | Figuras gráficas clássicas (OCO, Triângulos, Topos Duplos, Bandeiras). | `FigurasGraficasWidget` |
| [`conceitos.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/conceitos.json) | Conceitos teóricos de análise técnica. | `AnaliseTecnicaWidget` |
| [`tarot_cards.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/tarot_cards.json) | Cartas e reflexões psicológicas de trading. | `TarotWidget` |

---

## 5. Estrutura e Edição das Telas Principais

| Aba / Tela | Arquivo Dart de Visualização | Arquivo de Dados / Lógica |
| :--- | :--- | :--- |
| 🏠 **Home** | [`lib/pages/inicio/inicio_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/inicio/inicio_widget.dart) | Hero Banner, Cursos em Destaque, Atalhos de Ferramentas e Banners |
| 🎓 **Cursos** | [`lib/pages/cursos/cursos_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/cursos/cursos_widget.dart) | [`content/courses/*.json`](file:///d:/projects/tradingplan/price_action_master/content/courses) |
| 📐 **Calculadoras** | [`lib/pages/calculadoras/calculadoras_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/calculadoras/calculadoras_widget.dart) | Calculadoras de Lote, Tamanho de Posição e Risco/Retorno |
| 🕯️ **Candlesticks** | [`lib/pages/velas_japonesas/velas_japonesas_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/velas_japonesas/velas_japonesas_widget.dart) | [`assets/jsons/candlesticks.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/candlesticks.json) |
| ❓ **Quiz** | [`lib/pages/quiz/quiz_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/quiz/quiz_widget.dart) | [`assets/jsons/quiz.json`](file:///d:/projects/tradingplan/price_action_master/assets/jsons/quiz.json) |
| ⚙️ **Ajustes** | [`lib/pages/ajustes/ajustes_widget.dart`](file:///d:/projects/tradingplan/price_action_master/lib/pages/ajustes/ajustes_widget.dart) | Tema, Notificações locais e dados do app |
| 🧭 **Barra de Navegação** | [`lib/main.dart`](file:///d:/projects/tradingplan/price_action_master/lib/main.dart) | Ordem e ícones das 6 abas (`NavBarPage`) |
| 🛣️ **Rotas & Navegação** | [`lib/flutter_flow/nav/nav.dart`](file:///d:/projects/tradingplan/price_action_master/lib/flutter_flow/nav/nav.dart) | Registro GoRouter de todas as páginas |

---

## 6. Boas Práticas ao Editar Conteúdos

1. **Validação do JSON:** Ao editar qualquer arquivo `.json` em `assets/jsons/` ou `content/courses/`, certifique-se de que a formatação JSON seja válida (cuidado com vírgulas extras no final de listas).
2. **Offline-First:** Não adicione links externos obrigatórios para carregar imagens essenciais. Se precisar de novas imagens ou ícones, coloque-os na pasta `assets/images/` e declare no `pubspec.yaml`.
3. **Teste Rápido:** Salve os arquivos e pressione **`r`** (Hot Reload) no terminal do Flutter para testar imediatamente no seu celular ou emulador.
