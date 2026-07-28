# Course Schema Documentation

O `course.schema.json` define a estrutura raiz de uma disciplina educacional no **Price Action Master**.

---

## Estrutura do Schema

```json
{
  "id": "string (identificador único, ex: 'smc')",
  "title": "string (título curto visível na Home)",
  "description": "string (descrição longa detalhando a ementa)",
  "version": "integer (controle de cache e atualização)",
  "modules": "array [Module] (lista ordenada de módulos curriculares)"
}
```

---

## Campos e Tipos

*   **`id`** (obrigatório): Deve ser em letras minúsculas sem espaços ou acentos. Usado como chave primária de roteamento e de persistência de progresso local.
*   **`title`** (obrigatório): Nome do curso a ser renderizado na barra superior e nos botões da Home.
*   **`description`** (obrigatório): Explicação resumida do curso exibida no card do cabeçalho principal.
*   **`version`** (obrigatório): Incrementado a cada atualização de conteúdo para que o cache interno da plataforma force a recarga dos dados.
*   **`modules`** (obrigatório): Deve conter pelo menos 1 módulo estruturado.
