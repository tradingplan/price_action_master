# Keep / Remove Matrix - Architectural Reorganization

Esta matriz cataloga as decisões de destino de cada arquivo chave do repositório durante a migração para a plataforma orientada a dados.

| Caminho do Arquivo | Status | Destino / Justificativa |
| :--- | :---: | :--- |
| **`lib/main.dart`** | **REFACTOR** | Manter inicialização, refatorando boot para carregar o catálogo dinâmico de cursos. As abas "Figuras Gráficas" e "Candlesticks" da barra inferior passaram a abrir `CourseWidget` em vez de telas fixas. |
| **`lib/backend/local_data_manager.dart`** | **REFACTOR** | Expandir para suportar schemas de progresso, XP e logs analíticos dinâmicos. |
| **`lib/pages/inicio/inicio_widget.dart`** | **REFACTOR** | Remover botões de cursos fixos. A Home deve carregar a lista de cursos dinamicamente via `CourseRepository`. O botão "Quiz" agora aponta para `QuizSessionWidget` em vez do `QuizWidget` legado. |
| **`lib/backend/schema/course_models.dart`** | **REFACTOR** | Adaptar para refletir exatamente os novos schemas formais JSON. |
| **`lib/pages/course/course_widget.dart`** | **REFACTOR** | Adaptar para consumir os novos modelos de dados genéricos carregados de forma dinâmica. Ganhou o parâmetro `showBackButton` para ser reaproveitado como aba da barra inferior. |
| **`lib/pages/course/module_panel_widget.dart`** | **REFACTOR** | Dividir logicamente nas sub-views de renderizadores e integrar o `GenericVectorPainter`. A aba Quiz passou a percorrer todas as perguntas do módulo, não só a primeira. |
| **`lib/pages/course/renderers/course_renderers.dart`** | **REFACTOR** | Removido o fallback de ilustradores legados (`SMCIllustration`/`ElliottIllustration`/`QuizIllustration`) — nenhum conteúdo usava `chartType`, só `vectorCanvas`. |
| **`lib/backend/repositories/course_repository.dart`** | **REFACTOR** | Descoberta dinâmica de cursos migrada de `AssetManifest.json` (não gerado mais pelo Flutter atual) para a API `AssetManifest.loadFromAssetBundle`. |
| **`lib/pages/quiz/quiz_widget.dart`** | **REMOVED** | Deletado. As perguntas ainda não cobertas pelos cursos migraram para `content/courses/*.json`; o simulado geral virou `lib/pages/course/quiz_session_widget.dart`. |
| **`lib/pages/quiz/quiz_model.dart`** | **REMOVED** | Deletado junto com `quiz_widget.dart`. |
| **`lib/pages/smc/smc_widget.dart`** | **REMOVED** | Deletado. Substituído por `CourseWidget` carregando `content/courses/smc.json`. |
| **`lib/pages/smc/smc_model.dart`** | **REMOVED** | Deletado junto com `smc_widget.dart`. |
| **`lib/pages/smc/detalhe_smc_widget.dart`** | **REMOVED** | Deletado. Substituído por `ModulePanelWidget`. |
| **`lib/pages/smc/detalhe_smc_model.dart`** | **REMOVED** | Deletado junto com `detalhe_smc_widget.dart`. |
| **`lib/pages/elliott/elliott_widget.dart`** | **REMOVED** | Deletado. Substituído por `CourseWidget` carregando `content/courses/elliott.json`. |
| **`lib/pages/elliott/elliott_model.dart`** | **REMOVED** | Deletado junto com `elliott_widget.dart`. |
| **`lib/pages/elliott/detalhe_elliott_widget.dart`** | **REMOVED** | Deletado. Substituído por `ModulePanelWidget`. |
| **`lib/pages/elliott/detalhe_elliott_model.dart`** | **REMOVED** | Deletado junto com `detalhe_elliott_widget.dart`. |
| **`lib/pages/detalhe_candlestick/*`** | **REMOVED** | Deletado (2 arquivos). Sem rota alcançável a partir da Home; substituído por `CourseWidget`/`ModulePanelWidget`. |
| **`lib/pages/detalhe_figura/*`** | **REMOVED** | Deletado (2 arquivos). Mesmo motivo acima. |
| **`lib/pages/figuras_graficas/*`** | **REMOVED** | Deletado (2 arquivos). A aba "Figuras Gráficas" da barra inferior agora abre `CourseWidget(courseId: 'figuras')`. |
| **`lib/pages/velas_japonesas/*`** | **REMOVED** | Deletado (2 arquivos). A aba "Candlesticks" da barra inferior agora abre `CourseWidget(courseId: 'candlesticks')`. |
| **`lib/pages/analise_tecnica/analise_tecnica_widget.dart`** | **REFACTOR** | Lia `ConceitosRecord` via uma camada Firestore que só fabricava uma `DocumentReference` falsa — os dados já eram locais. Migrado para `ConceptRepository`/`PlatformConcept` (`content/reference/conceitos.json`). Corrigido bug pré-existente: o campo `icon` (emoji) era usado como URL de imagem de rede. |
| **`lib/pages/detalhe_a_t/detalhe_a_t_widget.dart`** | **REFACTOR** | Mesmo motivo acima; recebe o conceito serializado como `Map<String, dynamic>` em vez de `ConceitosRecord`. |
| **`lib/pages/tarot/tarot_widget.dart`** | **KEEP** | O Tarot Trader é um terminal psicológico utilitário isolado. Manter como tela especial. |
| **`lib/pages/calculadoras/calculadoras_widget.dart`** | **KEEP** | Calculadora de contratos futuros é utilitário de mercado. Manter. |
| **`assets/jsons/*.json`** *(legados)* | **MIGRATE** | `quiz.json`, `smc.json`, `elliott.json` deletados (órfãos). `candlesticks.json`, `figuras.json` **mantidos** — ainda lidos pelas telas de detalhe originais do FlutterFlow (fora do escopo desta refatoração). `conceitos.json` mantido só como referência histórica (o dado ativo agora é `content/reference/conceitos.json`). `tarot_cards.json` mantido, ativamente usado. |
| **`lib/backend/backend.dart`**, **`lib/backend/schema/conceitos_record.dart`**, **`candlesticks_record.dart`**, **`figuras_record.dart`**, **`estrategias_record.dart`**, os 4 `structs/*_struct.dart` correspondentes, **`lib/backend/schema/util/firestore_util.dart`**, **`lib/backend/firebase/firebase_config.dart`** | **REMOVED** | Toda a camada Firestore/FlutterFlow ficou morta (Conceitos migrado nesta rodada; Candlesticks/Figuras ficaram órfãs ao deletar `detalhe_candlestick`/`detalhe_figura`; Estratégias já estava morta antes). Deletados junto com o suporte a `ParamType.Document`/`DocumentReference` em `serialization_util.dart`, a chamada `initFirebase()` em `main.dart`, e as dependências `cloud_firestore*`/`firebase_core*`/`cached_network_image*`/`flutter_cache_manager` do `pubspec.yaml` (confirmado sem uso via `flutter pub deps`). Config nativa (`google-services.json`, `GoogleService-Info.plist`, plugin Gradle) não foi tocada — ver `MIGRATION_CHECKLIST.md`. |
| **`content/schemas/concept.schema.json`**, **`content/reference/conceitos.json`** | **ADDED** | Novo schema e dado local para a seção Análise Técnica, substituindo a leitura via `ConceitosRecord`. |
| **`lib/backend/schema/platform_concept_model.dart`**, **`lib/backend/repositories/concept_repository.dart`** | **ADDED** | Modelo e repositório locais para os conceitos de Análise Técnica. |
| **`lib/pages/course/quiz_session_widget.dart`**, **`quiz_session_model.dart`** | **ADDED** | Simulado geral que substitui o `QuizWidget` legado, agregando os quizzes de todos os cursos via `LocalCourseRepository`. |
