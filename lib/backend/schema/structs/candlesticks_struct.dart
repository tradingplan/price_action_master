// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CandlesticksStruct extends FFFirebaseStruct {
  CandlesticksStruct({
    String? nome,
    String? icon,
    String? description,
    List<String>? overview,
    String? contexto,
    String? psicologia,
    String? confirmation,
    String? chart,
    String? pattern,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _icon = icon,
        _description = description,
        _overview = overview,
        _contexto = contexto,
        _psicologia = psicologia,
        _confirmation = confirmation,
        _chart = chart,
        _pattern = pattern,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  set icon(String? val) => _icon = val;

  bool hasIcon() => _icon != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "overview" field.
  List<String>? _overview;
  List<String> get overview => _overview ?? const [];
  set overview(List<String>? val) => _overview = val;

  void updateOverview(Function(List<String>) updateFn) {
    updateFn(_overview ??= []);
  }

  bool hasOverview() => _overview != null;

  // "contexto" field.
  String? _contexto;
  String get contexto => _contexto ?? '';
  set contexto(String? val) => _contexto = val;

  bool hasContexto() => _contexto != null;

  // "psicologia" field.
  String? _psicologia;
  String get psicologia => _psicologia ?? '';
  set psicologia(String? val) => _psicologia = val;

  bool hasPsicologia() => _psicologia != null;

  // "confirmation" field.
  String? _confirmation;
  String get confirmation => _confirmation ?? '';
  set confirmation(String? val) => _confirmation = val;

  bool hasConfirmation() => _confirmation != null;

  // "chart" field.
  String? _chart;
  String get chart => _chart ?? '';
  set chart(String? val) => _chart = val;

  bool hasChart() => _chart != null;

  // "pattern" field.
  String? _pattern;
  String get pattern => _pattern ?? '';
  set pattern(String? val) => _pattern = val;

  bool hasPattern() => _pattern != null;

  static CandlesticksStruct fromMap(Map<String, dynamic> data) =>
      CandlesticksStruct(
        nome: data['nome'] as String?,
        icon: data['icon'] as String?,
        description: data['description'] as String?,
        overview: getDataList(data['overview']),
        contexto: data['contexto'] as String?,
        psicologia: data['psicologia'] as String?,
        confirmation: data['confirmation'] as String?,
        chart: data['chart'] as String?,
        pattern: data['pattern'] as String?,
      );

  static CandlesticksStruct? maybeFromMap(dynamic data) => data is Map
      ? CandlesticksStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'icon': _icon,
        'description': _description,
        'overview': _overview,
        'contexto': _contexto,
        'psicologia': _psicologia,
        'confirmation': _confirmation,
        'chart': _chart,
        'pattern': _pattern,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'icon': serializeParam(
          _icon,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'overview': serializeParam(
          _overview,
          ParamType.String,
          isList: true,
        ),
        'contexto': serializeParam(
          _contexto,
          ParamType.String,
        ),
        'psicologia': serializeParam(
          _psicologia,
          ParamType.String,
        ),
        'confirmation': serializeParam(
          _confirmation,
          ParamType.String,
        ),
        'chart': serializeParam(
          _chart,
          ParamType.String,
        ),
        'pattern': serializeParam(
          _pattern,
          ParamType.String,
        ),
      }.withoutNulls;

  static CandlesticksStruct fromSerializableMap(Map<String, dynamic> data) =>
      CandlesticksStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        icon: deserializeParam(
          data['icon'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        overview: deserializeParam<String>(
          data['overview'],
          ParamType.String,
          true,
        ),
        contexto: deserializeParam(
          data['contexto'],
          ParamType.String,
          false,
        ),
        psicologia: deserializeParam(
          data['psicologia'],
          ParamType.String,
          false,
        ),
        confirmation: deserializeParam(
          data['confirmation'],
          ParamType.String,
          false,
        ),
        chart: deserializeParam(
          data['chart'],
          ParamType.String,
          false,
        ),
        pattern: deserializeParam(
          data['pattern'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CandlesticksStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CandlesticksStruct &&
        nome == other.nome &&
        icon == other.icon &&
        description == other.description &&
        listEquality.equals(overview, other.overview) &&
        contexto == other.contexto &&
        psicologia == other.psicologia &&
        confirmation == other.confirmation &&
        chart == other.chart &&
        pattern == other.pattern;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nome,
        icon,
        description,
        overview,
        contexto,
        psicologia,
        confirmation,
        chart,
        pattern
      ]);
}

CandlesticksStruct createCandlesticksStruct({
  String? nome,
  String? icon,
  String? description,
  String? contexto,
  String? psicologia,
  String? confirmation,
  String? chart,
  String? pattern,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CandlesticksStruct(
      nome: nome,
      icon: icon,
      description: description,
      contexto: contexto,
      psicologia: psicologia,
      confirmation: confirmation,
      chart: chart,
      pattern: pattern,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CandlesticksStruct? updateCandlesticksStruct(
  CandlesticksStruct? candlesticks, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    candlesticks
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCandlesticksStructData(
  Map<String, dynamic> firestoreData,
  CandlesticksStruct? candlesticks,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (candlesticks == null) {
    return;
  }
  if (candlesticks.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && candlesticks.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final candlesticksData =
      getCandlesticksFirestoreData(candlesticks, forFieldValue);
  final nestedData =
      candlesticksData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = candlesticks.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCandlesticksFirestoreData(
  CandlesticksStruct? candlesticks, [
  bool forFieldValue = false,
]) {
  if (candlesticks == null) {
    return {};
  }
  final firestoreData = mapToFirestore(candlesticks.toMap());

  // Add any Firestore field values
  mapToFirestore(candlesticks.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCandlesticksListFirestoreData(
  List<CandlesticksStruct>? candlestickss,
) =>
    candlestickss?.map((e) => getCandlesticksFirestoreData(e, true)).toList() ??
    [];
