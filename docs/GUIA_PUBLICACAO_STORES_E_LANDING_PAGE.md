# 📘 Guia de Publicação, Deploy e Landing Page — Price Action Master

Este documento consolida todas as diretrizes, procedimentos e checklists para a publicação da **Landing Page na Hostinger**, o processo de **lançamento na Apple App Store (iOS)** e a **atualização na Google Play Store (Android)**.

---

## 📑 Sumário
1. [Landing Page: Arquitetura & Deploy na Hostinger](#1-landing-page-arquitetura--deploy-na-hostinger)
2. [Guia de Publicação na Apple App Store (iOS)](#2-guia-de-publicação-na-apple-app-store-ios)
3. [Guia de Atualização no Google Play Console (Android)](#3-guia-de-atualização-no-google-play-console-android)
4. [Dicas de Compliance e Aprovação para Apps Financeiros](#4-dicas-de-compliance-e-aprovação-para-apps-financeiros)

---

## 1. Landing Page: Arquitetura & Deploy na Hostinger

A landing page desenvolvida na pasta [`landing/`](file:///d:/projects/tradingplan/price_action_master/landing) foi projetada sob o conceito **100% estático e autocontido** (HTML5, Vanilla CSS3 e Vanilla JS), sem dependências de backend, tornando a hospedagem compartilhada da Hostinger a escolha ideal.

### 📁 Estrutura dos Arquivos da Landing Page
```
landing/
├── index.html        # Estrutura semântica, metatags de SEO e Open Graph
├── style.css         # Design system Dark Luxury Terminal, animações e responsividade
├── app.js            # Motores de cálculo B3, simulador no Canvas e FAQ
└── assets/
    └── images/       # Favicons, logotipos e gráficos de visualização
```

### 🚀 Passo a Passo para Deploy na Hostinger (hPanel):
1. **Compactar os Arquivos:**
   - Selecione todo o conteúdo de `landing/` (`index.html`, `style.css`, `app.js` e a pasta `assets/`) e crie um arquivo `landing.zip`.
2. **Acessar o Gerenciador de Arquivos:**
   - Acesse o painel **hPanel da Hostinger** ➔ **Websites** ➔ **Gerenciar**.
   - Abra o **Gerenciador de Arquivos** (*File Manager*) e navegue até a pasta **`public_html/`**.
3. **Upload e Extração:**
   - Envie o `landing.zip` para dentro de `public_html/`.
   - Clique com o botão direito e selecione **Extrair** (*Extract*).
   - *(Certifique-se de que o `index.html` esteja diretamente na raiz de `public_html` para carregar na URL principal `https://seusite.com.br`).*
4. **Configurações Recomendadas no hPanel:**
   - **SSL Grátis:** Ativar HTTPS em *Segurança ➔ SSL*.
   - **LiteSpeed Cache:** Manter ativado para garantir entrega em CDN com tempo de carregamento inferior a 1 segundo.

---

## 2. Guia de Publicação na Apple App Store (iOS)

O Flutter compila o código Dart de forma nativa para iOS. Para disponibilizá-lo na loja da Apple, siga as etapas abaixo:

### ⚙️ Pré-Requisitos:
- Conta **Apple Developer Program** ativa (US$ 99/ano) em [developer.apple.com](https://developer.apple.com/).
- Computador com **macOS + Xcode** instalado (ou serviço de nuvem/CI-CD como *Codemagic* ou *GitHub Actions*).

### 🛠️ Configuração Técnica no Projeto (`ios/`):

1. **Ajuste de Versão no [`pubspec.yaml`](file:///d:/projects/tradingplan/price_action_master/pubspec.yaml):**
   ```yaml
   version: 1.0.0+1 # [Versão].[Subversão].[Correção]+[Número do Build]
   ```

2. **Configuração no Xcode (`ios/Runner.xcworkspace`):**
   - **Signing & Capabilities:**
     - Marque *"Automatically manage signing"*.
     - Selecione seu **Team** de desenvolvedor Apple.
     - Defina o **Bundle Identifier** único (ex: `com.tradingplan.priceactionmaster`).
   - **General:**
     - **Display Name:** `Price Action Master`
     - **Deployment Target:** iOS 14.0 ou superior.
     - **App Icons:** Verificar se o conjunto `AppIcon` está preenchido em `Assets.xcassets`.

### 📦 Geração do Pacote de Produção:
No terminal do projeto, execute:
```bash
flutter build ipa --release
```

### 🌐 Configuração no App Store Connect:
1. Acesse [appstoreconnect.apple.com](https://appstoreconnect.apple.com/) ➔ **Meus Apps** ➔ **+ Novo App**.
2. **Dados Básicos:**
   - **Nome:** *Price Action Master*
   - **Idioma:** Português (Brasil)
   - **Bundle ID:** Selecione o Bundle ID configurado no Xcode.
   - **SKU:** Ex: `pam-ios-v1`.
3. **Mídias Obrigatórias:**
   - Screenshots para tela de **6.7"** (ex: iPhone 15/16 Pro Max - 1290 x 2796 px) e **6.5" / 5.5"**.
4. **Metadados & Textos:**
   - **Descrição:** Destaque para Price Action, Smart Money Concepts (SMC), Ondas de Elliott, Calculadoras de risco (B3, CME e Forex) e 100% Offline.
   - **Palavras-chave (Keywords):** `price action, smc, smart money concepts, mini indice, mini dolar, b3, nq, es, day trade, elliott, candlesticks`.
   - **URL de Suporte e Privacidade:** Inserir a URL da Landing Page hospedada (ex: `https://seusite.com.br`).
5. **Privacidade do App (App Privacy):**
   - Como o app funciona **100% offline**, informe que **não há coleta nem rastreamento de dados pessoais**.
6. **TestFlight & Envio:**
   - Envie o binário gerado pelo Xcode (*Archive ➔ Distribute*) ou pelo app **Transporter**.
   - Teste no **TestFlight** e clique em **Enviar para Revisão** (*Submit for Review*). Tempo médio de análise: **24 a 48 horas**.

---

## 3. Guia de Atualização no Google Play Console (Android)

Como você já possui conta de desenvolvedor no Google Play, o processo de atualização consiste em:

### 🛠️ Passos de Compilação & Envio:
1. **Incrementar o `pubspec.yaml`:**
   ```yaml
   version: 1.0.1+2 # O número após o '+' (build number) deve ser SEMPRE maior que o anterior
   ```
2. **Gerar o Android App Bundle (.aab):**
   ```bash
   flutter build appbundle --release
   ```
   *O arquivo gerado estará em:*  
   `build/app/outputs/bundle/release/app-release.aab`

3. **Publicar no Google Play Console:**
   - Acesse [play.google.com/console](https://play.google.com/console).
   - Selecione o aplicativo **Price Action Master**.
   - Vá em **Produção** (ou Teste Aberto/Fechado) ➔ **Criar nova versão**.
   - Faça o upload do arquivo `app-release.aab`.
   - Preencha as **Notas da Versão** (ex: *Nova versão com motor de Smart Money Concepts v2, novas calculadoras B3 e simulador otimizado*).
   - Clique em **Revisar e Lançar Versão**.

---

## 4. Dicas de Compliance e Aprovação para Apps Financeiros

> [!IMPORTANT]
> Tanto a **Apple** quanto o **Google** possuem regras rígidas para aplicativos da categoria Finanças/Trading para combater golpes e promessas irreais de enriquecimento.

Para garantir **aprovação imediata sem contestações**:

1. **Classificação Educacional:**
   - Registre a categoria primária como **Educação** ou **Finanças (Educacional / Ferramenta)**.
2. **Disclaimer Obrigatório na Descrição das Lojas e no App:**
   > *"O Price Action Master é uma plataforma de estudo, treinamento de leitura gráfica e gestão de risco educacional. O aplicativo não executa operações financeiras reais, não capta recursos de terceiros e não fornece recomendações de compra ou venda de ativos."*
3. **Nenhum Recurso Quebrado ou Placeholder:**
   - A Apple rejeita aplicativos com botões que não realizam ação (*Guideline 2.1 - App Completeness*). Todas as telas e calculadoras do Price Action Master são 100% funcionais e offline.
4. **Sem Promessa de Ganhos Fixos:**
   - Evitar termos como *"garantia de lucro"*, *"robô milagroso"* ou *"sinais 100% assertivos"*. Foque em termos técnicos: *leitura estrutural, gestão de risco, cálculo de lotes e treinamento de competências*.

---

*Documento gerado e integrado ao repositório do Price Action Master em 04/10/2026.*
