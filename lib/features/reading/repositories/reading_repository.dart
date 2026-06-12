import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';
import 'package:personalized_learning_system_mobile/features/reading/models/reading_content.dart';
import 'package:personalized_learning_system_mobile/features/reading/services/reading_service.dart';

class ReadingRepository {
  ReadingRepository(this._service);

  final ReadingService _service;

  Future<List<ReadingContent>> getContents() async {
    final response = await _service.getContents();
    return extractList(response).map(ReadingContent.fromJson).toList();
  }

  Future<ReadingContent> getContent(ReadingContent content) async {
    final results = await Future.wait<List<JsonMap>>([
      _getResourceList(() => _service.getVocabularies(content.id)),
      _getResourceList(() => _service.getGrammars(content.id)),
    ]);
    return content.copyWith(
      vocabularies: results[0].map(Vocabulary.fromJson).toList(),
      grammars: results[1].map(Grammar.fromJson).toList(),
    );
  }

  Future<List<JsonMap>> _getResourceList(
    Future<Object?> Function() request,
  ) async {
    try {
      return extractList(await request());
    } catch (_) {
      return const <JsonMap>[];
    }
  }

  Future<bool> checkCompleted({
    required int userId,
    required int contentId,
  }) async {
    if (userId <= 0 || contentId <= 0) {
      return false;
    }
    try {
      final response = await _service.checkCompleted(
        userId: userId,
        contentId: contentId,
      );
      return extractData(response) == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markCompleted({
    required int userId,
    required int contentId,
  }) async {
    if (userId <= 0 || contentId <= 0) {
      return true;
    }
    try {
      await _service.markCompleted(userId: userId, contentId: contentId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
