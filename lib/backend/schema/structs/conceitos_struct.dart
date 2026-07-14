// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ConceitosStruct extends FFFirebaseStruct {
  ConceitosStruct({
    String? nome,
    String? icon,
    String? description,
    String? chart,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _icon = icon,
        _description = description,
        _chart = chart,
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

  // "chart" field.
  String? _chart;
  String get chart => _chart ?? '';
  set chart(String? val) => _chart = val;

  bool hasChart() => _chart != null;

  static ConceitosStruct fromMap(Map<String, dynamic> data) => ConceitosStruct(
        nome: data['nome'] as String?,
        icon: data['icon'] as String?,
        description: data['description'] as String?,
        chart: data['chart'] as String?,
      );

  static ConceitosStruct? maybeFromMap(dynamic data) => data is Map
      ? ConceitosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'icon': _icon,
        'description': _description,
        'chart': _chart,
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
        'chart': serializeParam(
          _chart,
          ParamType.String,
        ),
      }.withoutNulls;

  static ConceitosStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConceitosStruct(
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
        chart: deserializeParam(
          data['chart'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ConceitosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ConceitosStruct &&
        nome == other.nome &&
        icon == other.icon &&
        description == other.description &&
        chart == other.chart;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([nome, icon, description, chart]);
}

ConceitosStruct createConceitosStruct({
  String? nome,
  String? icon,
  String? description,
  String? chart,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ConceitosStruct(
      nome: nome,
      icon: icon,
      description: description,
      chart: chart,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ConceitosStruct? updateConceitosStruct(
  ConceitosStruct? conceitos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    conceitos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addConceitosStructData(
  Map<String, dynamic> firestoreData,
  ConceitosStruct? conceitos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (conceitos == null) {
    return;
  }
  if (conceitos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && conceitos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final conceitosData = getConceitosFirestoreData(conceitos, forFieldValue);
  final nestedData = conceitosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = conceitos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getConceitosFirestoreData(
  ConceitosStruct? conceitos, [
  bool forFieldValue = false,
]) {
  if (conceitos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(conceitos.toMap());

  // Add any Firestore field values
  mapToFirestore(conceitos.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getConceitosListFirestoreData(
  List<ConceitosStruct>? conceitoss,
) =>
    conceitoss?.map((e) => getConceitosFirestoreData(e, true)).toList() ?? [];
