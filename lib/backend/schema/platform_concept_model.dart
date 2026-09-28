// Modelo de dados para a seção "Análise Técnica" (glossário de conceitos).
// Substitui o antigo ConceitosRecord/FirestoreRecord: os dados sempre vieram
// de um asset local (assets/jsons/conceitos.json); este modelo lê a mesma
// informação de content/reference/conceitos.json sem a camada de Firestore.
class PlatformConcept {
  final String id;
  final String title;
  final String icon;
  final String description;
  final String chartImage;
  final String theoryNote;

  PlatformConcept({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.chartImage,
    required this.theoryNote,
  });

  factory PlatformConcept.fromJson(Map<String, dynamic> json) {
    return PlatformConcept(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      description: json['description'] as String? ?? '',
      chartImage: json['chartImage'] as String? ?? '',
      theoryNote: json['theoryNote'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'description': description,
        'chartImage': chartImage,
        'theoryNote': theoryNote,
      };
}
