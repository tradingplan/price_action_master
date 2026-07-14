import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EstrategiasRecord extends FirestoreRecord {
  EstrategiasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  bool hasIcon() => _icon != null;

  // "identification" field.
  List<String>? _identification;
  List<String> get identification => _identification ?? const [];
  bool hasIdentification() => _identification != null;

  // "psicologia" field.
  List<String>? _psicologia;
  List<String> get psicologia => _psicologia ?? const [];
  bool hasPsicologia() => _psicologia != null;

  // "trade" field.
  List<String>? _trade;
  List<String> get trade => _trade ?? const [];
  bool hasTrade() => _trade != null;

  // "chart" field.
  String? _chart;
  String get chart => _chart ?? '';
  bool hasChart() => _chart != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _icon = snapshotData['icon'] as String?;
    _identification = getDataList(snapshotData['identification']);
    _psicologia = getDataList(snapshotData['psicologia']);
    _trade = getDataList(snapshotData['trade']);
    _chart = snapshotData['chart'] as String?;
    _id = snapshotData['id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('estrategias');

  static Stream<EstrategiasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EstrategiasRecord.fromSnapshot(s));

  static Future<EstrategiasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EstrategiasRecord.fromSnapshot(s));

  static EstrategiasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EstrategiasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EstrategiasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EstrategiasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EstrategiasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EstrategiasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEstrategiasRecordData({
  String? name,
  String? icon,
  String? chart,
  String? id,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'icon': icon,
      'chart': chart,
      'id': id,
    }.withoutNulls,
  );

  return firestoreData;
}

class EstrategiasRecordDocumentEquality implements Equality<EstrategiasRecord> {
  const EstrategiasRecordDocumentEquality();

  @override
  bool equals(EstrategiasRecord? e1, EstrategiasRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.icon == e2?.icon &&
        listEquality.equals(e1?.identification, e2?.identification) &&
        listEquality.equals(e1?.psicologia, e2?.psicologia) &&
        listEquality.equals(e1?.trade, e2?.trade) &&
        e1?.chart == e2?.chart &&
        e1?.id == e2?.id;
  }

  @override
  int hash(EstrategiasRecord? e) => const ListEquality().hash([
        e?.name,
        e?.icon,
        e?.identification,
        e?.psicologia,
        e?.trade,
        e?.chart,
        e?.id
      ]);

  @override
  bool isValidKey(Object? o) => o is EstrategiasRecord;
}
