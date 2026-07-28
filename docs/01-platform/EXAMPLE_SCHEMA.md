# Example Schema Documentation

O `example.schema.json` define ilustrações gráficas acompanhadas de descrições conceituais.

---

## Estrutura do Schema

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "chartType": "string (opcional - mapeia para ilustradores legados)",
  "vectorCanvas": {
    "width": "number",
    "height": "number",
    "elements": [
      {
        "type": "string (ex: 'line', 'circle', 'candle', 'text', 'dotted_line')",
        "x1": "number",
        "y1": "number",
        "x2": "number",
        "y2": "number",
        "cx": "number",
        "cy": "number",
        "r": "number",
        "x": "number",
        "y": "number",
        "content": "string",
        "colorStyle": "string (ex: 'primary', 'success', 'error', 'text')"
      }
    ]
  }
}
```

---

## Detalhes das Coordenadas

*   **`vectorCanvas`**: Um canvas dinâmico para renderizar diagramas sem imagem física.
*   **Coordenadas Proporcionais**: O `elements` mapeia pontos de `0.0` a `1.0` no eixo X e Y. O motor multiplica essas coordenadas pelo tamanho físico final do widget na tela (ex: se o widget tem largura de 300px, uma coordenada `x: 0.5` vira `150.0` pixels no Canvas).
