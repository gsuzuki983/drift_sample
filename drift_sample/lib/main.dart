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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _todoController = TextEditingController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _todoController.dispose();
    _pageController.dispose();
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
            Expanded(
              child: StreamBuilder<List<Categorie>>(
                stream: widget.database.watchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final categories = snapshot.data!;
                  return PageView.builder(
                    controller: _pageController,
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
                                    return Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) async {
                                        await widget.database
                                            .deleteTodo(todo: todo);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${todo.content}を削除しました',
                                            ),
                                          ),
                                        );
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: CheckboxListTile(
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
                                      ),
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
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'チェックリストに追加',
                hintText: 'Todo名',
              ),
              onSubmitted: (text) async {
                final categories =
                    await widget.database.watchCategories().first;
                if (categories.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'カテゴリが存在しないため、todoは追加できません。カテゴリを新規追加してください。',
                      ),
                    ),
                  );
                  return;
                }
                final currentCategory =
                    categories[_pageController.page!.round()];
                await widget.database.addTodo(
                  content: text,
                  categoryId: currentCategory.id,
                );
                _todoController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
