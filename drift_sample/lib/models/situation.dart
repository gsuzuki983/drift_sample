import 'package:drift/drift.dart';

@DataClassName('Situation')
class Situations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
}
