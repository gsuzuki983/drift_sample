import 'package:drift_sample/services/drift_database.dart';
import 'package:flutter/material.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({
    super.key,
    required this.database,
  });

  final MyDatabase database;

  @override
  CheckListScreenState createState() => CheckListScreenState();
}

class CheckListScreenState extends State<CheckListScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _todoController;
  late PageController _pageController;
  late List<Categorie> _categories;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _todoController = TextEditingController();
    _pageController = PageController();
    _categories = [];
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = await widget.database.allCategories;
    setState(() {});
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
        title: _categories.isEmpty
            ? const Text('No Category')
            : Text(_categories[_selectedCategoryIndex].name),
        centerTitle: true,
        actions: const [
          TextButton(
            onPressed: null,
            child: Text(
              '編集',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _categories.isEmpty
                  ? const Center(
                      child: Text('カテゴリがありません'),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return Column(
                          children: [
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
                                            await widget.database
                                                .toggleIsChecked(
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
                      onPageChanged: (index) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
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
                await _loadCategories();
              },
            ),
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'チェックリストに追加',
                hintText: 'Todo名',
              ),
              onSubmitted: (text) async {
                if (_categories.isEmpty) {
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
                    _categories[_pageController.page!.round()];
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
