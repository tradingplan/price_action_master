# Diagnóstico e Plano de Modernização: Price Action Master

Este documento apresenta uma análise técnica da base de código atual do **Price Action Master** e propõe estratégias para sua evolução, focando em **operação offline-first**, **custo zero/baixo** e a inclusão das novas funcionalidades planejadas.

---

## 1. Diagnóstico Tecnológico Atual

O projeto atual foi gerado via **FlutterFlow** e utiliza uma arquitetura tradicional integrada ao **Firebase (Cloud Firestore)**.

### Pontos Fortes do Código Atual
*   **Base Flutter sólida:** Já utiliza Flutter estável (SDK `>=3.0.0 <4.0.0`), facilitando a migração para versões mais recentes do Flutter (3.22+ ou 3.24+).
*   **Biblioteca de UI moderna:** Utiliza pacotes excelentes para experiência visual como `flutter_animate` e `google_fonts`.
*   **Suporte multi-plataforma ativo:** Configurações prontas para Android, iOS e Web, com ícones de inicialização configurados.

### Gargalos e Desafios para Offline & Baixo Custo
1.  **Dependência Crítica do Firestore:** O app faz requisições diretas ao Firebase para ler os registros de Candlesticks, Figuras e Conceitos. 
    *   *Problema:* Se o usuário estiver sem internet na primeira inicialização (ou se o cache expirar), o app fica em branco.
    *   *Problema:* Embora o Firestore tenha cache offline nativo, o primeiro carregamento exige conexão e leituras do banco. Em escala, isso gera custos recorrentes de leitura de documentos no Firebase.
2.  **Código Gerado por Ferramenta (FlutterFlow Boilerplate):** O projeto contém muitos arquivos gerados automaticamente (`/flutter_flow`), o que pode dificultar testes automatizados e refatorações limpas caso queira desvincular totalmente a lógica visual da ferramenta visual.

---

## 2. Análise de Custo e Estratégia Offline-First

Para atingir **baixo custo (próximo de zero)** e **operação 100% offline**, a melhor abordagem é **remover o Firestore para o conteúdo estático** e gerenciar os dados localmente.

### Comparativo: Firebase vs. Alternativas de Custo Zero

| Aspecto | Firebase Atual (Firestore) | Abordagem Local-First (Recomendada) | Supabase (Alternativa Cloud) |
| :--- | :--- | :--- | :--- |
| **Custo de Hospedagem** | Grátis no início, mas cobra por leitura/escrita de documentos em escala. | **Zero Custo** (dados embutidos no app). | Plano gratuito muito generoso (Postgres), mas desnecessário se não houver dados compartilhados. |
| **Funcionamento Offline** | Suporta cache offline, mas depende de conexão inicial para popular o cache. | **100% Funcional** imediatamente após o download, sem necessidade de login ou internet. | Depende de sincronização manual ou bibliotecas como PowerSync. |
| **Manutenção do Conteúdo** | Fácil edição via painel do Firebase Console. | Exige atualização do app na loja (ou download de um arquivo JSON estático de uma CDN gratuita como GitHub Pages). | Painel administrativo Postgres. |

### Proposta de Arquitetura Offline-First
*   **Dados Estáticos (Catálogos):** Mudar os dados de *Candlesticks, Figuras e Conceitos* do Firestore para arquivos **JSON locais** (embutidos nos assets) ou um banco local **SQLite/Isar** pré-populado.
*   **Persistência do Usuário (Scores do Quiz, Progresso do Jogo, Calculadoras salvas):** Utilizar um banco de dados local leve como o **Isar Database** (NoSQL super rápido) ou **SQLite (drift / sqflite)**.
*   **Custo de Infraestrutura:** **R$ 0,00**. Não haverá servidores rodando, o processamento ocorre inteiramente no dispositivo do usuário.

---

## 3. Plano de Implementação de Novas Funcionalidades

### A. Quiz de Trade
Sistema de perguntas e respostas para testar os conhecimentos do usuário sobre os padrões aprendidos.
*   **Arquitetura:** As perguntas são salvas em um arquivo JSON estático local (`assets/jsons/quizzes.json`).
*   **Pontuação e Histórico:** O progresso do usuário (nível, acertos, ranking local) é gravado no banco de dados local do aparelho.
*   **Tipos de Questão:** Múltipla escolha, identificar padrão na imagem ou decidir se entra comprado/vendido com base em um cenário gráfico exibido.

