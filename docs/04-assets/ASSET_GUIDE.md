# Asset and Vector Canvas Styling Guide

Instruções para o **Asset Builder** projetar ilustrações nativas em Canvas sem imagens externas.

---

## 1. Coordenadas Relativas (Proporcionais)
Todos os pontos geométricos no JSON devem usar floats na faixa de `0.0` a `1.0`:
*   `(0.0, 0.0)` representa o canto superior esquerdo do Canvas.
*   `(1.0, 1.0)` representa o canto inferior direito do Canvas.

---

## 2. Tipos de Primitivos Geométricos

*   **`line`**: Desenha linhas de retas. Exige `x1`, `y1`, `x2`, `y2`.
*   **`dotted_line`**: Desenha linhas pontilhadas de projeção. Exige `x1`, `y1`, `x2`, `y2`.
*   **`circle`**: Destaca rompimentos. Exige `cx`, `cy`, `r`.
*   **`text`**: Escreve rótulos operacionais. Exige `x`, `y`, `content`.
*   **`candle`**: Desenha velas com corpo e pavio. Exige `cx` (centro X), `cy` (centro Y), `x1` (altura do corpo), `y1` (altura do pavio superior), `y2` (altura do pavio inferior), e `content` (`'red'` ou `'green'`).

---

## 3. Cores Temáticas
Evite declarar cores hexadecimais específicas. Use `colorStyle` mapeando as cores do tema:
*   `primary`: Destaque de ondas ou retrações.
*   `success`: Velas de alta, suportes, alvos.
*   `error`: Velas de baixa, resistências, stop loss, quebras de estrutura (BOS/CHoCH).
*   `text`: Linhas neutras e rótulos secundários.
