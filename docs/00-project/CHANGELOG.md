# Changelog: Price Action Master

Histórico de atualizações arquiteturais e evolutivas da plataforma.

---

## [1.2.0] - 2026-07-27
### Adicionado
*   Estruturação formal do **AI Workspace** com perfis de especialização em `.agents/`.
*   Criação das pastas de documentação central `docs/00-project/` e `docs/02-learning/`.
*   Criação da pasta `templates/` com modelos JSON prontos para todos os tipos de etapas.
*   Criação das pastas `knowledge/` e `playground/` para isolar pesquisas de código ativo.

### Modificado
*   Movimentação das ferramentas `content_cli.py` e `content_validator.py` para a pasta `/tools/`.
*   Movimentação de guias de estilo e guias de autor para `/docs/02-learning/`.

---

## [1.1.0] - 2026-07-27
### Adicionado
*   Implementação de modelos Dart tipados seguros em `platform_course_models.dart`.
*   Implementação do `LocalCourseRepository` para ler dados offline do disco.
*   Biblioteca de renderizadores genéricos de abas (`LessonRenderer`, `ExampleRenderer`, `ExerciseRenderer`, `QuizRenderer`, `ChallengeRenderer`).
*   Intérprete nativo de Canvas geométrico `GenericVectorPainter`.
*   Criação do Content CLI e Content Validator em Python.

---

## [1.0.0] - Legado
*   Aplicativo com conteúdos educacionais hardcoded nas telas do FlutterFlow.
