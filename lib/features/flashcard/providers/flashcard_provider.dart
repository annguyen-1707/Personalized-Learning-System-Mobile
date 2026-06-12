import 'package:flutter/foundation.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/repositories/flashcard_repository.dart';

class FlashcardProvider extends ChangeNotifier {
  FlashcardProvider(this._repository);

  final FlashcardRepository _repository;

  List<Vocabulary> words = const <Vocabulary>[];
  List<Grammar> grammars = const <Grammar>[];
  int currentFlashcardIndex = 0;
  bool showMeaning = false;
  bool isLoading = false;

  Vocabulary? get currentWord {
    if (words.isEmpty) {
      return null;
    }
    return words[currentFlashcardIndex % words.length];
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final results = await Future.wait([
      _repository.getVocabularies(),
      _repository.getGrammars(),
    ]);
    words = results[0] as List<Vocabulary>;
    grammars = results[1] as List<Grammar>;
    isLoading = false;
    notifyListeners();
  }

  void flipCard() {
    showMeaning = !showMeaning;
    notifyListeners();
  }

  void nextCard() {
    if (words.isEmpty) {
      return;
    }
    currentFlashcardIndex = (currentFlashcardIndex + 1) % words.length;
    showMeaning = false;
    notifyListeners();
  }

  void previousCard() {
    if (words.isEmpty) {
      return;
    }
    currentFlashcardIndex = (currentFlashcardIndex - 1) % words.length;
    showMeaning = false;
    notifyListeners();
  }
}
