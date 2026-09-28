# Migration Checklist - decopled Educational Courses

Este documento serve como a checklist passo a passo operacional para rastrear a migração de cada disciplina de Price Action para a nova plataforma.

---

## 1. Mapeamento Geral do Engine
- [x] Congelar especificações dos schemas JSON (`Fase 2`).
- [x] Implementar decodificador e modelos Dart para suporte aos novos schemas (`Fase 3`).
- [x] Implementar `GenericVectorPainter` suportando primitivos geométricos dinâmicos (`Fase 3`).
- [x] Criar views genéricas de renderizadores (Lição, Exemplos, Exercícios, Quiz, Desafio) (`Fase 3`).
- [x] Configurar o `CourseRepository` para carregar dados dinamicamente de `content/courses/` (`Fase 3`).

---

## 2. Onda 1: Curso Piloto - Velas Japonesas (Candlesticks)
- [x] Criar arquivo de dados oficial `content/courses/candlesticks.json`.
- [x] Validar conformidade de `candlesticks.json` com `course.schema.json`.
- [x] Migrar ilustrações de Martelo e Engolfo de alta para primitivos gráficos JSON.
- [x] Habilitar renderização em ambiente de testes e validar interatividade.
- [x] Desativar atalho antigo.

---

## 3. Onda 2: Figuras Gráficas
- [x] Criar arquivo de dados oficial `content/courses/figuras.json`.
- [x] Validar conformidade com `course.schema.json`.
- [x] Converter ilustrações de topo duplo/OCO/OCOI em primitivos gráficos.
- [x] Habilitar e validar em ambiente de staging.

---

## 4. Onda 3: Smart Money Concepts (SMC)
- [x] Criar arquivo de dados oficial `content/courses/smc.json`.
- [x] Validar conformidade com `course.schema.json`.
- [x] Migrar estruturas BOS, CHoCH, Order Block e FVG para coordenadas em JSON.
- [x] Habilitar e validar.

---

## 5. Onda 4: Ondas de Elliott
- [x] Criar arquivo de dados oficial `content/courses/elliott.json`.
- [x] Validar conformidade com `course.schema.json`.
- [x] Mapear as ondas impulsivas (1-5), corretivas (A-B-C) e regras para coordenadas de retas dinâmicas.
- [x] Habilitar e validar.

---

## 6. Onda 5: Gestão de Risco (fora do escopo original deste checklist)
- [x] Criar arquivo de dados oficial `content/courses/gestao_risco.json`.
- [x] Validar conformidade com `course.schema.json`.
- [x] Habilitar e validar (curso já integrado à Home antes desta rodada de refatoração).

---

## 7. Onda 6: Wyckoff (fora do escopo original deste checklist)
- [x] Criar arquivo de dados oficial `content/courses/wyckoff.json` (3 módulos: Fase C/Spring, Barras de Sinal de Volume, etc.).
- [x] Validar conformidade com `course.schema.json`.
- [x] Habilitar carregamento dinâmico de cursos via `AssetManifest` (corrigido nesta rodada — ver seção 9).

---

## 8. Quiz Standalone → Simulado Geral no Motor Novo
- [x] Auditar `quiz_widget.dart`/`quiz_model.dart` (~950 linhas) e `assets/jsons/quiz.json` (5 perguntas) em busca de conteúdo ainda não presente em `content/courses/*.json`.
- [x] Migrar as 4 perguntas não duplicadas para os cursos correspondentes (`candlesticks_m1_q2`, `candlesticks_m1_q3`, `elliott_m1_q2`, `figuras_m1_q2`). A pergunta de CHoCH não foi migrada por já existir em `smc_m1_q1`.
- [x] Validar com `python tools/content_validator.py`.
- [x] Estender `QuizRenderer`/`ModulePanelWidget` para percorrer **todas** as perguntas de um módulo (antes só a primeira era exibida); o desafio do módulo só libera após a última.
- [x] Criar `QuizSessionWidget`/`QuizSessionModel` (`lib/pages/course/`): simulado geral que agrega os quizzes de todos os cursos via `LocalCourseRepository`, reaproveitando `QuizRenderer`.
- [x] Trocar o botão "Quiz" da Home (`inicio_widget.dart`) para `QuizSessionWidget.routeName`, em vez de `QuizWidget.routeName`.
- [x] Deletar `lib/pages/quiz/` e `assets/jsons/quiz.json`.

