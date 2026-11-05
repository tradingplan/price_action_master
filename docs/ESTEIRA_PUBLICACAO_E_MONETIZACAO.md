# 🚀 Guia Oficial da Esteira de Publicação & Monetização
## Price Action Master (`br.com.tradingplan.priceactionmaster`)

Este documento orienta o processo completo de compilação, envio para teste interno, criação de produtos in-app no Google Play Console e gestão da monetização (com ou sem RevenueCat).

---

## ⚡ Comandos Rápidos da Esteira Mobile

No terminal do projeto (`d:\projects\tradingplan\price_action_master`):

```powershell
# 1. Limpar caches e atualizar dependências
flutter clean
flutter pub get

# 2. Gerar o Android App Bundle (.aab) assinado de Produção
flutter build appbundle --release

# O arquivo gerado estará em:
# build\app\outputs\bundle\release\app-release.aab
```

---

## ❓ Preciso usar o RevenueCat neste app?

### Resposta Direta: **NÃO.**

* **Por que não é necessário?**
  - O RevenueCat é essencial para gerenciar **assinaturas recorrentes** (mensais/anuais, estornos, renovações, períodos de carência, webhooks para servidores como Supabase).
  - No **Price Action Master**, a monetização é uma **Compra Única Vitalícia (Non-Consumable) de R$ 19,90** sob uma arquitetura **100% Offline-First (sem cadastro/login de usuário)**.
  - A biblioteca oficial do Flutter (`in_app_purchase`) que acabamos de implementar atende perfeitamente:
    1. Abre o pop-up nativo da Google Play Store (cartão, saldo ou Pix).
    2. A Google Play valida a transação e entrega o recibo.
    3. O app salva localmente e libera o acesso vitalício imediatamente.
    4. O botão **"Restaurar Acesso"** consulta a Conta Google do usuário e recupera a compra em qualquer celular novo sem custos adicionais.

* **Quando valeria a pena usar o RevenueCat?**
  - Se você quiser visualizar métricas de faturamento consolidadas no mesmo painel web do seu outro app (*Oráculo Aurora*).
  - Se futuramente você decidir criar assinaturas recorrentes (ex: sala de sinais ou conteúdos mensais).
  *(A seção 5 deste documento ensina a plugar o RevenueCat caso prefira essa unificação).*

---

## 🤖 1. Configurações Técnicas do Pacote Android

* **Nome do App:** `Price Action Master` (19 / 30 caracteres)
* **Application ID / Package:** `br.com.tradingplan.priceactionmaster`
* **Versão para o próximo envio:** `version: 1.0.3+5` (no `pubspec.yaml`)
* **Chave de Assinatura (Keystore):** Configurada em `android/key.properties`
* **Target SDK:** Android 14 / 15 (`targetSdkVersion 36`)
* **Permissões de Faturamento:**
  - `com.android.vending.BILLING` (injetada automaticamente pelo plugin no AndroidManifest)
  - `android.permission.INTERNET` (para comunicação segura com a loja)

---

## 💎 2. Estrutura de Precificação e Produtos In-App

| Produto / Modalidade | ID no Google Play | Tipo de Compra | Nome Oficial na Loja | Preço Sugerido | Papel Estratégico |
|---|---|:---:|---|:---:|---|
| **Acesso Vitalício PRO** | `pam_pro_lifetime` | **Não-Consumível** *(Compra Única)* | `Price Action Master PRO Vitalício` | **R$ 19,90** *(pagamento único)* | 20 Setups Táticos, SMC Avançado, Checklists e Sem Anúncios. |

---

## 📲 3. Roteiro Passo a Passo no Google Play Console

### ⚠️ Regra de Ouro da Google Play:
> Você **NÃO** consegue criar nem ativar produtos in-app na Google Play antes de subir ao menos uma build (`.aab`) que declare a permissão `com.android.vending.BILLING`.

---

### Passo 1: Gerar e Enviar a Nova Build (Teste Interno)
1. No `pubspec.yaml`, confirme a versão atualizada:
   ```yaml
   version: 1.0.3+5
   ```
2. No terminal, execute:
   ```powershell
   flutter build appbundle --release
   ```
