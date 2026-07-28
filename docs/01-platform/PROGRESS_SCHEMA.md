# Progress Schema Documentation

O `progress.schema.json` dita o formato de persistência local das estatísticas de conclusão do usuário.

---

## Estrutura do Schema

```json
{
  "userId": "string",
  "completedCourses": [
    {
      "courseId": "string",
      "completedAt": "string (data ISO 8601)",
      "certificateEarned": "boolean"
    }
  ],
  "completedModules": [
    {
      "courseId": "string",
      "moduleId": "string",
      "completedAt": "string (data ISO 8601)",
      "score": "integer"
    }
  ]
}
```

---

## Persistência de Dados

*   Esses dados são gravados localmente em formato JSON pelo `LocalDataManager` e atualizados a cada conclusão de módulo ou curso.
*   Ao atingir 100% de conclusão de módulos de um curso, a chave `certificateEarned` é definida como `true`.
