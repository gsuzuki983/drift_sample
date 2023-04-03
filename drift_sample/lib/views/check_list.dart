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
  late TextEditingController _useCaseController;
  late TextEditingController _inventoryItemController;
  late PageController _pageController;
  late List<UseCase> _useCases;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _useCaseController = TextEditingController();
    _inventoryItemController = TextEditingController();
    _pageController = PageController();
    _useCases = [];
    _loadUseCases();
  }

  Future<void> _loadUseCases() async {
    _useCases = await widget.database.allUseCases;
    setState(() {});
  }

  @override
  void dispose() {
    _useCaseController.dispose();
    _inventoryItemController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _useCases.isEmpty
            ? const Text('No Category')
            : Text(_useCases[_selectedCategoryIndex].name),
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
              child: _useCases.isEmpty
                  ? const Center(
                      child: Text('カテゴリがありません'),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _useCases.length,
                      itemBuilder: (context, index) {
                        final category = _useCases[index];
                        return Column(
                          children: [
                            Expanded(
                              child: StreamBuilder<List<InventoryItem>>(
                                stream: widget.database
                                    .watchEntriesByUseCase(category.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  final inventoryItems = snapshot.data!;

                                  return ListView.builder(
                                    itemCount: inventoryItems.length,
                                    itemBuilder: (context, index) {
                                      final inventoryItem =
                                          inventoryItems[index];
                                      return Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) async {
                                          await widget.database
                                              .deleteInventoryItem(
                                            inventoryItem: inventoryItem,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${inventoryItem.content}を削除しました',
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
                                          title: Text(inventoryItem.content),
                                          value: inventoryItem.isChecked,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (isChecked) async {
                                            await widget.database
                                                .toggleIsChecked(
                                              inventoryItem: inventoryItem,
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
              controller: _useCaseController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ追加',
                hintText: 'カテゴリ名',
              ),
              onSubmitted: (text) async {
                await widget.database.addSituation(name: text);
                _useCaseController.clear();
                await _loadUseCases();
              },
            ),
            TextField(
              controller: _inventoryItemController,
              decoration: const InputDecoration(
                labelText: 'チェックリストに追加',
                hintText: 'Todo名',
              ),
              onSubmitted: (text) async {
                if (_useCases.isEmpty) {
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
                    _useCases[_pageController.page!.round()];
                await widget.database.addInventoryItem(
                  content: text,
                  situationId: currentCategory.id,
                  useCaseId: 1,
                );
                _inventoryItemController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
