# Keep / Remove Matrix - Architectural Reorganization

Esta matriz cataloga as decisões de destino de cada arquivo chave do repositório durante a migração para a plataforma orientada a dados.

| Caminho do Arquivo | Status | Destino / Justificativa |
| :--- | :---: | :--- |
| **`lib/main.dart`** | **REFACTOR** | Manter inicialização, refatorando boot para carregar o catálogo dinâmico de cursos. |
| **`lib/backend/local_data_manager.dart`** | **REFACTOR** | Expandir para suportar schemas de progresso, XP e logs analíticos dinâmicos. |
| **`lib/pages/inicio/inicio_widget.dart`** | **REFACTOR** | Remover botões de cursos fixos. A Home deve carregar a lista de cursos dinamicamente via `CourseRepository`. |
| **`lib/backend/schema/course_models.dart`** | **REFACTOR** | Adaptar para refletir exatamente os novos schemas formais JSON. |
| **`lib/pages/course/course_widget.dart`** | **REFACTOR** | Adaptar para consumir os novos modelos de dados genéricos carregados de forma dinâmica. |
| **`lib/pages/course/module_panel_widget.dart`** | **REFACTOR** | Dividir logicamente nas sub-views de renderizadores e integrar o `GenericVectorPainter`. |
| **`lib/pages/quiz/quiz_widget.dart`** | **REMOVE** | O Quiz vira parte do renderizador genérico e os dados migram para os JSONs dos cursos. O widget antigo será deletado. |
| **`lib/pages/smc/smc_widget.dart`** | **REMOVE** | Substituído por `CourseWidget` carregando `smc_course.json`. Deletar arquivo. |
| **`lib/pages/smc/detalhe_smc_widget.dart`** | **REMOVE** | Substituído por `ModulePanelWidget`. Deletar arquivo. |
| **`lib/pages/elliott/elliott_widget.dart`** | **REMOVE** | Substituído por `CourseWidget` carregando `elliott_course.json`. Deletar arquivo. |
| **`lib/pages/elliott/detalhe_elliott_widget.dart`** | **REMOVE** | Substituído por `ModulePanelWidget`. Deletar arquivo. |
| **`lib/pages/tarot/tarot_widget.dart`** | **KEEP** | O Tarot Trader é um terminal psicológico utilitário isolado. Manter como tela especial. |
| **`lib/pages/calculadoras/calculadoras_widget.dart`** | **KEEP** | Calculadora de contratos futuros é utilitário de mercado. Manter. |
| **`assets/jsons/*.json`** *(legados)* | **MIGRATE** | Migrar dados legados para os novos arquivos sob `content/courses/` seguindo as diretrizes dos Schemas. |
