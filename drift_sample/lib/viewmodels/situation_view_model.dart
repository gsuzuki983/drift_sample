import '../services/drift_database.dart';

class SituationWithUseCases {
  SituationWithUseCases({required this.situation, required this.useCases});
  final Situation situation;
  final List<UseCase>? useCases;
}