### B. Jogos de Trade (Simulador de Price Action)
Um simulador simplificado de operações com gráficos históricos estáticos.
*   **Como funciona offline:** Embutir no app alguns conjuntos de dados históricos de candles (ex: 200 candles de mini-índice ou Bitcoin em formato JSON).
*   **Mecânica:** O app renderiza o gráfico candle a candle. O usuário pode clicar em **"Comprar"**, **"Vender"** ou **"Avançar"**. O app calcula o resultado financeiro virtual (gain/loss) com base no movimento subsequente do gráfico.
*   **Visual:** Utilização de mini-gráficos simples usando pacotes como `fl_chart` (leve e customizável) para desenhar as velas de forma interativa.

### C. Tarot Trader
Uma ferramenta de psicologia e controle emocional do trading baseada na "tiragem de cartas" de Tarot adaptada ao comportamento de mercado.
*   **Objetivo:** Ajudar o trader a refletir sobre seu estado emocional antes de operar (combate à ganância, ansiedade, overtrading).
*   **Mecânica:**
    1. O usuário clica para "Tirar uma Carta do Dia".
    2. Uma animação bonita (usando `flutter_animate`) revela uma carta temática (Ex: *A Torre* = Iminência de quebra de suporte ou risco alto; *O Louco* = Entradas impulsivas sem plano).
    3. Exibe um conselho de psicologia de trading associado à carta tirada.
*   **Assets:** Imagens das cartas na pasta `assets/images/tarot/` e textos em um arquivo de localização ou JSON local.

### D. Calculadoras de Trading
Ferramentas utilitárias essenciais operadas de forma 100% offline.
*   **Calculadora de Gestão de Risco / Tamanho de Posição:** O usuário insere o capital total, o percentual de risco aceitável (ex: 1%) e a distância do Stop Loss em pontos/ticks. O app calcula o tamanho ideal do lote/contrato.
*   **Calculadora de Relação Risco x Retorno:** Projeção de alvos de ganho com base no risco assumido.
*   **Pontos de Pivot e Retrações de Fibonacci:** Cálculos matemáticos simples a partir das máximas, mínimas e fechamento informados pelo usuário.

---

## 4. Roteiro de Migração e Modernização (Roadmap)

### Fase 1: Desacoplamento do Firebase e Migração Local
1.  Exportar os dados atuais do Firestore para arquivos JSON.
2.  Importar os JSONs para o projeto na pasta `assets/jsons/`.
3.  Substituir os queries do Firestore em `lib/pages/...` por leituras do arquivo JSON local (usando `rootBundle.loadString()`).
4.  Remover os pacotes de Firebase do `pubspec.yaml` que não forem necessários (deixando apenas o básico de Analytics, se desejar acompanhar métricas de uso gratuitas).

### Fase 2: Implementação do Banco Local (Isar ou Drift)
1.  Adicionar o banco local para armazenar o progresso do usuário.
2.  Estruturar as tabelas para:
    *   Histórico de Quizzes concluídos.
    *   Saldo e estatísticas do Simulador de Trade.
    *   Logs das últimas cartas tiradas no Tarot Trader.
    *   Cálculos salvos ou favoritos.

### Fase 3: Desenvolvimento das Novas Telas
1.  **Calculadoras:** Telas de formulários simples e reativos.
2.  **Tarot Trader:** Tela interativa com animação de flip de cartas 3D ou 2D suave.
3.  **Quiz:** Mecânica de game show com barra de progresso, sons locais (opcional) e feedback imediato de certo/errado.
4.  **Simulador de Trade:** Desenvolvimento do mini-gráfico interativo e simulação de ordens de compra/venda.

---

## Recomendação de Próximos Passos
> [!IMPORTANT]
> Se o seu foco é **custo zero** e **funcionalidade offline**, a eliminação da dependência direta de leitura de dados do Firebase Firestore para o conteúdo estático é o passo mais importante.
>
> Recomendo iniciarmos pela **Fase 1**, migrando a base de dados de candlesticks e figuras gráficas para os assets locais. Isso tornará o app instantaneamente mais rápido e independente de internet.

Gostaria de detalhar ou iniciar por alguma funcionalidade específica do plano (por exemplo, a modelagem do Quiz ou o design da tela do Tarot Trader)?
