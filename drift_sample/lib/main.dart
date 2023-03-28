import 'package:drift_sample/src/drift/todos.dart';
import 'package:flutter/material.dart';

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
      home: DriftSample(database: database),
    );
  }
}

class DriftSample extends StatelessWidget {
  const DriftSample({
    super.key,
    required this.database,
  });

  final MyDatabase database;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: database.watchEntries(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                      title: Text(snapshot.data![index].content),
                      value: snapshot.data![index].isChecked,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (isChecked) async {
                        await database.toggleIsChecked(
                          todo: snapshot.data![index],
                          isChecked: isChecked!,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'チェックリストに追加',
              ),
              onSubmitted: (text) async {
                await database.addTodo(
                  content: text,
                );
                controller.clear();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        await database.addTodo(
                          content: 'test test test',
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text('remove'),
                      onPressed: () async {
                        final list = await database.allTodoEntries;
                        if (list.isNotEmpty) {
                          await database.deleteTodo(
                            todo: list[list.length - 1],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
