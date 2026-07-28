# Migration Checklist - decopled Educational Courses

Este documento serve como a checklist passo a passo operacional para rastrear a migração de cada disciplina de Price Action para a nova plataforma.

---

## 1. Mapeamento Geral do Engine
- [ ] Congelar especificações dos schemas JSON (`Fase 2`).
- [ ] Implementar decodificador e modelos Dart para suporte aos novos schemas (`Fase 3`).
- [ ] Implementar `GenericVectorPainter` suportando primitivos geométricos dinâmicos (`Fase 3`).
- [ ] Criar views genéricas de renderizadores (Lição, Exemplos, Exercícios, Quiz, Desafio) (`Fase 3`).
- [ ] Configurar o `CourseRepository` para carregar dados dinamicamente de `content/courses/` (`Fase 3`).

---

## 2. Onda 1: Curso Piloto - Velas Japonesas (Candlesticks)
- [ ] Criar arquivo de dados oficial `content/courses/candlesticks.json`.
- [ ] Validar conformidade de `candlesticks.json` com `course.schema.json`.
- [ ] Migrar ilustrações de Martelo e Engolfo de alta para primitivos gráficos JSON.
- [ ] Habilitar renderização em ambiente de testes e validar interatividade.
- [ ] Desativar atalho antigo.

---

## 3. Onda 2: Figuras Gráficas
- [ ] Criar arquivo de dados oficial `content/courses/figuras.json`.
- [ ] Validar conformidade com `course.schema.json`.
- [ ] Converter ilustrações de topo duplo/OCO/OCOI em primitivos gráficos.
- [ ] Habilitar e validar em ambiente de staging.

---

## 4. Onda 3: Smart Money Concepts (SMC)
- [ ] Criar arquivo de dados oficial `content/courses/smc.json`.
- [ ] Validar conformidade com `course.schema.json`.
- [ ] Migrar estruturas BOS, CHoCH, Order Block e FVG para coordenadas em JSON.
- [ ] Habilitar e validar.

---

## 5. Onda 4: Ondas de Elliott
- [ ] Criar arquivo de dados oficial `content/courses/elliott.json`.
- [ ] Validar conformidade com `course.schema.json`.
- [ ] Mapear as ondas impulsivas (1-5), corretivas (A-B-C) e regras para coordenadas de retas dinâmicas.
- [ ] Habilitar e validar.

---

## 6. Descomissionamento e Limpeza (Congelamento Final)
- [ ] Validar que nenhum componente legadizado é importado.
- [ ] Deletar arquivos obsoletos de páginas do Flutter.
- [ ] Deletar JSONs legados da pasta `assets/jsons/`.
- [ ] Executar `flutter analyze` e garantir compilação limpa.
