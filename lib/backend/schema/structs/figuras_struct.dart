// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class FigurasStruct extends FFFirebaseStruct {
  FigurasStruct({
    String? nome,
    String? icon,
    String? dsecription,
    String? chart,
    String? pattern,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _icon = icon,
        _dsecription = dsecription,
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

  // "dsecription" field.
  String? _dsecription;
  String get dsecription => _dsecription ?? '';
  set dsecription(String? val) => _dsecription = val;

  bool hasDsecription() => _dsecription != null;

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

  static FigurasStruct fromMap(Map<String, dynamic> data) => FigurasStruct(
        nome: data['nome'] as String?,
        icon: data['icon'] as String?,
        dsecription: data['dsecription'] as String?,
        chart: data['chart'] as String?,
        pattern: data['pattern'] as String?,
      );

  static FigurasStruct? maybeFromMap(dynamic data) =>
      data is Map ? FigurasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'icon': _icon,
        'dsecription': _dsecription,
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
        'dsecription': serializeParam(
          _dsecription,
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

  static FigurasStruct fromSerializableMap(Map<String, dynamic> data) =>
      FigurasStruct(
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
        dsecription: deserializeParam(
          data['dsecription'],
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
  String toString() => 'FigurasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FigurasStruct &&
        nome == other.nome &&
        icon == other.icon &&
        dsecription == other.dsecription &&
        chart == other.chart &&
        pattern == other.pattern;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([nome, icon, dsecription, chart, pattern]);
}

FigurasStruct createFigurasStruct({
  String? nome,
  String? icon,
  String? dsecription,
  String? chart,
  String? pattern,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FigurasStruct(
      nome: nome,
      icon: icon,
      dsecription: dsecription,
      chart: chart,
      pattern: pattern,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FigurasStruct? updateFigurasStruct(
  FigurasStruct? figuras, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    figuras
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFigurasStructData(
  Map<String, dynamic> firestoreData,
  FigurasStruct? figuras,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (figuras == null) {
    return;
  }
  if (figuras.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && figuras.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final figurasData = getFigurasFirestoreData(figuras, forFieldValue);
  final nestedData = figurasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = figuras.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFigurasFirestoreData(
  FigurasStruct? figuras, [
  bool forFieldValue = false,
]) {
  if (figuras == null) {
    return {};
  }
  final firestoreData = mapToFirestore(figuras.toMap());

  // Add any Firestore field values
  mapToFirestore(figuras.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFigurasListFirestoreData(
  List<FigurasStruct>? figurass,
) =>
    figurass?.map((e) => getFigurasFirestoreData(e, true)).toList() ?? [];
