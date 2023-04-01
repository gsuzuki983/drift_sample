import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sample/models/inventory_item.dart';
import 'package:drift_sample/models/use_case.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [UseCases, InventoryItems])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Stream<List<UseCase>> watchUseCases() {
    return (select(useCases)).watch();
  }

  Stream<List<InventoryItem>> watchEntriesByUseCase(int categoryId) {
    return (select(inventoryItems)
          ..where((tbl) => tbl.categoryId.equals(categoryId)))
        .watch();
  }

  Future<List<InventoryItem>> get allInventoryItems =>
      select(inventoryItems).get();

  Future<List<UseCase>> get allUseCases => select(useCases).get();

  Future<int> addCategory({required String name}) {
    return into(useCases).insert(UseCasesCompanion(name: Value(name)));
  }

  Future<int> addInventoryItem({
    required String content,
    required int categoryId,
    String? description,
  }) {
    return into(inventoryItems).insert(
      InventoryItemsCompanion(
        content: Value(content),
        categoryId: Value(categoryId),
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
