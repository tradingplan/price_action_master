# Exercise Schema Documentation

O `exercise.schema.json` estabelece a lista de validações que o usuário deve fazer de forma manual no mercado prático para sedimentar a técnica.

---

## Estrutura do Schema

```json
{
  "id": "string",
  "instruction": "string (ex: 'Localize uma zona no seu gráfico...')",
  "checklist": "array [string] (lista de critérios técnicos a serem validados)"
}
```

---

## Funcionamento Técnico

1.  O `ExerciseRenderer` lê o array `checklist`.
2.  Gera dinamicamente uma lista de Checkbox tiles.
3.  O botão de progresso do módulo fica bloqueado até que **todas** as caixas de seleção do checklist sejam marcadas como `true` pelo usuário.