---

## 9. Descomissionamento e Limpeza (Congelamento Final)
- [x] Validar que nenhum componente legado é importado (auditoria por `grep` de cada classe antes da remoção — ver histórico da Fase 0).
- [x] Deletar arquivos obsoletos de páginas do Flutter: `lib/pages/quiz/`, `lib/pages/smc/`, `lib/pages/elliott/`, `lib/pages/detalhe_candlestick/`, `lib/pages/detalhe_figura/`, `lib/pages/figuras_graficas/`, `lib/pages/velas_japonesas/` (18 arquivos).
- [x] Remover o fallback de ilustradores legados (`SMCIllustration`, `ElliottIllustration`, `QuizIllustration`) em `course_renderers.dart` — nenhum conteúdo usava `chartType`, só `vectorCanvas`.
- [x] Redirecionar as abas "Figuras Gráficas" e "Candlesticks" da barra inferior (`main.dart`) para `CourseWidget(courseId: 'figuras'/'candlesticks', showBackButton: false)`.
- [x] Remover as 9 rotas legadas de `nav.dart` e os 9 `export` correspondentes de `index.dart`.
- [x] Deletar JSONs legados de `assets/jsons/`: `quiz.json`, `smc.json`, `elliott.json` (órfãos após a limpeza acima).
  - `candlesticks.json`, `figuras.json` e `conceitos.json` **permanecem** — ainda lidos por `queryCandlesticksRecordOnce`/`queryFigurasRecordOnce`/`getDoc()` em `backend.dart`/`serialization_util.dart`, hoje código morto (ver nota abaixo) mas ainda presente no repositório.
  - `tarot_cards.json` permanece — ativamente usado por `tarot_widget.dart`.
- [x] Executar `flutter analyze` e `flutter test` após cada fase destrutiva — sempre `No issues found!` e mesma contagem de testes do baseline (só a falha pré-existente de `widget_test.dart`).
- [x] Corrigir `LocalCourseRepository`: a descoberta dinâmica de cursos lia `AssetManifest.json`, que o Flutter atual não gera mais (só `AssetManifest.bin`). Trocado para a API oficial `AssetManifest.loadFromAssetBundle`.
- [x] Migrar "Análise Técnica"/Conceitos do Firestore (na prática, já offline: só usava Firestore para fabricar uma `DocumentReference` falsa) para o mesmo padrão de dados local do resto do app — ver `content/schemas/concept.schema.json`, `content/reference/conceitos.json`, `ConceptRepository`.
- [x] Remover código morto criado por esta migração — deletados `lib/backend/backend.dart`, os 4 pares Record/Struct (`ConceitosRecord`, `CandlesticksRecord`, `FigurasRecord`, `EstrategiasRecord` — esta já estava morta antes), `lib/backend/schema/util/firestore_util.dart` e `lib/backend/firebase/firebase_config.dart`. Removido também o suporte a `ParamType.Document`/`DocumentReference` e a função `getDoc`/`getDocList` de `serialization_util.dart`, e o import/export de `cloud_firestore` + a extensão `.ref` (não usada) de `flutter_flow_util.dart`.
- [x] Remover as dependências de Firebase (`cloud_firestore*`, `firebase_core*`) e `cached_network_image*`/`flutter_cache_manager` do `pubspec.yaml` — confirmado via `flutter pub deps` que nada mais dependia delas; `flutter pub get` removeu 13 pacotes da árvore. `flutter analyze` limpo e `flutter test` sem regressão.
  - **Não removido** (fora do escopo desta limpeza, nativo): `android/app/build.gradle` ainda aplica o plugin `com.google.gms.google-services`, e `android/app/google-services.json`/`ios/Runner/GoogleService-Info.plist`/`firebase/firebase.json` continuam no repositório. Inofensivos (o plugin não depende do pacote Dart `firebase_core`), mas ficam órfãos — candidatos a uma limpeza nativa separada se o app não for mais usar Firebase para nada.
