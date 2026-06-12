import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class LearningOverview {
  const LearningOverview({
    required this.vocabularyLearned,
    required this.vocabularyTotal,
    required this.grammarLearned,
    required this.grammarTotal,
    required this.exerciseCompleted,
    required this.exerciseTotal,
  });

  final int vocabularyLearned;
  final int vocabularyTotal;
  final int grammarLearned;
  final int grammarTotal;
  final int exerciseCompleted;
  final int exerciseTotal;

  double get overallPercent {
    final total = vocabularyTotal + grammarTotal + exerciseTotal;
    if (total == 0) {
      return 0;
    }
    return (vocabularyLearned + grammarLearned + exerciseCompleted) / total;
  }

  factory LearningOverview.fromJson(JsonMap json) {
    return LearningOverview(
      vocabularyLearned: intValue(json, const ['totalVocabularyLearn']),
      vocabularyTotal: intValue(json, const ['totalVocabularyAllSubject']),
      grammarLearned: intValue(json, const ['totalGrammarLearn']),
      grammarTotal: intValue(json, const ['totalGrammarAllSubject']),
      exerciseCompleted: intValue(json, const ['exerciseCompleted']),
      exerciseTotal: intValue(json, const ['exerciseAllSubject']),
    );
  }

  static const demo = LearningOverview(
    vocabularyLearned: 126,
    vocabularyTotal: 250,
    grammarLearned: 38,
    grammarTotal: 90,
    exerciseCompleted: 17,
    exerciseTotal: 32,
  );
}
