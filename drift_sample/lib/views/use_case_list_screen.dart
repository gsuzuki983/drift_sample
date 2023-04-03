import 'package:drift_sample/services/drift_database.dart';
import 'package:flutter/material.dart';

import '../viewmodels/situation_view_model.dart';

class UseCaseListScreen extends StatefulWidget {
  const UseCaseListScreen({super.key, required this.database});
  final MyDatabase database;

  @override
  UseCaseListScreenState createState() => UseCaseListScreenState();
}

class UseCaseListScreenState extends State<UseCaseListScreen> {
  late Stream<List<SituationWithUseCases>> _situationsWithUseCases;
  late TextEditingController _useCaseController;
  late List<Situation> _situations;
  @override
  void initState() {
    super.initState();
    _situationsWithUseCases = widget.database.situationsWithUseCases;
    _addInitialData();
  }

  Future<void> _addInitialData() async {
    final situationId1 = await widget.database.addSituation(name: 'シチュエーション１');
    final situationId2 = await widget.database.addSituation(name: 'シチュエーション２');
    final situationId3 = await widget.database.addSituation(name: 'シチュエーション３');

    await widget.database
        .addUseCase(name: 'ユースケース１ー１', situationId: situationId1);
    await widget.database
        .addUseCase(name: 'ユースケース１－２', situationId: situationId1);
    await widget.database
        .addUseCase(name: 'ユースケース１ー３', situationId: situationId1);
    await widget.database
        .addUseCase(name: 'ユースケース２－１', situationId: situationId2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('シチュエーションとユースケース'),
      ),
      body: StreamBuilder<List<SituationWithUseCases>>(
        stream: _situationsWithUseCases,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final situationsWithUseCases = snapshot.data!;
            return PageView.builder(
              itemBuilder: (context, index) {
                final situationWithUseCases = situationsWithUseCases[index];
                return _buildUseCaseList(situationWithUseCases);
              },
              itemCount: situationsWithUseCases.length,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUseCaseList(SituationWithUseCases situationWithUseCases) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            situationWithUseCases.situation.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: situationWithUseCases.useCases?.length,
            itemBuilder: (context, index) {
              final useCase = situationWithUseCases.useCases![index];
              return ListTile(
                title: Text(useCase.name),
                onTap: () {
                  // TODO: Navigate to UseCaseItemListScreen
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
