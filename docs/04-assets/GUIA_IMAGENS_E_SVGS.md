# Guia Completo de Imagens, Vetores (SVG) e Assets
**Price Action Master — Padrões Visuais, Otimização e Implementação Técnica**

---

## 1. Visão Geral dos Formatos no Aplicativo

O **Price Action Master** é um aplicativo educativo projetado sob a filosofia **Offline-First**, com foco em alta performance visual, nitidez cristalina e baixo consumo de armazenamento e memória.

### Comparativo: SVG (Vetorial) vs. PNG/WebP (Rasterizado)

| Critério | Vetor (.svg) | Imagem Rasterizada (.png / .webp) |
| :--- | :--- | :--- |
| **Resolução / Zoom** | **Infinita:** Não perde qualidade em nenhum tamanho ou densidade de tela. | **Fixa em pixels:** Pode granular ou ficar borrada ao dar zoom ou em telas `@3x`. |
| **Tamanho Médio** | **3 KB a 20 KB** *(redução de até 90%+)*. | **50 KB a 400 KB**. |
| **Pastas de Densidade** | **Arquivo Único:** Um único arquivo atende todos os dispositivos. | Exige múltiplas versões (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`). |
| **Consumo de Memória (RAM)** | Muito baixo ao carregar listas longas de cards. | Maior consumo de cache de texturas na GPU. |
| **Melhor Aplicação** | Ícones, esquemas de candlesticks, figuras gráficas e diagramas. | Prints reais de plataformas de trading (TradingView, MT5) com milhares de pontos. |

---

## 2. Dimensões e Proporções Recomendadas

Mesmo no formato vetorial (SVG), definir um `viewBox` com a proporção adequada garante que o desenho preencha os containers do app sem distorções:

| Tipo de Asset | Onde é Usado no App | Proporção | Dimensões Ideais (viewBox ou px) | Formato Ideal |
| :--- | :--- | :---: | :---: | :---: |
| **Ícones de Candlesticks** | Cards do catálogo, listas e topo do detalhe | **1:1** (Quadrado) | `viewBox="0 0 360 360"` *(ou 256x256 px)* | `.svg` |
| **Gráficos de Exemplo (Candlesticks)** | Exemplo ilustrativo na tela de detalhes | **16:9** ou **16:10** | `viewBox="0 0 800 500"` *(ou 800x500 px)* | `.svg` ou `.webp` |
| **Diagramas de Exemplos de Cursos** | Aba "Exemplos" dos módulos de cursos | **16:9** ou **5:3** | `viewBox="0 0 400 240"` *(ou 800x480 px)* | `.svg` ou `vectorCanvas` (JSON) |
| **Banner Hero da Home** | Card de destaque da página inicial | **16:10** | `800 x 520 px` | `.png` ou `.webp` |
| **Launcher Icon / Favicon** | Ícone do App no celular e aba do navegador | **1:1** (Quadrado) | `512 x 512 px` ou `1024 x 1024 px` | `.png` |
| **Tela de Splash** | Abertura do app (fundo branco `#FFFFFF`) | **9:16** (Vertical) | `1080 x 1920 px` ou `1280 x 1920 px` | `.png` |

---

## 3. Vetorização Real vs. Imagem Embutida

Ao converter imagens de PNG para SVG (usando sites como Kittl, Figma, Adobe Illustrator, Inkscape ou Vectorizer.ai), certifique-se de gerar uma **Vetorização Real**:

### ✅ Vetorização Real (Correta)
O arquivo SVG é composto por tags `<path>`, `<polygon>` ou `<rect>` com coordenadas e cores:
```xml
<svg xmlns="http://www.w3.org/2000/svg" width="360" height="360" viewBox="0 0 360 360">
  <g>
    <path d="M 61.81 274.27 L 56.00 271.00 ..." fill="rgb(87,162,63)"/>
    <path d="M 306.00 122.00 L 300.00 273.00 ..." fill="rgb(213,21,39)"/>
  </g>
</svg>
```
* **Vantagens:** Arquivo levíssimo, nitidez 100% perfeita em qualquer dispositivo.

### ❌ Imagem Embutida em SVG (Evitar)
Alguns conversores genéricos apenas codificam o PNG dentro de uma tag `<image>`:
```xml
<!-- NÃO UTILIZAR: Continua sendo um PNG pesado disfarçado de SVG -->
<svg ...>
  <image href="data:image/png;base64,iVBORw0KGgo..." />
</svg>
```

---

## 4. Arquitetura de Renderização no Flutter

O projeto utiliza uma arquitetura unificada de renderização de imagens através do componente **`SafeImageWidget`** (`lib/components/safe_image_widget.dart`):

```
┌────────────────────────────────────────────────────────┐
│                   SafeImageWidget                      │
└──────────────────────────┬─────────────────────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
   Arquivo .svg      Arquivo .png/.jpg     Fallback
 (SvgPicture.asset)    (Image.asset)    (Ícone do Tema)
```

### Principais recursos do `SafeImageWidget`:
1. **Detecção Automática:** Identifica se o caminho termina em `.svg` e utiliza o motor nativo `flutter_svg` (`SvgPicture.asset` / `SvgPicture.network`).
2. **Imagens Rasterizadas:** Renderiza `.png`, `.jpg`, `.webp` via `Image.asset` ou `CachedNetworkImage`.
3. **Resiliência e Fallback:** Se um arquivo não existir ou falhar, exibe um placeholder elegante do tema com o ícone de candlestick, evitando telas quebradas ou travamentos.

---

## 5. Passo a Passo para Adicionar ou Atualizar Imagens

Para adicionar novos padrões ou trocar imagens existentes por SVGs:

### Passo 1: Salvar o arquivo no projeto
Coloque os arquivos `.svg` ou `.png` na pasta correspondente:
- **Candlesticks:** `assets/images/candlesticks/`
- **Imagens Gerais:** `assets/images/`

> **Convenção de Nomes:** Utilize nomes padronizados em *kebab-case* numerados:
> - Ícone: `2-doji.svg`, `3-shooting-star.svg`, `5-hammer.svg`
> - Gráfico: `2-doji-chart.svg`, `3-shooting-star-chart.svg`, `5-hammer-chart.svg`

### Passo 2: Atualizar o catálogo JSON
Edite o arquivo `assets/jsons/candlesticks.json` apontando para o novo arquivo:
```json
{
  "id": "candle-05",
  "nome": "Martelo",
  "icon": "assets/images/candlesticks/5-hammer.svg",
  "chart": "assets/images/candlesticks/5-hammer-chart.svg"
}
```

### Passo 3: Ciclo de Atualização e Teste no Ambiente
- **No Navegador (Chrome):** Se novos arquivos ou pacotes foram adicionados, faça um **Hot Restart** pressionando **`R`** no terminal (ou pare com **`q`** e execute `flutter run -d chrome`).
- **No Celular (Android):** Compile o novo instalador com `flutter build apk --debug`.

---

## 6. Diagramas e Ilustrações dos Cursos: Vector Canvas (JSON) vs. Figuras SVG

Na aba **"Exemplos"** dos módulos dos cursos (como em *Confluência e Leitura de Contexto*, *SMC*, *Elliott*, *Wyckoff*), o aplicativo oferece **duas abordagens complementares** para exibir esquemas gráficos:

```
                  ┌─────────────────────────────────────┐
                  │          ExampleRenderer            │
                  └──────────────────┬──────────────────┘
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼                                       ▼
    Abordagem 1: Campo "image"              Abordagem 2: "vectorCanvas"
      (Arquivos .svg ou .png)                (Canvas Vetorial em JSON)
    • Desenhados no Figma/Illustrator       • Renderizado nativamente a 60 FPS
    • SVG importado em assets/images/       • Coordenadas normalizadas (0.0 a 1.0)
    • Nitidez vetorial cristalina           • Cores adaptadas ao tema Dark/Light
```

---

### 6.1. Abordagem 1: Figuras Precisas em SVG (Recomendada para Ilustrações Ricas)

Ideal quando você deseja desenhar diagramas elaborados no **Figma**, **Adobe Illustrator**, **Canva**, **Kittl** ou exportar capturas do **TradingView**:

1. Crie ou exporte seu diagrama como `.svg` e salve em:
   `assets/images/courses/confluencia_suporte.svg`
2. No JSON do curso correspondente (`content/courses/*.json`), adicione o campo `"image"` no objeto de exemplo:

```json
{
  "id": "candlesticks_m4_e1",
  "title": "Confluência Perfeita em Suporte",
  "description": "O Martelo coincide com o suporte horizontal prévio e a LTA.",
  "image": "assets/images/courses/confluencia_suporte.svg"
}
```

O `ExampleRenderer` renderizará o SVG automaticamente com **resolução infinita** através do `SafeImageWidget`.

---

### 6.2. Abordagem 2: Canvas Vetorial Dinâmico em JSON (`vectorCanvas`)

O motor nativo do app possui o [`GenericVectorPainter`](file:///d:/projects/tradingplan/price_action_master/lib/pages/course/renderers/vector_painter.dart), que interpreta instruções de desenho diretamente do JSON:

```json
"vectorCanvas": {
  "width": 200,
  "height": 120,
  "elements": [
    { "type": "line", "x1": 0.05, "y1": 0.90, "x2": 0.95, "y2": 0.35, "colorStyle": "primary" },
    { "type": "dotted_line", "x1": 0.05, "y1": 0.65, "x2": 0.95, "y2": 0.65, "colorStyle": "success" },
    { "type": "candle", "cx": 0.60, "cy": 0.60, "x1": 0.06, "y1": 0.02, "y2": 0.18, "content": "green" },
    { "type": "circle", "cx": 0.60, "cy": 0.65, "r": 0.04, "colorStyle": "success" },
    { "type": "text", "x": 0.52, "y": 0.42, "content": "Confluência Tripla", "colorStyle": "success" }
  ]
}
```

#### Tipos de Elementos Disponíveis no `vectorCanvas`:
| Elemento | Parâmetros Principais | Exemplo de Aplicação |
| :--- | :--- | :--- |
| `line` | `x1`, `y1`, `x2`, `y2`, `colorStyle` | Linhas de Tendência (LTA/LTB), suportes e resistências. |
| `dotted_line` | `x1`, `y1`, `x2`, `y2`, `colorStyle` | Níveis de retração de Fibonacci, rompimentos testados. |
| `candle` | `cx`, `cy` (centro), `x1` (corpo), `y1` (sombra sup), `y2` (sombra inf), `content` (`"green"` ou `"red"`) | Velas individuais ou sequências de padrões. |
| `circle` | `cx`, `cy`, `r` (raio), `colorStyle` | Destaque de zonas de gatilho, confluências ou retestes. |
| `text` | `x`, `y`, `content`, `colorStyle` | Legendas e anotações técnicas na tela. |

#### Posso gerar esse código separadamente?
**Sim!** Você pode criar um script gerador (Python, Node.js, prompt de IA ou utilitário web) que calcule as coordenadas normalizadas (entre `0.0` e `1.0`), gere o bloco JSON e você apenas cola no arquivo do curso.

---

### 6.3. Guia de Escolha: SVG vs. VectorCanvas

| Necessidade | Recomendação | Por quê? |
| :--- | :---: | :--- |
| Diagramas complexos com curvas, setas elaboradas e ícones | **`.svg`** | Maior liberdade visual no Figma/Illustrator. |
| Prints reais ou ilustrações estilizadas de setups | **`.svg`** | Precisão gráfica idêntica à do software de design. |
| Gráficos simples e leves embutidos direto no JSON | **`vectorCanvas`** | Não requer criação de novos arquivos de imagem no projeto. |
| Esquemas que precisam mudar de cor com o tema Claro/Escuro | **`vectorCanvas`** | O pintor ajusta as cores das linhas e textos automaticamente. |

---

## 7. Checklist Rápido de Qualidade de Assets

- [ ] O SVG fecha corretamente todas as tags (`</g></svg>`).
- [ ] O `viewBox` dos ícones está quadrado (`1:1`).
- [ ] O `viewBox` dos gráficos está horizontal (`16:9` ou `16:10`).
- [ ] O caminho nos arquivos JSON bate exatamente com o nome do arquivo no disco.
- [ ] O fundo de ícones e ilustrações é transparente ou harmonizado com o tema.
- [ ] Diagramas dos cursos estão referenciados corretamente via `"image": "assets/..."` ou `"vectorCanvas": { ... }`.

