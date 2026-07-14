import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConceitosRecord extends FirestoreRecord {
  ConceitosRecord._(
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

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "teoria_dow" field.
  String? _teoriaDow;
  String get teoriaDow => _teoriaDow ?? '';
  bool hasTeoriaDow() => _teoriaDow != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _icon = snapshotData['icon'] as String?;
    _description = snapshotData['description'] as String?;
    _chart = snapshotData['chart'] as String?;
    _id = snapshotData['id'] as String?;
    _teoriaDow = snapshotData['teoria_dow'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('conceitos');

  static Stream<ConceitosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConceitosRecord.fromSnapshot(s));

  static Future<ConceitosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConceitosRecord.fromSnapshot(s));

  static ConceitosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConceitosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConceitosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConceitosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConceitosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConceitosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConceitosRecordData({
  String? nome,
  String? icon,
  String? description,
  String? chart,
  String? id,
  String? teoriaDow,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'icon': icon,
      'description': description,
      'chart': chart,
      'id': id,
      'teoria_dow': teoriaDow,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConceitosRecordDocumentEquality implements Equality<ConceitosRecord> {
  const ConceitosRecordDocumentEquality();

  @override
  bool equals(ConceitosRecord? e1, ConceitosRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.icon == e2?.icon &&
        e1?.description == e2?.description &&
        e1?.chart == e2?.chart &&
        e1?.id == e2?.id &&
        e1?.teoriaDow == e2?.teoriaDow;
  }

  @override
  int hash(ConceitosRecord? e) => const ListEquality()
      .hash([e?.nome, e?.icon, e?.description, e?.chart, e?.id, e?.teoriaDow]);

  @override
  bool isValidKey(Object? o) => o is ConceitosRecord;
}
