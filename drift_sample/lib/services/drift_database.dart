import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sample/models/inventory_item.dart';
import 'package:drift_sample/models/situation.dart';
import 'package:drift_sample/models/use_case.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../viewmodels/situation_view_model.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [UseCases, InventoryItems, Situations])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Stream<List<UseCase>> watchUseCases() {
    return (select(useCases)).watch();
  }

  Stream<List<InventoryItem>> watchEntriesByUseCase(int useCaseId) {
    return (select(inventoryItems)
          ..where((tbl) => tbl.useCaseId.equals(useCaseId)))
        .watch();
  }

  Stream<List<SituationWithUseCases>> get situationsWithUseCases {
    return (select(situations)
          ..orderBy([
            (s) => OrderingTerm(expression: s.name),
          ]))
        .join([
          leftOuterJoin(useCases, useCases.id.equalsExp(situations.id)),
        ])
        .watch()
        .map((rows) {
          final resultMap = <int, SituationWithUseCases>{};

          for (final row in rows) {
            final situation = row.readTable(situations);
            final useCase = row.readTable(useCases);

            if (resultMap.containsKey(situation.id)) {
              resultMap[situation.id]?.useCases?.add(useCase);
            } else {
              resultMap[situation.id] = SituationWithUseCases(
                situation: situation,
                useCases: [useCase],
              );
            }
          }

          return resultMap.values.toList();
        });
  }

  Future<List<InventoryItem>> get allInventoryItems =>
      select(inventoryItems).get();

  Future<List<UseCase>> get allUseCases => select(useCases).get();

  Future<int> addSituation({required String name}) async {
    final id =
        await into(situations).insert(SituationsCompanion.insert(name: name));
    return id;
  }

  Future<int> addUseCase(
      {required String name, required int situationId}) async {
    final id = await into(useCases)
        .insert(UseCasesCompanion.insert(name: name, situationId: situationId));
    return id;
  }

  Future<int> addInventoryItem({
    required String content,
    required int useCaseId,
    required int situationId,
    String? description,
  }) {
    return into(inventoryItems).insert(
      InventoryItemsCompanion(
        content: Value(content),
        useCaseId: Value(useCaseId),
        situationId: Value(situationId),
        description: Value(description),
      ),
    );
  }

  Future<int> toggleIsChecked({
    required InventoryItem inventoryItem,
    required bool isChecked,
  }) {
    return (update(inventoryItems)
          ..where((tbl) => tbl.id.equals(inventoryItem.id)))
        .write(
      InventoryItemsCompanion(
        isChecked: Value(isChecked),
      ),
    );
  }

  Future<int> updateInventoryItem({
    required InventoryItem inventoryItem,
    required String content,
  }) {
    return (update(inventoryItems)
          ..where((tbl) => tbl.id.equals(inventoryItem.id)))
        .write(
      InventoryItemsCompanion(
        content: Value(content),
      ),
    );
  }

  Future<void> deleteInventoryItem({required InventoryItem inventoryItem}) {
    return (delete(inventoryItems)
          ..where((tbl) => tbl.id.equals(inventoryItem.id)))
        .go();
  }

  Future<List<Situation>> get allSituations => select(situations).get();

  Future<void> deleteSituation({required Situation situation}) {
    return (delete(situations)..where((tbl) => tbl.id.equals(situation.id)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
