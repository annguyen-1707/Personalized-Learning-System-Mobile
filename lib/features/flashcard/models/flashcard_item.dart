import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';

enum FlashcardType { vocabulary, grammar }

class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.type,
    required this.level,
    required this.category,
    required this.frontTitle,
    required this.frontSubtitle,
    required this.backTitle,
    required this.backSubtitle,
  });

  final String id;
  final FlashcardType type;
  final String level;
  final String category;
  final String frontTitle;
  final String frontSubtitle;
  final String backTitle;
  final String backSubtitle;

  factory FlashcardItem.fromVocabulary(Vocabulary vocabulary) {
    return FlashcardItem(
      id: vocabulary.id,
      type: FlashcardType.vocabulary,
      level: vocabulary.level,
      category: vocabulary.partOfSpeech.isEmpty
          ? 'Từ vựng'
          : vocabulary.partOfSpeech,
      frontTitle: vocabulary.kanji,
      frontSubtitle: vocabulary.kana,
      backTitle: vocabulary.meaning,
      backSubtitle: vocabulary.example,
    );
  }

  factory FlashcardItem.fromGrammar(Grammar grammar) {
    return FlashcardItem(
      id: grammar.id.toString(),
      type: FlashcardType.grammar,
      level: grammar.level,
      category: 'Ngữ pháp',
      frontTitle: grammar.title,
      frontSubtitle: grammar.structure,
      backTitle: grammar.meaning,
      backSubtitle: grammar.example.isNotEmpty
          ? grammar.example
          : grammar.usage,
    );
  }
}
