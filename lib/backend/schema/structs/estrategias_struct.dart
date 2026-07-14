// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EstrategiasStruct extends FFFirebaseStruct {
  EstrategiasStruct({
    String? nome,
    String? icon,
    List<String>? identification,
    List<String>? psicologia,
    List<String>? trade,
    String? chart,
    String? id,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _icon = icon,
        _identification = identification,
        _psicologia = psicologia,
        _trade = trade,
        _chart = chart,
        _id = id,
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

  // "identification" field.
  List<String>? _identification;
  List<String> get identification => _identification ?? const [];
  set identification(List<String>? val) => _identification = val;

  void updateIdentification(Function(List<String>) updateFn) {
    updateFn(_identification ??= []);
  }

  bool hasIdentification() => _identification != null;

  // "psicologia" field.
  List<String>? _psicologia;
  List<String> get psicologia => _psicologia ?? const [];
  set psicologia(List<String>? val) => _psicologia = val;

  void updatePsicologia(Function(List<String>) updateFn) {
    updateFn(_psicologia ??= []);
  }

  bool hasPsicologia() => _psicologia != null;

  // "trade" field.
  List<String>? _trade;
  List<String> get trade => _trade ?? const [];
  set trade(List<String>? val) => _trade = val;

  void updateTrade(Function(List<String>) updateFn) {
    updateFn(_trade ??= []);
  }

  bool hasTrade() => _trade != null;

  // "chart" field.
  String? _chart;
  String get chart => _chart ?? '';
  set chart(String? val) => _chart = val;

  bool hasChart() => _chart != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  static EstrategiasStruct fromMap(Map<String, dynamic> data) =>
      EstrategiasStruct(
        nome: data['nome'] as String?,
        icon: data['icon'] as String?,
        identification: getDataList(data['identification']),
        psicologia: getDataList(data['psicologia']),
        trade: getDataList(data['trade']),
        chart: data['chart'] as String?,
        id: data['id'] as String?,
      );

  static EstrategiasStruct? maybeFromMap(dynamic data) => data is Map
      ? EstrategiasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'icon': _icon,
        'identification': _identification,
        'psicologia': _psicologia,
        'trade': _trade,
        'chart': _chart,
        'id': _id,
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
        'identification': serializeParam(
          _identification,
          ParamType.String,
          isList: true,
        ),
        'psicologia': serializeParam(
          _psicologia,
          ParamType.String,
          isList: true,
        ),
        'trade': serializeParam(
          _trade,
          ParamType.String,
          isList: true,
        ),
        'chart': serializeParam(
          _chart,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
      }.withoutNulls;

  static EstrategiasStruct fromSerializableMap(Map<String, dynamic> data) =>
      EstrategiasStruct(
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
        identification: deserializeParam<String>(
          data['identification'],
          ParamType.String,
          true,
        ),
        psicologia: deserializeParam<String>(
          data['psicologia'],
          ParamType.String,
          true,
        ),
        trade: deserializeParam<String>(
          data['trade'],
          ParamType.String,
          true,
        ),
        chart: deserializeParam(
          data['chart'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EstrategiasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is EstrategiasStruct &&
        nome == other.nome &&
        icon == other.icon &&
        listEquality.equals(identification, other.identification) &&
        listEquality.equals(psicologia, other.psicologia) &&
        listEquality.equals(trade, other.trade) &&
        chart == other.chart &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nome, icon, identification, psicologia, trade, chart, id]);
}

EstrategiasStruct createEstrategiasStruct({
  String? nome,
  String? icon,
  String? chart,
  String? id,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EstrategiasStruct(
      nome: nome,
      icon: icon,
      chart: chart,
      id: id,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EstrategiasStruct? updateEstrategiasStruct(
  EstrategiasStruct? estrategias, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    estrategias
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEstrategiasStructData(
  Map<String, dynamic> firestoreData,
  EstrategiasStruct? estrategias,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (estrategias == null) {
    return;
  }
  if (estrategias.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && estrategias.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final estrategiasData =
      getEstrategiasFirestoreData(estrategias, forFieldValue);
  final nestedData =
      estrategiasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = estrategias.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEstrategiasFirestoreData(
  EstrategiasStruct? estrategias, [
  bool forFieldValue = false,
]) {
  if (estrategias == null) {
    return {};
  }
  final firestoreData = mapToFirestore(estrategias.toMap());

  // Add any Firestore field values
  mapToFirestore(estrategias.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEstrategiasListFirestoreData(
  List<EstrategiasStruct>? estrategiass,
) =>
    estrategiass?.map((e) => getEstrategiasFirestoreData(e, true)).toList() ??
    [];
