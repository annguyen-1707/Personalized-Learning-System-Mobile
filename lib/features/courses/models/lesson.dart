import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/grammar.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/vocabulary.dart';

class Lesson {
  const Lesson({
    required this.id,
    required this.name,
    required this.description,
    this.videoUrl = '',
    this.thumbnailUrl = '',
    this.vocabularies = const <Vocabulary>[],
    this.grammars = const <Grammar>[],
  });

  final int id;
  final String name;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final List<Vocabulary> vocabularies;
  final List<Grammar> grammars;

  factory Lesson.fromJson(JsonMap json) {
    final vocabularies = json['vocabularies'];
    final grammars = json['grammars'];
    return Lesson(
      id: intValue(json, const ['lessonId', 'id']),
      name: stringValue(json, const ['name', 'title']),
      description: stringValue(json, const ['description']),
      videoUrl: stringValue(json, const ['videoUrl']),
      thumbnailUrl: stringValue(json, const ['thumbnailUrl']),
      vocabularies: vocabularies is List
          ? vocabularies
                .map((item) => Vocabulary.fromJson(asJsonMap(item)))
                .toList()
          : const <Vocabulary>[],
      grammars: grammars is List
          ? grammars.map((item) => Grammar.fromJson(asJsonMap(item))).toList()
          : const <Grammar>[],
    );
  }

  static const samples = <Lesson>[
    Lesson(
      id: 1,
      name: 'LessonDemo',
      description:
          'Luyện các mẫu câu tự giới thiệu trong lớp học và công việc.',
    ),
    Lesson(
      id: 2,
      name: 'Thời gian và lịch học',
      description: 'Cách nói ngày, giờ, tuần và đặt lịch học tiếng Nhật.',
    ),
    Lesson(
      id: 3,
      name: 'Mua sắm và gọi món',
      description: 'Từ vựng đồ vật, số đếm và hội thoại tại cửa hàng.',
    ),
  ];
}
