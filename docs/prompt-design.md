# Interface do Aplicativo com Google Stitch

**Google Stitch** (https://stitch.withgoogle.com/) é uma excelente ferramenta experimental para prototipagem rápida de interfaces web, pois combina componentes do Material Design, classes do Tailwind CSS e permite a inserção de lógica interativa simples (HTML/JS/CSS).

Abaixo está um prompt otimizado para o **Stitch** criar a tela de calculadoras e o menu do aplicativo de forma funcional, permitindo inclusive que a simulação de valores ocorra interativamente na própria ferramenta.

---

## Prompt Otimizado para o Google Stitch

Copie e cole o prompt abaixo no campo de geração do Stitch:

```text
Create a modern, premium mobile-responsive single-page dashboard layout for a trading utility app named "Price Action Master".

Design Style & Theme:
- Use a deep dark background: Tailwind `bg-slate-950` or `bg-[#0a0f0d]`.
- Text colors: Slate gray text for details `text-slate-400` and high-contrast white `text-slate-100` for titles.
- Accents: Bright emerald/cyan (`text-emerald-400`, `bg-emerald-950`) and warm gold/yellow borders (`border-amber-500/30`).
- Typography: Clean sans-serif.

Layout Structure:
1. Navigation Header:
   - Display the app title "Price Action Master" in italic, bold, gold text.
   - Quick navigation tabs: "Home", "Calculadoras", "Padrões Gráficos", "SMC & Elliott". Active tab should be "Calculadoras".

2. Page Title:
   - A bold heading "Calculadoras" and a small description below: "Ferramentas de precisão para sua gestão de risco."

3. Responsive Grid of Calculator Cards:
   - A grid layout (`grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 p-4`) containing 6 cards: DOL, WDO, IND, WIN, BITFUT, CCM.
   - Each card should have:
     * Background `bg-slate-900` or `bg-[#111615]`, a rounded border `rounded-xl`, and a gold-tinted border `border border-amber-500/20`.
     * Card Header: Left side displays the ticker in large bright green bold text (e.g. "DOL" or "WIN") and description below ("DÓLAR CHEIO", "MINI ÍNDICE"). Right side displays rate details in small gray text: e.g. "R$ 50/ponto" and "2 tick/ponto".
     * Inputs section: Two horizontal numeric inputs side-by-side: "Contratos" (default 1) and "Pontos" (default 1). Styled with a dark input background, rounded corners, and a glowing gold border on focus.
     * Outputs section: Two horizontal result boxes side-by-side:
       - "TOTAL TICKS": Background maroon/red (`bg-rose-950/40 border border-rose-900/40 text-rose-300`), large bold centered value.
       - "RESULTADO": Background dark teal (`bg-emerald-950/40 border border-emerald-900/40 text-emerald-300`), large bold centered currency value (e.g., R$ 50,00).
     * Footer link: "Especificações do Contrato" centered at the bottom of the card in small emerald text.

4. Interactive recalculation (HTML/JS):
   - Make the inputs responsive using simple vanilla JavaScript (e.g., inline `oninput` handlers) for each card using their respective formulas:
     - DOL: Total Ticks = Pontos * 2 | Resultado = Contratos * Pontos * 50
     - WDO: Total Ticks = Pontos * 2 | Resultado = Contratos * Pontos * 10
     - IND: Total Ticks = Pontos * 0.2 | Resultado = Contratos * Pontos * 250
     - WIN: Total Ticks = Pontos * 0.2 | Resultado = Contratos * Pontos * 0.2
     - BITFUT: Total Ticks = Pontos * 0.05 | Resultado = Contratos * Pontos * 0.1
     - CCM: Total Ticks = Pontos * 100 | Resultado = Contratos * Pontos * 450
   - Format the "Resultado" output using the Brazilian Real format (e.g., "R$ 50,00").
```

---

## Prompt Otimizado para IA de Design Visual (Galileo AI / Uizard)

Caso também precise gerar no Galileo AI ou Uizard (que geram telas estáticas exportáveis para o Figma), use o seguinte prompt:

```text
Create a modern, premium mobile app UI/UX design for a trading educational and utility app named "Price Action Master". 

The design should feature a clean, sophisticated, and dark-themed interface (using deep dark slate/gray #0C1110 as the background, with bright emerald green #00E5FF and soft gold #C5A059 as accent colors) to evoke a professional trading terminal aesthetic. Keep typography clean using modern sans-serif fonts like Inter or Poppins.

Please generate the following 4 key screens:

1. Home (Inicio) Screen:
- A header with the app name "Price Action Master" in a clean italicized, bold font.
- A welcoming hero banner card describing the tool.
- A vertical list of clean menu options with descriptive icons and chevron arrows, including: "Análise Técnica", "Figuras Gráficas", "Candlesticks", "Smart Money Concepts (SMC)", "Ondas de Elliott", "Calculadoras", "Quiz de Trade", "Simulador", and "Tarot Trader".

2. Calculators (Calculadoras) Screen:
- Header: Title "Calculadoras" and subtitle "Ferramentas de precisão para sua gestão de risco."
- A vertical scrollable feed of calculation cards. Show at least two examples: "DOL (Dólar Cheio)" and "WIN (Mini Índice)".
- Each card must display:
  * Contract symbol (e.g., "DOL") and its full name (e.g., "DÓLAR CHEIO").
  * Small metadata text in the top right: "R$ 50/ponto" and "2 tick/ponto".
  * Two input boxes side-by-side: "Contratos" (input number) and "Pontos" (input number).
  * Two output display boxes side-by-side: "TOTAL TICKS" (maroon/red background with white value) and "RESULTADO" (dark teal background with cyan currency value).
  * A text link at the card bottom: "Especificações do Contrato".

3. Category List Screen (e.g., Candlesticks or Figures):
- A screen listing items in a grid/card format.
- Each card shows a minimalist technical drawing/representation of a pattern (e.g., Hammer Candle or Double Top), the name, and a short summary.

4. Detail Screen (e.g., Pattern Detail):
- A header showing the pattern title (e.g., "Martelo / Hammer").
- A large, high-contrast, clean graphic vector of the chart/candle pattern.
- A structured layout below showing: "Descrição Técnica" (text area) and "Regras de Entrada/Saída" (bulleted list).
```
