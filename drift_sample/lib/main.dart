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

class DriftSample extends StatefulWidget {
  const DriftSample({
    super.key,
    required this.database,
  });

  final MyDatabase database;

  @override
  _DriftSampleState createState() => _DriftSampleState();
}

class _DriftSampleState extends State<DriftSample> {
  late TextEditingController _categoryController;
  late TextEditingController _todoController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _todoController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ追加',
                hintText: 'カテゴリ名',
              ),
              onSubmitted: (text) async {
                await widget.database.addCategory(name: text);
                _categoryController.clear();
              },
            ),
            Expanded(
              child: StreamBuilder<List<Categorie>>(
                stream: widget.database.watchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final categories = snapshot.data!;
                  return PageView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Column(
                        children: [
                          Text(category.name),
                          Expanded(
                            child: StreamBuilder<List<Todo>>(
                              stream: widget.database
                                  .watchEntriesByCategory(category.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                final todos = snapshot.data!;
                                return ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder: (context, index) {
                                    final todo = todos[index];
                                    return CheckboxListTile(
                                      title: Text(todo.content),
                                      value: todo.isChecked,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (isChecked) async {
                                        await widget.database.toggleIsChecked(
                                          todo: todo,
                                          isChecked: isChecked!,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'チェックリストに追加',
                hintText: 'Todo名',
              ),
              onSubmitted: (text) async {
                // カテゴリIDを適切に指定してください
                await widget.database.addTodo(
                  content: text,
                  categoryId: 1, // 仮のカテゴリID
                );
                _todoController.clear();
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
                        // カテゴリIDを適切に指定してください
                        await widget.database.addTodo(
                          content: 'test test test',
                          categoryId: 1, // 仮のカテゴリID
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text('Remove'),
                      onPressed: () async {
                        final list = await widget.database.allTodoEntries;
                        if (list.isNotEmpty) {
                          await widget.database.deleteTodo(
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
