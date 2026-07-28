# Content Author Guide - Price Action Master

Este manual serve como o guia do **Content Architect** e **Asset Builder** para criar, testar e publicar novos conteúdos educacionais na plataforma **Price Action Master**.

---

## 1. Princípios Básicos
O aplicativo Price Action Master foi refatorado como um interpretador puro orientando por dados (data-driven). Isso significa que:
*   Nenhum conteúdo conceitual deve ser codificado no Flutter.
*   Todo o fluxo pedagógico (lição, exemplo, exercício, quiz, desafio) é extraído exclusivamente de arquivos JSON em `/content/courses/`.
*   A formatação visual deve usar os schemas correspondentes.

---

## 2. Processo de Autoria
1.  **Mapear Grade:** Divida o assunto em Módulos coerentes (ex: Reversões, Padrões, etc.).
2.  **Escrever Lições:** Crie textos focados em Markdown nativo sem se preocupar com layout.
3.  **Desenhar Vetores:** Planeje as ilustrações no Canvas dinâmico especificando coordenadas (`x, y`) proporcionais de `0.0` a `1.0`.
4.  **Estruturar Exercícios & Quizzes:** Escreva checklists objetivos e perguntas de múltipla escolha com justificativas ricas.
5.  **Validar:** Execute o validador automatizado antes de submeter o código.
