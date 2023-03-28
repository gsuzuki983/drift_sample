import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'todos.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().withLength(min: 1, max: 20)();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Todo>> watchEntries() {
    return (select(todos)).watch();
  }

  Future<List<Todo>> get allTodoEntries => select(todos).get();

  Future<int> addTodo({required String content}) {
    return into(todos).insert(TodosCompanion(content: Value(content)));
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
