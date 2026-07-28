# Content Authoring SDK & Guidelines

Este manual serve como o guia do **Content Architect** e **Asset Builder** para criar, testar e publicar novos conteúdos educacionais na plataforma **Price Action Master**.

---

## 1. Regras Fundamentais de Produção

1.  **Nenhum código Dart:** Toda a lição, quiz ou geometria de ilustração deve ser descrita exclusivamente em formato JSON nos arquivos do diretório `content/courses/`.
2.  **Validação Rígida contra Schemas:** Antes de submeter qualquer curso para revisão, o arquivo JSON correspondente deve passar na validação estrita contra o `course.schema.json`.
3.  **Coordenadas Geométricas Relativas:** Para ilustrações personalizadas no Canvas, todas as coordenadas `(x, y)` devem ser informadas na faixa de `0.0` a `1.0` (proporcionais ao tamanho físico da tela do usuário).

---

## 2. Estrutura do Pacote de Cursos

Um curso completo é definido por um arquivo JSON único nomeado com o ID do curso (ex: `candlesticks.json`). Ele deve conter:
*   Informações do cabeçalho (id, title, description, badgeUrl).
*   Uma lista ordenada de **Módulos**.
*   Cada módulo deve conter pelo menos uma **Lição**, um **Exemplo** (com vetor gráfico), um **Exercício**, um **Quiz** e um **Desafio**.

---

## 3. Fluxo de Publicação

```text
Criação do JSON
    ↓ (Validação local com VS Code / AJV contra schemas)
Submissão de Merge Request
    ↓ (Validação do Quality Reviewer)
Build & Deploy
    ↓ (Usuário final consome dinamicamente)
```
