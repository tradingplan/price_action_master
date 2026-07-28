# Regras do Projeto (Workspace Rules)

Você deve sempre ler, respeitar e seguir estritamente as definições técnicas, funcionais e de design especificadas no documento de Requisitos de Produto e Especificação de UX (PRD):
- [PRD+UX Spec.md](file:///d:/projects/price_action_master/docs/PRD+UX%20Spec.md)

## Diretrizes Principais:
1. **Offline-First de Custo Zero:** Todo catálogo educativo ou utilitário deve funcionar 100% sem conexão com a internet, utilizando dados armazenados localmente em arquivos JSON.
2. **Persistência Local Dedicada:** Qualquer estado persistido do usuário (tiragem de cartas do Tarot, histórico de Quizzes, saldo virtual e histórico de ordens do simulador de trade) deve ser gravado e lido localmente pelo `LocalDataManager` através do SharedPreferences e arquivos locais, sem uso de conexões externas ou chamadas ao Firebase.
3. **Diagramas Vetoriais em Canvas:** Utilizar `CustomPainter` nativo para desenhar ilustrações e esquemas gráficos pedagógicos de alta qualidade a 60 FPS (evitando links de imagens externos que possam falhar offline).
4. **Nenhum Placeholder:** Utilizar recursos 100% reais e interativos em todas as telas desenvolvidas.