3. Acesse o [Google Play Console](https://play.google.com/console) e selecione o app **Price Action Master**.
4. No menu lateral, acesse **Teste $\rightarrow$ Teste interno** (*Internal testing*).
5. Clique em **Criar nova versão** (*Create new release*).
6. Faça o upload do arquivo gerado:
   `build\app\outputs\bundle\release\app-release.aab`
7. Em **Detalhes da versão**, informe:
   - Nome: `1.0.3 (5) - In-App Billing Pro Vitalício`
   - Notas da versão: `Implementação do Google Play Billing para o plano PRO Vitalício.`
8. Clique em **Salvar** $\rightarrow$ **Revisar versão** $\rightarrow$ **Iniciar lançamento para teste interno**.

---

### Passo 2: Criar o Produto In-App Vitalício (`pam_pro_lifetime`)
Com a build enviada no Teste Interno, a seção de produtos estará liberada:

1. No menu lateral, role até **Monetizar com o Google Play $\rightarrow$ Produtos $\rightarrow$ Produtos no app** (*In-app products*).
2. Clique no botão azul **Criar produto**:
   * **ID do produto:** `pam_pro_lifetime` *(atenção: deve ser exatamente idêntico a este texto)*
   * **Nome do produto:** `Price Action Master PRO Vitalício`
   * **Descrição:** `Acesso perpétuo aos 20 setups táticos operacionais, módulo Smart Money Concepts (SMC) avançado, checklists interativos e remoção total de anúncios.`
3. Na seção **Preço**:
   * Clique em **Definir preço**.
   * Digite o valor para o Brasil: **`R$ 19,90`**.
   * O Google Play converterá automaticamente os valores para as demais moedas internacionais.
4. Clique em **Salvar** e, logo em seguida, no canto inferior direito, clique em **Ativar** (*Activate*).

---

### Passo 3: Configurar Contas de Teste (Testes Sem Cobrança Real)
Para testar a compra no seu próprio aparelho sem debitar do seu cartão de crédito:

1. No Google Play Console, vá em **Configurações da conta $\rightarrow$ Teste de licença** (*License Testing*).
2. Adicione o seu e-mail do Gmail (o mesmo e-mail configurado na Play Store do celular de testes).
3. No campo **Resposta do teste de licença**, selecione: `RESPOND_NORMALLY`.
4. Volte em **Teste interno $\rightarrow$ Testadores**:
   - Adicione seu e-mail na lista de testadores.
   - Copie o **link de convite de teste** exibido na tela e abra-o no navegador do celular para aceitar participar do programa.
5. Instale o app pelo link do teste interno no celular.
6. Ao abrir o app e clicar em comprar, o Google Play exibirá a tela com a etiqueta **"Instrumento de teste (você não será cobrado)"**.

---

## 💳 4. (Opcional) Como Integrar com RevenueCat (Se optar por usar)

Caso você opte por criar um projeto dedicado no RevenueCat para gerenciar o app no mesmo painel do Oráculo Aurora:

1. **Adicionar o SDK no `pubspec.yaml`:**
   ```yaml
   dependencies:
     purchases_flutter: ^8.0.0
   ```
2. **Criar o Projeto no RevenueCat:**
   * Acesse [app.revenuecat.com](https://app.revenuecat.com).
   * Clique no seletor de projetos $\rightarrow$ **Create a project**:
     - **Project name:** `Price Action Master`
     - **Category:** `Finance / Education`
     - **Platform:** `Flutter`
3. **Adicionar o App:**
   * Vá em **Project Settings $\rightarrow$ Apps $\rightarrow$ + New App $\rightarrow$ Google Play Store**.
   * **App Name:** `Price Action Master (Android)`
   * **Google Play package name:** `br.com.tradingplan.priceactionmaster`
   * Faça o upload do arquivo de credenciais `.json` da Conta de Serviço do Google Cloud (a mesma do seu console).
4. **Cadastrar Entitlement & Produto:**
   * **Entitlement:** `pam_pro_access`
   * **Product:** Tipo `Non-consumable` $\rightarrow$ ID: `pam_pro_lifetime`.
   * Vincule o produto ao entitlement `pam_pro_access`.
5. **Configurar a API Key:**
   * Copie a chave pública do Android (`goog_...`) e inicialize no Flutter:
     ```dart
     await Purchases.configure(PurchasesConfiguration('goog_xxxxxxxxxxxxxxxxxxxx'));
     ```

