Acho que vale fazer uma pequena mudança de mentalidade antes de você enviar qualquer coisa ao Antigravity.

Até agora você vinha pedindo tarefas ("implemente isso", "crie aquilo"). A partir de agora você vai tratar o projeto como um **produto de software profissional**. O código deixa de ser o centro do projeto. O centro passa a ser a **arquitetura**.

Eu copiaria exatamente o texto abaixo para o Antigravity.

---

# Reorganização Arquitetural do Projeto

Estamos mudando a forma de desenvolver o aplicativo.

O projeto deixou de ser um aplicativo Flutter com conteúdo embutido e passa a ser uma plataforma de aprendizagem (Learning Platform).

A partir deste momento, o aplicativo será dividido em duas partes completamente independentes:

1. Plataforma (Flutter + Learning Engine)
2. Conteúdo (JSON + Assets + Documentação)

O Flutter será apenas um renderizador.

Todo o conteúdo será carregado dinamicamente.

Nenhuma lição, quiz, exercício ou texto poderá ficar hardcoded no código.

Adicionar um novo curso não deverá exigir alterações no código Flutter.

Será suficiente adicionar novos arquivos JSON seguindo os schemas definidos.

---

# Nova organização do projeto

A estrutura deverá ser reorganizada para separar claramente plataforma, conteúdo e documentação.

Exemplo:

```text
price-action-master/

app/
    Flutter Application

content/
    courses/
    assets/
    schemas/
    docs/

docs/
    01-platform/
    02-design/
    03-content/
    04-assets/
    05-review/

prompts/

roadmap/

README.md
```

