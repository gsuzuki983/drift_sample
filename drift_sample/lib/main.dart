import 'package:drift_sample/services/drift_database.dart';
import 'package:flutter/material.dart';

import 'views/use_case_list_screen.dart';

void main() {
  final database = MyDatabase();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.database,
  });

  final MyDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UseCaseListScreen(database: database),
    );
  }
}
