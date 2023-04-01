import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sample/models/category.dart';
import 'package:drift_sample/models/todo.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [Categories, Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Stream<List<Categorie>> watchCategories() {
    return (select(categories)).watch();
  }

  Stream<List<Todo>> watchEntriesByCategory(int categoryId) {
    return (select(todos)..where((tbl) => tbl.categoryId.equals(categoryId)))
        .watch();
  }

  Future<List<Todo>> get allTodoEntries => select(todos).get();
  Future<List<Categorie>> get allCategories => select(categories).get();
  Future<int> addCategory({required String name}) {
    return into(categories).insert(CategoriesCompanion(name: Value(name)));
  }

  Future<int> addTodo({
    required String content,
    required int categoryId,
    String? description,
  }) {
    return into(todos).insert(
      TodosCompanion(
        content: Value(content),
        categoryId: Value(categoryId),
        description: Value(description),
      ),
    );
  }

  Future<int> toggleIsChecked({required Todo todo, required bool isChecked}) {
    return (update(todos)..where((tbl) => tbl.id.equals(todo.id))).write(
      TodosCompanion(
        isChecked: Value(isChecked),
      ),
    );
  }

  Future<int> updateTodo({required Todo todo, required String content}) {
    return (update(todos)..where((tbl) => tbl.id.equals(todo.id))).write(
      TodosCompanion(
        content: Value(content),
      ),
    );
  }

  Future<void> deleteTodo({required Todo todo}) {
    return (delete(todos)..where((tbl) => tbl.id.equals(todo.id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
