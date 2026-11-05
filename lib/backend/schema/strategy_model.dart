class StrategyModel {
  final String id;
  final String nome;
  final String categoria;
  final String descricaoCurta;
  final List<String> mercados;
  final List<String> tags;
  final bool isPro;
  final List<String> checklist;
  final String content;

  const StrategyModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricaoCurta,
    required this.mercados,
    required this.tags,
    required this.isPro,
    required this.checklist,
    required this.content,
  });

  factory StrategyModel.fromJson(Map<String, dynamic> json) {
    return StrategyModel(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      categoria: json['categoria'] as String? ?? 'Price Action',
      descricaoCurta: json['descricaoCurta'] as String? ?? '',
      mercados: (json['mercados'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isPro: json['isPro'] as bool? ?? false,
      checklist: (json['checklist'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'descricaoCurta': descricaoCurta,
      'mercados': mercados,
      'tags': tags,
      'isPro': isPro,
      'checklist': checklist,
      'content': content,
    };
  }
}

