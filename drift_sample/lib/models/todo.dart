import 'package:drift/drift.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().withLength(min: 1, max: 10)();
  TextColumn get description => text().nullable().withLength(min: 1, max: 20)();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  IntColumn get categoryId =>
      integer().customConstraint('REFERENCES categories(id)')();
}
