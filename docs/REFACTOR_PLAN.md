# Refactor Plan - Decoupled Learning Platform

Este plano descreve as etapas técnicas de engenharia necessárias para desacoplar o conteúdo educacional da lógica do aplicativo **Price Action Master**, transformando-o em um interpretador dinâmico de schemas educacionais.

---

## 1. O Conceito de Renderizadores Genéricos
Em vez de ter telas específicas para cada disciplina, criaremos uma única estrutura de navegação pedagógica reativa (`course_widget.dart` + `module_panel_widget.dart`). 

Os componentes de exibição de conteúdo serão divididos em 5 interpretadores puros de dados:

1.  **LessonRenderer (Aba Lição):** Renderiza elementos Markdown dinamicamente.
2.  **ExampleRenderer (Aba Exemplos):** Interpreta dados geométricos vetoriais para desenhar no Canvas de forma programática.
3.  **ExerciseRenderer (Aba Exercícios):** Mapeia e gera checklists clicáveis salvando o estado temporário no widget.
4.  **QuizRenderer (Aba Quiz):** Componente de perguntas de múltipla escolha com feedback visual e controle de repetição espaçada.
5.  **ChallengeRenderer (Aba Desafios):** Descrições práticas acopladas a gatilhos de conclusão de progresso.

---

## 2. Desacoplamento de Elementos Gráficos (Canvas Dinâmico)
Para eliminar os CustomPainters hardcoded (`SMCDiagramPainter`, `ElliottDiagramPainter`, `DiagramPainter`), a plataforma passará a interpretar um schema de **Instruções Vetoriais em JSON**.
O schema de `example` ou `illustration` poderá definir uma lista de primitivos gráficos a serem desenhados no Canvas nativo:

```json
"canvas": {
  "width": 200,
  "height": 100,
  "draw": [
    { "type": "line", "x1": 0.05, "y1": 0.75, "x2": 0.20, "y2": 0.30, "style": "primary" },
    { "type": "circle", "cx": 0.65, "cy": 0.85, "r": 4.0, "style": "error" },
    { "type": "text", "content": "CHoCH", "x": 0.30, "y": 0.58, "style": "error", "fontSize": 9 }
  ]
}
```

O Flutter conterá apenas um `GenericVectorPainter` que lê esse array de primitivos, realiza a escala matemática proporcional ao tamanho da tela física e pinta na tela a 60 FPS, mantendo a performance e eliminando dependências estáticas de novos padrões.

---

## 3. Repositories e Inicialização Dinâmica
Criaremos a classe `CourseRepository` encarregada de mapear a pasta de assets ou carregar diretórios locais e servir as instâncias do `CourseModel` de maneira assíncrona.
Ao iniciar o aplicativo, a home consultará o `CourseRepository.getAllCourses()` para listar as opções disponíveis reativamente, removendo botões fixos hardcoded.

---

## 4. Estratégia de Migração Incremental
A migração ocorrerá em etapas consecutivas:
1.  **Auditoria e Congelamento de Schemas** (Fase 1 e 2 - Corrente).
2.  **Refatoração da Plataforma:** Criação do `GenericVectorPainter` e dos renderizadores dinâmicos.
3.  **Migração dos Dados por Disciplina:**
    *   *Módulo Piloto:* Candlesticks.
    *   *Segunda Onda:* Figuras Gráficas.
    *   *Terceira Onda:* SMC.
    *   *Quarta Onda:* Ondas de Elliott.
4.  **Descomissionamento:** Remoção definitiva das telas de detalhes legadas (`detalhe_elliott_widget.dart`, `detalhe_smc_widget.dart`, etc.) após validação dos revisores.
