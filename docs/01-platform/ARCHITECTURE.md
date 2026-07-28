# Architecture Specification - Learning Platform Engine

Esta documentação descreve a arquitetura do **Learning Engine** do **Price Action Master**, projetado para separar completamente o aplicativo de qualquer conteúdo educacional hardcoded.

---

## 1. Visão Geral da Arquitetura

O aplicativo funciona como um interpretador puro orientando por dados (data-driven). O fluxo de execução obedece à seguinte hierarquia:

```mermaid
graph TD
    AppBoot[App Boot] --> LoadCatalog[Load Courses via CourseRepository]
    LoadCatalog --> RenderHome[Render Dynamic Home List]
    RenderHome --> CourseDetail[Course View: Modules Timeline]
    CourseDetail --> ModuleExecution[Module View: tabbed Steps]
    ModuleExecution --> Step1[📖 LessonRenderer]
    ModuleExecution --> Step2[💡 ExampleRenderer]
    ModuleExecution --> Step3[🎯 ExerciseRenderer]
    ModuleExecution --> Step4[🧠 QuizRenderer]
    ModuleExecution --> Step5[🏆 ChallengeRenderer]
    Step5 --> CompleteModule[LocalDataManager: Save Progress & XP]
```

---

## 2. Componentes Fundamentais

### A. Repositório de Conteúdo (`CourseRepository`)
*   Responsável por descobrir e ler os arquivos JSON localizados na pasta `content/courses/` empacotados nos assets da aplicação.
*   Valida a integridade dos dados e retorna instâncias tipadas de `Course`.

### B. Renderizador de Interface (`LessonRenderer`, `QuizRenderer`, etc.)
*   Componentes reutilizáveis que leem os dados do respectivo passo (lesson, quiz, exercise) e os transformam em Widgets Flutter adequados.
*   **Decoupled Vector Canvas:** Utiliza o `GenericVectorPainter` para pintar linhas, textos, círculos e ineficiências de forma livre usando coordenadas proporcionais ([0.0, 1.0]).

### C. Gerenciador de Progresso (`LocalDataManager`)
*   Persiste o estado do usuário (módulos concluídos, XP adquirida, histórico de quizzes e emissão de certificados) no armazenamento seguro do dispositivo.
