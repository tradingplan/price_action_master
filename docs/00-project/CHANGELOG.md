# Changelog: Price Action Master

Histórico de atualizações arquiteturais e evolutivas da plataforma.

## [1.4.0] - 2026-09-30
### Adicionado
*   Módulo **Tarot Trader** para controle de viés cognitivo e calibração psicológica diária do trader, 100% offline-first.
*   Catálogo declarativo JSON (`content/tarot/tarot-trader-cartas.json`) com 22 arquétipos comportamentais, polaridades ("bear" / "bull"), psych_load, gatilhos/sinais e antídotos.
*   Schema declarativo rigoroso `content/schemas/tarot.schema.json` e integração com `tools/content_validator.py`.
*   Animação 3D de flip com rotação no eixo Y (450ms) e UI responsiva conforme especificações do PRD.
*   Lógica de negócio de sorteio diário único com variação dinâmica de ±8 no `psych_load` (clamped em [0, 100]), cálculo automático de `biasStatus` e premiação de +25 XP na primeira leitura do dia.
*   Persistência local integrada no `LocalDataManager` (SharedPreferences + histórico de até 90 leituras em JSON no disco).
*   Suíte de testes automatizados com 100% de aprovação (`test/tarot_test.dart` e `test/local_data_manager_test.dart`).

---

## [1.3.0] - 2026-09-30
### Adicionado
*   Expansão completa das 5 disciplinas (`candlesticks.json`, `smc.json`, `elliott.json`, `figuras.json`, `gestao_risco.json`) com 4 módulos cada, diagramas no Canvas vetorial de 60 FPS, checklists de identificação, quizzes com explicações detalhadas e desafios práticos.
*   Motor de **Repetição Espaçada (Leitner System)** no `LocalDataManager` com 5 caixas de revisão, promoção/rebaixamento automático ao responder quizzes e card de alertas de revisão na Home.
*   Emissão e validação offline de **Certificados Digitais** com assinatura criptográfica SHA-256 e tela visualizadora dedicada `CertificateViewerWidget`.
*   Atualização da suíte de testes automatizados (`local_data_manager_test.dart`, `platform_parser_test.dart`, `widget_test.dart`).

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
