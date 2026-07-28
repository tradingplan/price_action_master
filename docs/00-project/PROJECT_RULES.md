# Project Rules: Workspace Commandments

Todas as alterações submetidas por engenheiros ou agentes de IA no repositório devem cumprir com as regras inegociáveis abaixo.

---

## Regra 1: Conteúdo Desacoplado (Sem Hardcode)
*   **Nunca** introduza lições, quizzes, desafios, explicações ou exercícios diretamente no código Dart da pasta `lib/`. Todo o conteúdo conceitual e pedagógico pertence unicamente ao diretório `content/courses/` em formato JSON.

---

## Regra 2: Compatibilidade Retroativa de Dados
*   **Nunca** quebre ou altere a estrutura dos campos dos JSONs sem a criação e aprovação formal de um Registro de Decisão de Arquitetura (`ADR.md`). O motor do aplicativo deve ser capaz de carregar conteúdos legados com segurança.

---

## Regra 3: Validação Obrigatória de Schemas
*   Qualquer arquivo JSON de conteúdo adicionado ou modificado **deve** ser validado com sucesso completo por meio do validador automático (`python tools/content_validator.py`) antes de ser empacotado.

---

## Regra 4: Offline-First e Custo Zero
*   **Nunca** insira requisições HTTP, integrações Firebase ou chamadas de API de rede externas na lógica de carregamento de cursos. Todo o estado (XP, progresso, tiragem de cartas e histórico do simulador) deve ser lido e salvo localmente usando o `LocalDataManager`.

---

## Regra 5: Qualidade de Desenho Vetorial
*   Todos os gráficos, diagramas pedagógicos e esquemas devem ser projetados e descritos matematicamente no `vectorCanvas` do JSON de forma proporcional (`[0.0, 1.0]`). Não use imagens PNG/JPEG externas para fins pedagógicos.
