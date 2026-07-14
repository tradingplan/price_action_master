import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FigurasRecord extends FirestoreRecord {
  FigurasRecord._(
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
    _chart = snapshotData['chart'] as String?;
    _pattern = snapshotData['pattern'] as String?;
    _id = snapshotData['id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('figuras');

  static Stream<FigurasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FigurasRecord.fromSnapshot(s));

  static Future<FigurasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FigurasRecord.fromSnapshot(s));

  static FigurasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FigurasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FigurasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FigurasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FigurasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FigurasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFigurasRecordData({
  String? nome,
  String? icon,
  String? description,
  String? chart,
  String? pattern,
  String? id,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'icon': icon,
      'description': description,
      'chart': chart,
      'pattern': pattern,
      'id': id,
    }.withoutNulls,
  );

  return firestoreData;
}

class FigurasRecordDocumentEquality implements Equality<FigurasRecord> {
  const FigurasRecordDocumentEquality();

  @override
  bool equals(FigurasRecord? e1, FigurasRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.icon == e2?.icon &&
        e1?.description == e2?.description &&
        e1?.chart == e2?.chart &&
        e1?.pattern == e2?.pattern &&
        e1?.id == e2?.id;
  }

  @override
  int hash(FigurasRecord? e) => const ListEquality()
      .hash([e?.nome, e?.icon, e?.description, e?.chart, e?.pattern, e?.id]);

  @override
  bool isValidKey(Object? o) => o is FigurasRecord;
}
