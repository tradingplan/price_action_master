import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema/util/firestore_util.dart';

import 'schema/candlesticks_record.dart';
import 'schema/figuras_record.dart';
import 'schema/conceitos_record.dart';
import 'schema/estrategias_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart' hide Order;
export 'package:firebase_core/firebase_core.dart';
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/candlesticks_record.dart';
export 'schema/figuras_record.dart';
export 'schema/conceitos_record.dart';
export 'schema/estrategias_record.dart';

/// Functions to query CandlesticksRecords (as a Stream and as a Future).
Future<int> queryCandlesticksRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CandlesticksRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CandlesticksRecord>> queryCandlesticksRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    Stream.fromFuture(queryCandlesticksRecordOnce(
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    ));

Future<List<CandlesticksRecord>> queryCandlesticksRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) async {
  try {
    final String jsonStr = await rootBundle.loadString('assets/jsons/candlesticks.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    List<CandlesticksRecord> list = jsonList.map((data) {
      final id = data['id'] as String? ?? 'mock';
      final ref = FirebaseFirestore.instance.collection('candlesticks').doc(id);
      return CandlesticksRecord.getDocumentFromData(data, ref);
    }).toList();
    if (limit > 0) {
      list = list.take(limit).toList();
    }
    return list;
  } catch (e) {
    print('Error loading offline candlesticks: $e');
    return [];
  }
}

/// Functions to query FigurasRecords (as a Stream and as a Future).
Future<int> queryFigurasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      FigurasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<FigurasRecord>> queryFigurasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    Stream.fromFuture(queryFigurasRecordOnce(
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    ));

Future<List<FigurasRecord>> queryFigurasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) async {
  try {
    final String jsonStr = await rootBundle.loadString('assets/jsons/figuras.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    List<FigurasRecord> list = jsonList.map((data) {
      final id = data['id'] as String? ?? 'mock';
      final ref = FirebaseFirestore.instance.collection('figuras').doc(id);
      return FigurasRecord.getDocumentFromData(data, ref);
    }).toList();
    if (limit > 0) {
      list = list.take(limit).toList();
    }
    return list;
  } catch (e) {
    print('Error loading offline figuras: $e');
    return [];
  }
}

/// Functions to query ConceitosRecords (as a Stream and as a Future).
Future<int> queryConceitosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ConceitosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ConceitosRecord>> queryConceitosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    Stream.fromFuture(queryConceitosRecordOnce(
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    ));

Future<List<ConceitosRecord>> queryConceitosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) async {
  try {
    final String jsonStr = await rootBundle.loadString('assets/jsons/conceitos.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    List<ConceitosRecord> list = jsonList.map((data) {
      final id = data['id'] as String? ?? 'mock';
      final ref = FirebaseFirestore.instance.collection('conceitos').doc(id);
      return ConceitosRecord.getDocumentFromData(data, ref);
    }).toList();
    if (limit > 0) {
      list = list.take(limit).toList();
    }
    return list;
  } catch (e) {
    print('Error loading offline conceitos: $e');
    return [];
  }
}

/// Functions to query EstrategiasRecords (as a Stream and as a Future).
Future<int> queryEstrategiasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      EstrategiasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<EstrategiasRecord>> queryEstrategiasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      EstrategiasRecord.collection,
      EstrategiasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<EstrategiasRecord>> queryEstrategiasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      EstrategiasRecord.collection,
      EstrategiasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
    throw err;
  }).then((value) => value.count!);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Filter filterIn(String field, List? list) => (list?.isEmpty ?? true)
    ? Filter(field, whereIn: null)
    : Filter(field, whereIn: list);

Filter filterArrayContainsAny(String field, List? list) =>
    (list?.isEmpty ?? true)
        ? Filter(field, arrayContainsAny: null)
        : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}
