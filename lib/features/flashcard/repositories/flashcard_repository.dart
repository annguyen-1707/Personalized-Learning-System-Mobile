import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/services/flashcard_service.dart';

class FlashcardRepository {
  FlashcardRepository(this._service);

  final FlashcardService _service;

  Future<List<Vocabulary>> getVocabularies() async {
    try {
      final response = await _service.getVocabularies();
      final words = extractList(response).map(Vocabulary.fromJson).toList();
      return words.isEmpty ? Vocabulary.samples : words;
    } catch (_) {
      return Vocabulary.samples;
    }
  }

  Future<List<Grammar>> getGrammars() async {
    try {
      final response = await _service.getGrammars();
      final grammars = extractList(response).map(Grammar.fromJson).toList();
      return grammars.isEmpty ? Grammar.samples : grammars;
    } catch (_) {
      return Grammar.samples;
    }
  }
}
