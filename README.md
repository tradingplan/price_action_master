# Price Action Master — Learning Platform & AI Workspace

Plataforma educacional offline-first de alta performance para o ensino prático de **Price Action**, **Smart Money Concepts (SMC)**, **Teoria das Ondas de Elliott** e **Gestão de Risco** aplicados ao mercado financeiro.

Este repositório está estruturado como um **AI Workspace** modular, separando a engenharia de renderização (Flutter) da modelagem de conteúdo educacional (JSON, Schemas e Ferramentas).

---

## 🏗️ Arquitetura do Projeto

O projeto é dividido em dois componentes totalmente independentes:

1.  **Learning Engine (Flutter Application):** Atua exclusivamente como um renderizador reativo de conteúdo e manipulador de estados locais. Não possui lições ou regras de negócios hardcoded.
2.  **Educational Content Database (JSON/Assets):** Catálogo de cursos estruturados de forma declarativa sob schemas JSON rígidos, suportando renderização vetorial geométrica nativa no Canvas.

```text
               [ Conteúdo JSON ]
                       │
                       ▼
            [ LocalCourseRepository ]
                       │
                       ▼
               [ Learning Engine ]
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
   [ Markdown UI ]  [ Canvas ]  [ Gamificação ]
                       │            │
                       ▼            ▼
                 [ 60 FPS Vector ] [ Local XP/Saved State ]
```

---

## 📂 Estrutura de Diretórios

O workspace está organizado da seguinte forma para suportar a manutenção por agentes de IA e desenvolvedores humanos:

*   [`.agents/`](file:///.agents/): Perfis e diretrizes para os papéis especializados de IA.
*   [`content/`](file:///content/):
    *   [`courses/`](file:///content/courses/): Banco de dados de cursos ativos (`candlesticks.json`, `figuras.json`, `smc.json`, `elliott.json`, `gestao_risco.json`).
    *   [`schemas/`](file:///content/schemas/): Schemas JSON que garantem conformidade técnica de todo o conteúdo.
    *   [`examples/`](file:///content/examples/): Exemplos corretos de JSONs para referência rápida.
*   [`docs/`](file:///docs/):
    *   [`00-project/`](file:///docs/00-project/): Regras do workspace, Roadmap, Changelogs e Glossário.
    *   [`01-platform/`](file:///docs/01-platform/): Especificações do SDK, Spaced Repetition e ADRs de arquitetura.
    *   [`02-learning/`](file:///docs/02-learning/): Guias pedagógicos e andragógicos para os criadores de cursos.
    *   [`04-assets/`](file:///docs/04-assets/): Guias sobre a criação de gráficos e mídias.
*   [`lib/`](file:///lib/): Código-fonte da aplicação Flutter (Layouts, Renderizadores e Persistência).
*   [`templates/`](file:///templates/): Modelos JSON em branco para criação ágil de cursos, lições, quizzes e desafios.
*   [`tools/`](file:///tools/): Utilitários CLI de autoria e validação automática.
*   [`playground/`](file:///playground/): Área isolada para testes rápidos e desenvolvimento de novos componentes visuais.
*   [`knowledge/`](file:///knowledge/): Base de conhecimento técnico e andragógico de apoio ao projeto.

---

## 🤖 AI Workspace (Os Agentes de IA)

O projeto define papéis de IA específicos com regras de segurança rígidas em [`.agents/`](file:///.agents/):

*   **Platform Architect:** Cuida de schemas, models Dart e integridade de APIs.
*   **Flutter Engineer:** Cria interfaces, renderizadores reativos e código de tela Dart.
*   **Content Architect:** Cria e expande a ementa de cursos JSON.
*   **Learning Designer:** Garante que o conteúdo respeite a didática andragógica.
*   **Reviewer:** Otimiza o código, analisa lints, logs e testes de regressão.
*   **Asset Builder:** Constrói as coordenadas vetoriais proporcionais do Canvas.
*   **Project Manager:** Organiza tarefas (`task.md`), Roadmap e Changelogs.

---

## 🛠️ Ferramentas Editoriais (Content SDK)

Criamos ferramentas exclusivas na pasta `/tools/` para facilitar o trabalho editorial sem necessidade de encostar em código Dart:

### 1. Criar novo Conteúdo (Content CLI)
Gera automaticamente estruturas JSON em conformidade com as regras do projeto:
```bash
# Criar um novo curso
python tools/content_cli.py create-course <id_do_curso> "Nome do Curso" "Descrição Curta"

# Criar um novo módulo no curso
python tools/content_cli.py create-module <id_do_curso> <id_do_modulo> "Nome do Módulo" "Descrição" --xp 100

# Criar uma nova lição
python tools/content_cli.py create-lesson <id_do_curso> <id_do_modulo> <id_da_licao> "Título da Lição" "Conteúdo em Markdown"
```

### 2. Validar Estrutura e Schemas (Content Validator)
Verifica se todas as lições, coordenadas do Vector Canvas e quizzes estão estruturados corretamente frente aos schemas oficiais:
```bash
python tools/content_validator.py
```

---

## 🚀 Como Executar o Projeto Flutter

### Pré-requisitos
*   Flutter SDK (Stable) instalado na máquina.
*   Python 3 instalado (para usar as ferramentas de conteúdo).

### Passo a Passo
1.  Obtenha as dependências do projeto:
    ```bash
    flutter pub get
    ```
2.  Execute os testes de unidade da plataforma para validar o parser e a persistência:
    ```bash
    flutter test
    ```
3.  Identifique ou configure os dispositivos de execução:
    *   **Listar dispositivos conectados:**
        ```bash
        flutter devices
        ```
    *   **Dispositivo Físico Android:**
        1. No celular Android, ative o **Modo Desenvolvedor** (toque 7 vezes em *Número da versão* em *Sobre o telefone*).
        2. Ative a **Depuração USB** nas *Opções do desenvolvedor*.
        3. Conecte o aparelho ao PC via USB e aprove a janela de permissão da chave RSA no celular.
    *   **Emulador Virtual (Android Studio):**
        1. Crie um dispositivo virtual no **Device Manager** do Android Studio.
        2. Inicialize o emulador (pode listar/iniciar via terminal usando `flutter emulators` e depois `flutter emulators --launch <nome_do_emulador>`).
4.  Execute o aplicativo localmente no dispositivo desejado:
    ```bash
    # Para rodar no primeiro dispositivo disponível (ou escolher em caso de múltiplos)
    flutter run
    
    # Para forçar a execução em um dispositivo específico
    flutter run -d <id_do_dispositivo>
    
    # Exemplo para Web
    flutter run -d chrome
    ```
5.  Execute a análise estática do linter antes de submeter alterações:
    ```bash
    flutter analyze
    ```

---

## 🛡️ Regras Técnicas Inegociáveis
*   **Offline-First:** O aplicativo funciona 100% desconectado. Não são permitidas chamadas ao Firebase ou bancos de dados externos na visualização de lições. Toda persistência do progresso do usuário é gravada e lida localmente pelo `LocalDataManager` no SharedPreferences.
*   **Canvas Vector Painter:** Gráficos pedagógicos e candles são desenhados dinamicamente via `CustomPainter` (`GenericVectorPainter`) a 60 FPS com coordenadas relativas (`[0.0, 1.0]`), eliminando links de imagens externos quebrados.
*   **Não Inserir Placeholders:** Todo curso adicionado ou tela construída deve utilizar recursos e dados reais.
