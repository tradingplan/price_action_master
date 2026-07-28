# Guia: Como Adicionar Novos Conteúdos no App

Este guia orienta sobre como expandir os conteúdos educativos (como novas velas, figuras gráficas, Smart Money Concepts - SMC, Ondas de Elliott e Quizzes) sob a nova arquitetura **Offline-First**.

---

## 1. Fluxo Recomendado: Delegação para a IA

O fluxo mais rápido e seguro contra erros de sintaxe (como aspas inválidas ou chaves órfãs no JSON) é passar o conteúdo bruto para a IA formatar.

### Como solicitar:
Basta copiar e colar o texto explicativo, anotação ou lista de perguntas aqui no chat e pedir a integração.
> **Exemplo de comando:**
> *"Adicione este novo padrão de vela no app:
> Nome: Estrela da Manhã (Morning Star)
> Descrição: Padrão de reversão de alta de 3 velas...
> [cole o restante do texto aqui]"*

A IA fará a conversão automática para o formato do banco local, atualizará as dependências de arquivos e validará a compilação do projeto.

---

## 2. Inserção Manual (Estrutura dos Arquivos JSON)

Caso prefira editar diretamente, os dados ficam localizados no diretório:
`d:\projects\price_action_master\assets\jsons\`

### A. Estrutura dos Catálogos (`candlesticks.json`, `figuras.json`, `conceitos.json`)
Cada item no arquivo JSON deve seguir este modelo de objeto:

```json
  {
    "id": "identificador_unico_minusculo",
    "nome": "Nome de Exibição do Padrão",
    "icon": "emoji_ou_caractere_de_atalho",
    "description": "Texto explicativo detalhado sobre as características visuais e teóricas.",
    "overview": [
      "Item chave 1 (ex: Sombra inferior longa)",
      "Item chave 2 (ex: Corpo pequeno)"
    ],
    "contexto": "Regras de contexto (ex: Ocorre em fundos de tendências).",
    "psicologia": "Explicação da psicologia dos compradores e vendedores.",
    "confirmation": "Regras de confirmação do padrão para entrada.",
    "chart": "URL da imagem ilustrativa (Firebase Storage ou local)",
    "pattern": "Direção da reversão: Alta, Baixa ou Indecisão"
  }
```
*Nota: As chaves `overview`, `contexto`, `psicologia` e `confirmation` são usadas primariamente na tela de detalhes de Candlesticks. Nas figuras e conceitos simples, os campos básicos de `id`, `nome`, `icon`, `description` e `chart` são suficientes.*

### B. Estrutura de Quizzes (`quizzes.json` - Planejado)
Para adicionar perguntas de quiz, a estrutura padrão recomendada é:

```json
[
  {
    "category": "CANDLESTICKS",
    "question": "Texto da pergunta que será exibida ao usuário?",
    "illustration": "Código HTML/SVG para desenhar o gráfico inline (opcional)",
    "options": [
      { "text": "Opção Incorreta A", "isCorrect": false },
      { "text": "Opção Correta B", "isCorrect": true },
      { "text": "Opção Incorreta C", "isCorrect": false },
      { "text": "Opção Incorreta D", "isCorrect": false }
    ],
    "explanation": "Explicação pedagógica detalhada exibida após o usuário responder."
  }
]
```

---

## 3. Imagens e Mídia
As imagens de suporte aos padrões (campo `"chart"`) podem ser configuradas de duas formas:
1.  **URLs Online (Recomendado para manter o app leve):** Endereços HTTPS hospedados em serviços de armazenamento (como Firebase Storage ou AWS S3). O aplicativo utiliza cache automático, de modo que após a primeira abertura do app online, as imagens funcionam perfeitamente sem internet.
2.  **Arquivos Locais (Offline total de fábrica):** Armazenar a imagem na pasta `assets/images/` e referenciar o caminho relativo no JSON (ex: `assets/images/hammer.png`).

---

## 4. Uso de Referências e Formatos Suportados pela IA
Para adicionar novos conteúdos a partir de materiais de referência que você já possua (como PDFs, arquivos Markdown ou imagens), siga estas diretrizes:

### Onde colocar os materiais de referência?
- **No Workspace do Projeto (Recomendado):** Salve os materiais em uma pasta de referências dentro do seu próprio projeto (por exemplo, em `docs/references/` ou `assets/references/`). Isso me permite acessá-los diretamente, mantendo o repositório autocontido.
- **Evite pastas de sistema:** Não coloque esses arquivos nos diretórios de configuração do agente (como `.agents/` ou na pasta global de `knowledge`), pois estes são reservados para regras de codificação e customizações da IA, e não para dados do aplicativo.

### Formatos que a IA consegue analisar e processar:
- **Textos e Dados:** `.md` (Markdown), `.json`, `.txt`, `.yaml`/`.yml`, `.csv`, etc.
- **Documentos Estruturados:** `.pdf` (leitura completa do texto e do conteúdo).
- **Imagens:** `.png`, `.jpg`, `.jpeg`, `.webp` (leitura visual de gráficos, mockups de UI e diagramas).
- **Mídia:** formatos comuns de áudio e vídeo (caso precise validar fluxos ou animações).

Basta colocar as referências na pasta do projeto e me pedir: *"Gere o JSON do curso X usando o arquivo docs/references/manual.pdf como fonte de informação."*
