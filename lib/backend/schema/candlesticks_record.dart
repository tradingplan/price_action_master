import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CandlesticksRecord extends FirestoreRecord {
  CandlesticksRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  bool hasIcon() => _icon != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "overview" field.
  List<String>? _overview;
  List<String> get overview => _overview ?? const [];
  bool hasOverview() => _overview != null;

  // "contexto" field.
  String? _contexto;
  String get contexto => _contexto ?? '';
  bool hasContexto() => _contexto != null;

  // "psicologia" field.
  String? _psicologia;
  String get psicologia => _psicologia ?? '';
  bool hasPsicologia() => _psicologia != null;

  // "confirmation" field.
  String? _confirmation;
  String get confirmation => _confirmation ?? '';
  bool hasConfirmation() => _confirmation != null;

  // "chart" field.
  String? _chart;
  String get chart => _chart ?? '';
  bool hasChart() => _chart != null;

  // "pattern" field.
  String? _pattern;
  String get pattern => _pattern ?? '';
  bool hasPattern() => _pattern != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _icon = snapshotData['icon'] as String?;
    _description = snapshotData['description'] as String?;
    _overview = getDataList(snapshotData['overview']);
    _contexto = snapshotData['contexto'] as String?;
    _psicologia = snapshotData['psicologia'] as String?;
    _confirmation = snapshotData['confirmation'] as String?;
    _chart = snapshotData['chart'] as String?;
    _pattern = snapshotData['pattern'] as String?;
    _id = snapshotData['id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('candlesticks');

  static Stream<CandlesticksRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CandlesticksRecord.fromSnapshot(s));

  static Future<CandlesticksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CandlesticksRecord.fromSnapshot(s));

  static CandlesticksRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CandlesticksRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CandlesticksRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CandlesticksRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CandlesticksRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CandlesticksRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCandlesticksRecordData({
  String? nome,
  String? icon,
  String? description,
  String? contexto,
  String? psicologia,
  String? confirmation,
  String? chart,
  String? pattern,
  String? id,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'icon': icon,
      'description': description,
      'contexto': contexto,
      'psicologia': psicologia,
      'confirmation': confirmation,
      'chart': chart,
      'pattern': pattern,
      'id': id,
    }.withoutNulls,
  );

  return firestoreData;
}

class CandlesticksRecordDocumentEquality
    implements Equality<CandlesticksRecord> {
  const CandlesticksRecordDocumentEquality();

  @override
  bool equals(CandlesticksRecord? e1, CandlesticksRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nome == e2?.nome &&
        e1?.icon == e2?.icon &&
        e1?.description == e2?.description &&
        listEquality.equals(e1?.overview, e2?.overview) &&
        e1?.contexto == e2?.contexto &&
        e1?.psicologia == e2?.psicologia &&
        e1?.confirmation == e2?.confirmation &&
        e1?.chart == e2?.chart &&
        e1?.pattern == e2?.pattern &&
        e1?.id == e2?.id;
  }

  @override
  int hash(CandlesticksRecord? e) => const ListEquality().hash([
        e?.nome,
        e?.icon,
        e?.description,
        e?.overview,
        e?.contexto,
        e?.psicologia,
        e?.confirmation,
        e?.chart,
        e?.pattern,
        e?.id
      ]);

  @override
  bool isValidKey(Object? o) => o is CandlesticksRecord;
}
