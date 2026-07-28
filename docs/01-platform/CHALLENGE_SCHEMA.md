# Challenge Schema Documentation

O `challenge.schema.json` representa o desafio de encerramento do módulo, conectando a teoria e a prática ao mercado em tempo real.

---

## Estrutura do Schema

```json
{
  "id": "string",
  "title": "string",
  "description": "string (instruções operacionais detalhadas do desafio)"
}
```

---

## Comportamento na Plataforma

*   O desafio é a etapa de "congelamento" do módulo.
*   Ao concluir o desafio clicando no botão inferior, a plataforma aciona o salvamento do estado do módulo para completo e concede o XP especificado no módulo.
