# Architectural Decision Records (ADR) - Price Action Master

Este documento registra as decisões arquiteturais tomadas para o projeto e suas respectivas justificativas de engenharia de software.

---

## ADR 1: Desacoplamento Total de Conteúdo (Data-Driven)

*   **Contexto:** O conteúdo educacional e diagramas estavam hardcoded ou estruturados em views específicas por disciplina, limitando a escalabilidade.
*   **Decisão:** Separar a plataforma (Flutter como renderizador genérico) do conteúdo (arquivos JSON e schemas independentes).
*   **Consequência:** Novos cursos podem ser criados sem alterar o código Dart ou recompilar o aplicativo. Baixo acoplamento e alta reutilização.

---

## ADR 2: Persistência de Progresso Offline-First de Custo Zero

*   **Contexto:** Necessidade de salvar pontuações, XP, Tarot diário e progresso sem custo de servidores de nuvem (Firebase).
*   **Decisão:** Usar `SharedPreferences` para preferências chave-valor e arquivos JSON criptografados locais para dados históricos e transacionais estruturados.
*   **Consequência:** 100% offline, latência zero de rede, custo zero de infraestrutura de dados para o negócio.

---

## ADR 3: Renderizador Geométrico Vetorial Dinâmico (Canvas)

*   **Contexto:** Imagens externas aumentam o tamanho do app e falham offline, enquanto CustomPainters específicos aumentam o código compilado.
*   **Decisão:** Implementar um pintor geométrico genérico (`GenericVectorPainter`) que interpreta primitivos descritos no JSON em coordenadas proporcionais.
*   **Consequência:** Renderização perfeita a 60 FPS, sem peso de download de imagens, e novos diagramas descritos inteiramente em JSON.
