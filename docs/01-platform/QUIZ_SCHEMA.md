# Quiz Schema Documentation

O `quiz.schema.json` dita a estrutura das perguntas de avaliação de cada módulo.

---

## Estrutura do Schema

```json
{
  "id": "string (ex: 'smc_m1_q1')",
  "question": "string (pergunta conceitual)",
  "options": "array [string] (lista contendo exatamente entre 2 e 4 opções de resposta)",
  "correctIndex": "integer (índice baseado em 0 apontando a alternativa correta)",
  "explanation": "string (texto pedagógico com a justificativa técnica exposta pós-resposta)"
}
```

---

## Validação de Resposta

*   O `QuizRenderer` impede que o usuário altere sua resposta após selecionar uma alternativa.
*   Pinta de **verde** a alternativa correta e de **vermelho** a alternativa incorreta se houver erro.
*   Exibe o painel de justificativa com o conteúdo do campo `explanation` para garantir fixação pedagógica.