O diretório **app/** conterá exclusivamente o código Flutter.

O diretório **content/** conterá exclusivamente conteúdo educacional.

Nenhum código Dart deverá existir dentro de `content/`.

Nenhum conteúdo educacional deverá existir dentro de `app/`.

---

# Mudança de filosofia

O aplicativo passa a ser orientado por dados.

O Flutter apenas interpreta arquivos JSON.

Exemplo:

Hoje

```
LessonScreen.dart

↓

Texto escrito no Widget
```

Novo modelo

```
LessonRenderer

↓

lesson.json

↓

Renderização automática
```

O mesmo vale para:

* exercícios
* quizzes
* desafios
* certificados
* analytics

---

# Separação de responsabilidades

Para manter o projeto organizado, o desenvolvimento será dividido em papéis.

Esses papéis representam responsabilidades, não necessariamente pessoas.

Cada agente trabalha apenas em sua área.

---

# Agente 1 — Platform Architect

Responsável por toda a infraestrutura.

Não escreve conteúdo.

Não cria quizzes.

Não cria SVG.

Não altera design.

Sua responsabilidade é criar o Learning Engine.

Entregas:

* arquitetura
* models
* repositories
* JSON Schemas
* SDK de conteúdo
* documentação técnica
* README
* ADR
* exemplos de JSON

Depois dessa etapa a arquitetura será considerada congelada.

---

# Agente 2 — Flutter Developer

Responsável apenas pelo aplicativo.

Recebe os schemas criados pelo Platform Architect.

Nunca altera schemas.

Nunca cria conteúdo.

Nunca escreve lições.

Sua função é criar componentes reutilizáveis capazes de renderizar qualquer curso.

---

# Agente 3 — Content Architect

Responsável apenas pelo conteúdo.

Nunca escreve Flutter.

Nunca altera arquitetura.

Nunca cria widgets.

Produz apenas:

* cursos
* módulos
* lições
* exemplos
* exercícios
* quizzes
* desafios

Todos seguindo exatamente os schemas oficiais.

---

# Agente 4 — Asset Builder

Responsável apenas pelos recursos gráficos.

Produz:

* SVG
* PNG
* diagramas
* ilustrações
* hotspots
* imagens
* animações

Nunca altera conteúdo.

Nunca altera Flutter.

---

# Agente 5 — Quality Reviewer

Nunca implementa nada.

Nunca escreve conteúdo.

Sua única função é revisar.

Verificar:

* consistência
* schemas
* ids
* links
* assets
* qualidade
* coerência
* duplicações
* cobertura pedagógica

---

# Fluxo oficial do projeto

Sempre seguir esta sequência.

## Etapa 1

Platform Architect

↓

Cria toda a infraestrutura.

---

## Etapa 2

Flutter Developer

↓

Implementa o Learning Engine.

---

## Etapa 3

Content Architect

↓

Produz os cursos.

---

## Etapa 4

Asset Builder

↓

Produz imagens.

---

## Etapa 5

Reviewer

↓

Valida tudo antes do merge.

---

# O que fazer com o código atual

Não reescrever o aplicativo.

Não apagar nada.

Primeiro realizar uma auditoria completa.

Gerar os seguintes documentos.

```
CURRENT_ARCHITECTURE.md

REFACTOR_PLAN.md

KEEP_REMOVE_MATRIX.md

MIGRATION_CHECKLIST.md
```

Nenhum arquivo do projeto deverá ser alterado nesta etapa.

O objetivo é entender a base existente.

---

# Após a auditoria

Criar uma estratégia de migração incremental.

Nunca substituir tudo de uma vez.

Migrar módulo por módulo.

Exemplo.

Primeiro:

Candlesticks

Depois:

Análise Técnica

Depois:

Figuras Gráficas

Depois:

SMC

Depois:

Elliott

Cada módulo deverá ser migrado individualmente.

O aplicativo deverá continuar funcionando durante toda a migração.

---

# Primeira missão

Neste momento não quero implementação.

Quero apenas preparar toda a fundação do projeto.

Sua primeira missão será criar a estrutura documental completa.

Gerar os seguintes arquivos.

```
docs/

01-platform/

ARCHITECTURE.md

CONTENT_SDK.md

COURSE_SCHEMA.md

MODULE_SCHEMA.md

LESSON_SCHEMA.md

EXAMPLE_SCHEMA.md

EXERCISE_SCHEMA.md

QUIZ_SCHEMA.md

CHALLENGE_SCHEMA.md

PROGRESS_SCHEMA.md

XP_SCHEMA.md

CERTIFICATE_SCHEMA.md

ANALYTICS_SCHEMA.md

SPACED_REPETITION.md

README.md

ADR.md
```

Também criar.

```
content/

schemas/

course.schema.json

module.schema.json

lesson.schema.json

example.schema.json

exercise.schema.json

quiz.schema.json

challenge.schema.json

progress.schema.json

certificate.schema.json

analytics.schema.json
```

Também criar.

```
content/

examples/

course/

module/

lesson/

exercise/

quiz/

challenge/
```

Cada pasta deverá conter exemplos completos.

---

# Objetivo final

Ao término desta etapa, o projeto deverá possuir uma fundação sólida para que:

* novos cursos sejam adicionados apenas criando arquivos JSON;
* o Flutter nunca precise ser alterado para suportar novos conteúdos;
* o aplicativo possa crescer para dezenas de cursos e milhares de objetos de aprendizagem mantendo baixo acoplamento, alta reutilização e fácil manutenção.

---

## Uma última recomendação

Em vez de pedir ao Antigravity para fazer tudo em uma única execução, peça que ele trabalhe em **fases com entregas revisáveis**. Eu seguiria esta sequência:

1. **Fase 1** – Auditoria da base atual e plano de migração.
2. **Fase 2** – Estrutura de diretórios, documentação e schemas.
3. **Fase 3** – Implementação do Learning Engine e dos renderizadores genéricos.
4. **Fase 4** – Migração completa do curso piloto (Candlesticks) para validar toda a arquitetura.
5. **Fase 5** – Migração dos demais cursos e produção contínua de conteúdo.

Esse processo permite revisar e aprovar cada etapa antes de seguir para a próxima, reduzindo significativamente o risco de retrabalho e mantendo o aplicativo funcional durante toda a evolução da plataforma.
