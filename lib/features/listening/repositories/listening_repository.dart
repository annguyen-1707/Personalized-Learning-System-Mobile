import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/listening/models/listening_content.dart';
import 'package:personalized_learning_system_mobile/features/listening/services/listening_service.dart';

class ListeningRepository {
  ListeningRepository(this._service);

  final ListeningService _service;

  Future<List<ListeningContent>> getContents() async {
    try {
      final response = await _service.getContents();
      final contents = extractList(
        response,
      ).map(ListeningContent.fromJson).toList();
      return contents.isEmpty ? ListeningContent.samples : contents;
    } catch (_) {
      return ListeningContent.samples;
    }
  }

  Future<ListeningContent> getContent(ListeningContent content) async {
    try {
      final response = await _service.getContent(content.id);
      final data = asJsonMap(extractData(response));
      return data.isEmpty ? content : ListeningContent.fromJson(data);
    } catch (_) {
      return content;
    }
  }

  Future<List<ListeningQuestion>> getQuestions(int contentId) async {
    try {
      final response = await _service.getQuestions(contentId);
      final questions = extractList(response)
          .map(ListeningQuestion.fromJson)
          .where((question) => question.answers.isNotEmpty)
          .toList();
      return questions.isEmpty ? ListeningQuestion.samples : questions;
    } catch (_) {
      return ListeningQuestion.samples;
    }
  }

  Future<List<ListeningResult>> submitAnswers({
    required int contentId,
    required List<ListeningQuestion> questions,
    required Map<int, int> selectedAnswers,
  }) async {
    final payload = questions.map((question) {
      final selectedId = selectedAnswers[question.id];
      final selected = question.answers
          .where((answer) => answer.id == selectedId)
          .firstOrNull;
      return <String, Object?>{
        'questionId': question.id,
        'answerText': selected?.text ?? '',
      };
    }).toList();

    try {
      final response = await _service.submitAnswers(
        contentId: contentId,
        answers: payload,
      );
      return extractList(response).map(ListeningResult.fromJson).toList();
    } catch (_) {
      return questions.map((question) {
        final selectedId = selectedAnswers[question.id];
        final selected = question.answers
            .where((answer) => answer.id == selectedId)
            .firstOrNull;
        return ListeningResult(
          questionId: question.id,
          answerText: selected?.text ?? '',
          isCorrect: selected?.isCorrect ?? false,
        );
      }).toList();
    }
  }
}
