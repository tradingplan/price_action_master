# Lesson Schema Documentation

O `lesson.schema.json` rege a apresentação de conteúdo teórico.

---

## Estrutura do Schema

```json
{
  "id": "string (ex: 'smc_m1_l1')",
  "title": "string (ex: 'O Mapeamento Estrutural')",
  "content": "string (conteúdo textual rico, suporta formatação markdown)"
}
```

---

## Orientações de Formatação

*   **Markdown:** O campo `content` é processado por um renderizador dinâmico de Markdown no Flutter. É permitido usar quebras de linha (`\n`), negrito (`**`), itálico (`*`), tópicos (`* item`) e avisos especiais.
*   **Decoupled Style:** Nenhuma cor, margem ou elemento visual de layout deve ser especificado no texto. A folha de estilo global da plataforma (`FlutterFlowTheme`) ditará o visual final.
