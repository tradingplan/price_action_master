Sim. Eu faria isso como uma **Product Specification (PRD) + UX Specification**, porque ela serve tanto para o agente de código quanto para o agente de UI/UX. Ela define arquitetura, comportamento, fluxo e responsabilidades, sem prender a implementação.

---

# Price Action Master

## Learning Engine v2

### Product Specification

---

# Objetivo

Transformar o Price Action Master de uma biblioteca de conteúdo em uma plataforma de treinamento baseada em competências.

O usuário não apenas lê conteúdo.
Ele estuda, pratica, recebe feedback e evolui.

---

# Core Principles

Todo conteúdo deve seguir exatamente a mesma arquitetura.

```
Learn

↓

Understand

↓

Practice

↓

Receive Feedback

↓

Master

↓

Advance Level
```

O aplicativo deve medir competência, não quantidade de páginas visitadas.

---

# Learning Architecture

Cada disciplina (Candlesticks, SMC, Elliott...) é composta por módulos.

```
Course

├── Module
│     ├── Lesson
│     ├── Examples
│     ├── Exercises
│     ├── Quiz
│     └── Challenge
```

---

# Course Structure

Cada curso possui:

```
Introduction

Modules

Progress

Challenges

Final Assessment

Certificate
```

---

# Lesson Structure

Toda lição possui exatamente a mesma estrutura.

```
Lesson

1 Introduction

2 Technical Concept

3 Anatomy

4 Identification Checklist

5 Correct Examples

6 Wrong Examples

7 Interactive Practice

8 Summary

9 Mini Quiz
```

---

# 1. Introduction

Objetivo da lição.

Tempo estimado.

Pré-requisitos.

Competências desenvolvidas.

---

# 2. Technical Concept

Texto curto.

Máximo:

* 3 parágrafos
* 1 imagem
* 3 conceitos principais

Nunca criar páginas enormes.

---

# 3. Anatomy

Imagem interativa.

Exemplo:

```
Hammer

↓

Body

↓

Upper Wick

↓

Lower Wick

↓

Close

↓

Open
```

Cada região possui tooltip.

---

# 4. Identification Checklist

Transformar teoria em checklist.

Exemplo.

```
□ Trend exists

□ Break of Structure

□ Strong displacement

□ Institutional candle

□ Return to mitigation
```

O usuário aprende repetindo checklists.

---

# 5. Correct Examples

Mostrar gráficos.

Sempre do mais simples ao mais difícil.

Cada gráfico possui:

```
Difficulty

Easy

Medium

Hard

Professional
```

---

# 6. Wrong Examples

Mostrar gráficos parecidos.

Perguntar:

```
Why is this NOT an Order Block?
```

Esse módulo reduz falsos positivos.

---

# 7. Interactive Practice

Não usar múltipla escolha.

O usuário interage com o gráfico.

Tipos:

```
Tap

Drag

Select Area

Connect

Sequence

Replay
```

---

## Tap

```
Identify BOS
```

---

## Select Area

```
Mark the Order Block
```

---

## Connect

```
Connect Wave 1 → Wave 5
```

---

## Sequence

```
Arrange:

BOS

CHoCH

Mitigation

Continuation
```

---

## Replay

Mostrar candles um a um.

O usuário responde antes do próximo candle.

---

# 8. Summary

Resumo curto.

```
Key Takeaways

Common Mistakes

Trading Tips
```

---

# 9. Mini Quiz

5 perguntas.

Misturar:

Texto

Imagem

Gráfico

Situação prática

---

# Feedback Engine

Todo exercício gera feedback.

Nunca apenas:

```
Correct
```

Sempre explicar.

```
Correct

The displacement originated from this candle because...

Observe the liquidity sweep.

Observe the imbalance.
```

---

# Difficulty System

Todo conteúdo possui dificuldade.

```
Level 1

Foundations

★★★★★
```

```
Level 2

Intermediate
```

```
Level 3

Advanced
```

```
Level 4

Professional
```

---

# Progress System

O progresso é baseado em competências.

Nunca em páginas lidas.

Exemplo.

```
Candlesticks

83%
```

```
SMC

46%
```

```
Elliott

21%
```

Cada competência possui XP.

---

# XP System

