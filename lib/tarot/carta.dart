class Carta {
  final int numero;
  final String id;
  final String arquetipo;
  final String emocao;
  final String polaridade; // "bear" ou "bull"
  final String icone;
  final int psychLoad; // mapped from psych_load
  final String vies;
  final String sabedoria;
  final List<String> sinais;
  final String antidoto;
  final String fonte;

  const Carta({
    required this.numero,
    required this.id,
    required this.arquetipo,
    required this.emocao,
    required this.polaridade,
    required this.icone,
    required this.psychLoad,
    required this.vies,
    required this.sabedoria,
    required this.sinais,
    required this.antidoto,
    required this.fonte,
  });

  bool get isBear => polaridade == 'bear';
  bool get isBull => polaridade == 'bull';

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      numero: json['numero'] as int? ?? 0,
      id: json['id'] as String? ?? '',
      arquetipo: json['arquetipo'] as String? ?? '',
      emocao: json['emocao'] as String? ?? '',
      polaridade: json['polaridade'] as String? ?? 'bear',
      icone: json['icone'] as String? ?? '',
      psychLoad: (json['psych_load'] ?? json['psychLoad']) as int? ?? 50,
      vies: json['vies'] as String? ?? '',
      sabedoria: json['sabedoria'] as String? ?? '',
      sinais: (json['sinais'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      antidoto: json['antidoto'] as String? ?? '',
      fonte: json['fonte'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'id': id,
      'arquetipo': arquetipo,
      'emocao': emocao,
      'polaridade': polaridade,
      'icone': icone,
      'psych_load': psychLoad,
      'vies': vies,
      'sabedoria': sabedoria,
      'sinais': sinais,
      'antidoto': antidoto,
      'fonte': fonte,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Carta &&
          runtimeType == other.runtimeType &&
          numero == other.numero &&
          id == other.id;

  @override
  int get hashCode => numero.hashCode ^ id.hashCode;
}

class Leitura {
  final String data; // YYYY-MM-DD
  final String cartaId;
  final int psychLoad; // valor final com variação
  final String biasStatus; // CRITICAL_TILT, UNSTABLE_OVERLOAD, CAUTION_DRIFT, STABLE_FLOW

  const Leitura({
    required this.data,
    required this.cartaId,
    required this.psychLoad,
    required this.biasStatus,
  });

  factory Leitura.fromJson(Map<String, dynamic> json) {
    return Leitura(
      data: json['data'] as String? ?? '',
      cartaId: (json['cartaId'] ?? json['carta_id']) as String? ?? '',
      psychLoad: (json['psychLoad'] ?? json['psych_load']) as int? ?? 0,
      biasStatus: (json['biasStatus'] ?? json['bias_status']) as String? ?? 'STABLE_FLOW',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'cartaId': cartaId,
      'psychLoad': psychLoad,
      'biasStatus': biasStatus,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Leitura &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          cartaId == other.cartaId &&
          psychLoad == other.psychLoad &&
          biasStatus == other.biasStatus;

  @override
  int get hashCode =>
      data.hashCode ^ cartaId.hashCode ^ psychLoad.hashCode ^ biasStatus.hashCode;
}
