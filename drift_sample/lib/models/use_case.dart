import 'package:drift/drift.dart';

@DataClassName('UseCase')
class UseCases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
  IntColumn get situationId =>
      integer().customConstraint('REFERENCES situations(id)')();
}
