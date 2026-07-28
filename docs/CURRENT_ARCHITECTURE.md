# Current Architecture Audit - Price Action Master

Este documento detalha o estado técnico e de dados da aplicação **Price Action Master** antes do início da refatoração e desacoplamento de conteúdo da plataforma.

---

## 1. Mapeamento de Dependências e Fluxo de Dados
Atualmente, o aplicativo está estruturado como um projeto Flutter com forte acoplamento de lógica, navegação e conteúdo educacional. 

*   **Ponto de Entrada:** `lib/main.dart` inicializa o app e o `LocalDataManager`.
*   **Menu Principal:** [inicio_widget.dart](file:///d:/projects/price_action_master/lib/pages/inicio/inicio_widget.dart) possui rotas estáticas ligando os botões de menu aos renderizadores correspondentes.
*   **Persistência de Dados do Usuário:** Realizada por [local_data_manager.dart](file:///d:/projects/price_action_master/lib/backend/local_data_manager.dart) através de:
    *   `SharedPreferences` para saldo virtual (`capital`), controle de tiragem do Tarot (`getLastTarotDrawDate`, `getLastTarotCardId`) e progresso de módulos (`completed_${courseId}_${moduleId}`).
    *   Arquivos locais (`quiz_history.json`, `trade_history.json`) para logs e logs transacionais.
*   **Carregamento de Banco de Dados local:** Arquivos JSON locais sob `assets/jsons/` (ex: `candlesticks.json`, `figuras.json`, `quiz.json`, `tarot_cards.json`) são lidos pelo `rootBundle` e convertidos diretamente em instâncias locais ou models do FlutterFlow.

---

## 2. Acoplamento de Conteúdo e Renderizadores
Embora tenhamos avançado em direção a um banco de dados local em JSON, ainda existem acoplamentos severos no aplicativo:

### A. Telas de Detalhes Estáticas (Fase 1 do PRD)
*   As telas `detalhe_candlestick_widget.dart`, `detalhe_figura_widget.dart`, `detalhe_smc_widget.dart` e `detalhe_elliott_widget.dart` possuem lógicas internas que dependem diretamente de dados estruturais de cada ativo.
*   A renderização gráfica está acoplada a identificadores específicos passados por parâmetro que acionam estruturas condicionais complexas para pintar no Canvas.

### B. Ilustrações Vetoriais Nativas (Canvas)
*   **SMC:** `SMCIllustration` (em `detalhe_smc_widget.dart`) escolhe o CustomPainter (`SMCDiagramPainter` ou `SMCCandlePainter`) baseado em strings estáticas como `'bos'`, `'choch'`, `'order_block'`, `'fvg'`.
*   **Elliott:** `ElliottIllustration` (em `detalhe_elliott_widget.dart`) decide a pintura das 5 ondas impulsivas ou corretivas A-B-C a partir dos valores `'impulse'`, `'corrective'`, `'rules'`.
*   **Quiz:** `QuizIllustration` (em `quiz_widget.dart`) desenha velas ou figuras com base em `'hammer'`, `'engulfing'`, `'oco_inverted'`, etc.

---

## 3. Estado de Persistência de Progresso
O progresso atual é binário: completo ou incompleto por ID de módulo (`completed_smc_smc_m1`).
Não há suporte a:
*   Controle detalhado de leitura por lição.
*   Sistemas de repetição espaçada baseados no tempo de resposta do quiz.
*   Controle de experiência (XP) acumulada.
*   Emissão de certificados com chaves criptográficas locais.

---

## 4. Oportunidade da Nova Arquitetura
Ao migrar para um modelo orientado a dados:
1.  **Flutter livre de conteúdo:** O código-fonte Dart não conhecerá o que é "BOS", "Martelo" ou "Ondas de Elliott". Ele apenas interpretará estruturas genéricas como `Course`, `Module`, `Lesson`, `Example`, `Quiz`, `Challenge`, `Certificate`, `Analytics`, pintando na tela conforme as diretrizes do JSON carregado.
2.  **SDK de Conteúdo:** O Content Architect e o Asset Builder poderão publicar e atualizar novos cursos inteiros apenas criando novas pastas e arquivos JSON válidos nos schemas, reduzindo o time-to-market pedagógico a zero sem necessidade de novos deploys de app nas lojas (Google Play / App Store).
