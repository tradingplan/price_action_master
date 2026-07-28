# Analytics Schema Documentation

O `analytics.schema.json` rege a coleta local de dados analíticos comportamentais de estudo do usuário, mantendo privacidade absoluta sem chamadas externas.

---

## Estrutura do Schema

```json
{
  "events": [
    {
      "timestamp": "string (data ISO 8601)",
      "eventType": "string (ex: 'lesson_read', 'quiz_fail', 'module_completed')",
      "courseId": "string",
      "moduleId": "string",
      "durationSeconds": "integer"
    }
  ]
}
```

---

## Uso Pedagógico
O motor de recomendação interno do aplicativo analisa o `analytics_history.json` local para detectar dificuldades (ex: alto índice de erro no Quiz de Ondas de Elliott) e recomendar revisões das lições de forma pró-ativa na Home do usuário.
