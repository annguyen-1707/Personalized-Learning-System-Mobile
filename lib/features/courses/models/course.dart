import 'package:personalized_learning_system_mobile/core/utils/json_helpers.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.lessonCount,
    this.thumbnailUrl = '',
  });

  final int id;
  final String name;
  final String code;
  final String description;
  final int lessonCount;
  final String thumbnailUrl;

  factory Course.fromJson(JsonMap json) {
    return Course(
      id: intValue(json, const ['subjectId', 'id']),
      name: stringValue(json, const ['subjectName', 'name']),
      code: stringValue(json, const ['subjectCode', 'code'], fallback: 'N5'),
      description: stringValue(json, const ['description']),
      lessonCount: intValue(json, const ['countLessons', 'lessonCount']),
      thumbnailUrl: stringValue(json, const ['thumbnailUrl']),
    );
  }

  @override
  String toString() {
    return 'Course(id: $id, name: $name, code: $code, description: $description, lessonCount: $lessonCount, thumbnailUrl: $thumbnailUrl)';
  }


  static const samples = <Course>[
    Course(
      id: 1,
      name: 'Dữ liệu Demo',
      code: 'N5',
      description: 'Hiragana, Katakana, từ vựng nhập môn và mẫu câu cơ bản.',
      lessonCount: 24,
    ),
    Course(
      id: 2,
      name: 'JLPT N4 Conversation',
      code: 'N4',
      description: 'Ngữ pháp giao tiếp, hội thoại ngắn và đọc hiểu hằng ngày.',
      lessonCount: 30,
    ),
    Course(
      id: 3,
      name: 'JLPT N3 Intensive',
      code: 'N3',
      description: 'Tăng tốc đọc hiểu, nghe hiểu và luyện đề theo chủ điểm.',
      lessonCount: 36,
    ),
  ];
}