Toda atividade gera experiência.

```
Read Lesson

20 XP

Exercise

40 XP

Quiz

60 XP

Perfect Score

100 XP

7 Day Streak

75 XP
```

---

# Mastery Levels

Cada curso possui quatro níveis.

```
Explorer

↓

Practitioner

↓

Professional

↓

Master
```

Cada nível desbloqueia novos exercícios.

---

# Adaptive Learning

O aplicativo registra todos os erros.

Modelo.

```
User mistakes

↓

Store

↓

Review Queue

↓

Repeat Later
```

---

# Spaced Repetition

Se um conceito foi respondido errado:

```
1 day

↓

3 days

↓

7 days

↓

14 days

↓

30 days
```

O conteúdo retorna automaticamente.

---

# Challenges

Após cada módulo.

```
10 Mixed Questions

Timer

Score

Accuracy

Average Time
```

---

# Final Assessment

Cada curso termina com uma prova prática.

Exemplo.

SMC.

```
20 charts

Find:

BOS

CHoCH

Liquidity

OB

FVG

Entry

Stop

Target
```

---

# Certification

Após aprovação.

```
SMC Practitioner

SMC Professional

SMC Master
```

---

# User Dashboard

Mostrar evolução.

```
Overall Progress

Courses

XP

Current Level

Certificates

Learning Streak
```

---

# Skill Dashboard

Mostrar competências.

```
Candlestick Recognition

92%

Market Structure

71%

Liquidity

63%

Order Blocks

94%

FVG

58%

Breaker Blocks

47%

Elliott

36%
```

---

# Learning Analytics

Registrar:

```
Average Study Time

Completion Rate

Quiz Accuracy

Exercise Accuracy

Average Response Time

Strongest Skill

Weakest Skill

Current Streak
```

---

# Daily Training

Gerado automaticamente.

```
Today's Session

1 Review

2 Lessons

5 Exercises

1 Challenge

Estimated Time

18 minutes
```

---

# UI Components

## Course Card

```
Title

Progress

Difficulty

Estimated Time

Continue
```

---

## Lesson Card

```
Icon

Title

XP

Duration

Completed
```

---

## Exercise Card

```
Chart

Instruction

Timer

Hints

Submit
```

---

## Feedback Card

```
Result

Explanation

Common Mistake

Learn More
```

---

## Progress Card

```
Course

Current Level

XP

Accuracy

Certificates
```

---

# Gamification Rules

Não utilizar elementos infantis.

Evitar:

❌ Avatares

❌ Moedas

❌ Caixas de recompensa

❌ Animações exageradas

Utilizar apenas:

✔ XP

✔ Progress

✔ Streak

✔ Certificates

✔ Levels

✔ Mastery

---

# Design Principles

Interface limpa.

Pouco texto.

Muito espaço em branco.

Gráficos grandes.

Contraste alto.

Feedback imediato.

Animações rápidas (<300 ms).

Experiência semelhante a um terminal profissional, não a um jogo.

---

# Responsibilities

## Design Agent

Responsável por:

* Design System dos componentes
* Fluxos de navegação
* Estados de Empty/Loading/Error
* Microinterações
* Responsividade
* Acessibilidade
* Protótipos de exercícios interativos
* Dashboard de progresso
* Sistema visual de níveis e certificações

---

## Code Agent

Responsável por:

* Arquitetura do Learning Engine
* Modelos de dados (Course, Module, Lesson, Exercise, Quiz, Challenge)
* Sistema de progresso e XP
* Motor de exercícios interativos (tap, drag, replay)
* Algoritmo de Spaced Repetition
* Persistência local e sincronização
* Analytics de aprendizagem
* Desbloqueio por níveis
* API para novos cursos sem alterar a lógica existente

---

## Princípio Arquitetural

O **Learning Engine** deve ser totalmente desacoplado do conteúdo. Todo curso (Candlesticks, SMC, Elliott, Wyckoff, Volume Profile ou futuros módulos) será apenas um conjunto de dados consumido pelo mesmo motor. Assim, adicionar um novo curso significa apenas cadastrar seu conteúdo e exercícios, sem modificar a lógica da aplicação. Isso garante escalabilidade e manutenção simples à medida que a plataforma evolui.
