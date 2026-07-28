# Project Context: Memory and System Overview

Este documento serve como a memória permanente da arquitetura e organização do projeto **Price Action Master**. Ele fornece a visão unificada do produto para que agentes de IA e engenheiros humanos compreendam todo o ecossistema.

---

## 1. Visão do Produto
O **Price Action Master** é um ecossistema de aprendizagem offline-first voltado ao ensino profissionalizante de análise técnica de preços e comportamento de trading. O produto baseia-se em auto-suficiência instrucional, sem necessidade de banco de dados centralizado ou conexão de rede (custo de infraestrutura zero).

---

## 2. Arquitetura do Sistema
O ecossistema é dividido fisicamente em duas partes completamente independentes:
1.  **Learning Engine (Motor em Flutter):** Código Dart localizado em `lib/`. Ele atua exclusivamente como um renderizador reativo genérico de componentes de tela e Canvas geométrico.
2.  **Educational Data (Conteúdo em JSON):** Banco de dados localizado em `content/`. Nenhum texto pedagógico é programado no Flutter; a ementa de aulas é alimentada em tempo de execução pelos JSONs.

---

## 3. Fluxo de Dados e Renderização
*   O aplicativo inicializa a listagem através do `LocalCourseRepository` em `lib/backend/repositories/course_repository.dart`.
*   O repositório descobre e lê os JSONs oficiais da pasta `content/courses/` registrados nos assets do `pubspec.yaml`.
*   Ao navegar para um módulo, o `ModulePanelWidget` distribui os dados dinâmicos da lição, exemplos, checklists, perguntas e desafios para os renderizadores genéricos em `course_renderers.dart`.
*   Se o exemplo contiver um `vectorCanvas`, o `GenericVectorPainter` desenha os pavios, corpos de velas e linhas proporcionais no Canvas físico a 60 FPS nativamente.

---

## 4. Persistência e Gamificação
Qualquer alteração de progresso (conclusão de módulo) ou gamificação (ganho de XP) do usuário é persistida no dispositivo local por meio do `LocalDataManager` salvando chaves simples no `SharedPreferences` e gravando relatórios de histórico.
