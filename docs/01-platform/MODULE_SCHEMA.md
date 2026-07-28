# Module Schema Documentation

O `module.schema.json` representa um agrupamento temático de aprendizado contendo as etapas teóricas e práticas.

---

## Estrutura do Schema

```json
{
  "id": "string (ex: 'smc_m1')",
  "title": "string (ex: 'Estrutura e Rompimentos')",
  "description": "string (ex: 'Aprenda a mapear topos e fundos')",
  "xpValue": "integer (pontuação de XP concedida ao concluir)",
  "lessons": "array [Lesson]",
  "examples": "array [Example]",
  "exercises": "array [Exercise]",
  "quizzes": "array [Quiz]",
  "challenges": "array [Challenge]"
}
```

---

## Detalhes de Implementação

*   **`xpValue`** (obrigatório): O motor de gamificação do aplicativo lerá esse valor ao salvar a conclusão do módulo para somar ao perfil geral do usuário.
*   **Ordem de Execução:** Embora os dados fiquem em arrays independentes, o `ModulePanelWidget` renderiza os passos em abas sequenciais fixas da esquerda para a direita (Lição → Exemplos → Exercício → Quiz → Desafio).
