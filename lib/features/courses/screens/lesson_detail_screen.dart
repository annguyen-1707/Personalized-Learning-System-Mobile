import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/lesson.dart';
import 'package:personalized_learning_system_mobile/features/courses/widgets/lesson_video_player.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/screens/exercise_screen.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/flashcard_item.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/screens/flashcard_screen.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/primary_button.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _videoCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateScope.read(context).exercises.loadForLesson(widget.lesson.id);
    });
  }

  void _completeVideo() {
    if (!_videoCompleted && mounted) {
      setState(() => _videoCompleted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = AppStateScope.watch(context).exercises;
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.name)),
      body: AppPage(
        bottomPadding: 32.h,
        children: [
          AppPagePadding(
            child: LessonVideoPlayer(
              videoUrl: widget.lesson.videoUrl,
              onCompleted: _completeVideo,
            ),
          ),
          AppPagePadding(
            child: ShadCard(
              padding: EdgeInsets.all(18.w),
              radius: BorderRadius.circular(18.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lesson.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.lesson.description,
                    style: TextStyle(color: AppTheme.muted, height: 1.5),
                  ),
                  SizedBox(height: 18.h),
                  _LessonResourceSummary(lesson: widget.lesson),
                ],
              ),
            ),
          ),
          AppPagePadding(
            child: ShadCard(
              padding: EdgeInsets.all(18.w),
              radius: BorderRadius.circular(18.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _videoCompleted
                            ? Icons.check_circle_rounded
                            : Icons.lock_clock_rounded,
                        color: _videoCompleted
                            ? AppTheme.primary
                            : AppTheme.amber,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _videoCompleted
                              ? 'Bạn đã sẵn sàng làm bài tập'
                              : 'Xem xong video để mở bài tập',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  if (!_videoCompleted)
                    PrimaryButton(
                      label: 'Tôi đã xem xong video',
                      icon: Icons.check_rounded,
                      onPressed: _completeVideo,
                    )
                  else if (exerciseProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    PrimaryButton(
                      label: 'Bắt đầu làm bài',
                      icon: Icons.quiz_rounded,
                      onPressed: exerciseProvider.exercises.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ExerciseScreen(
                                    exercise: exerciseProvider.exercises.first,
                                  ),
                                ),
                              );
                            },
                    ),
                  if (_videoCompleted &&
                      !exerciseProvider.isLoading &&
                      exerciseProvider.exercises.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: const Text(
                        'Bài học này chưa có bài tập.',
                        style: TextStyle(color: AppTheme.muted),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonResourceSummary extends StatelessWidget {
  const _LessonResourceSummary({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ResourceChip(
          icon: Icons.style_rounded,
          label: '${lesson.vocabularies.length} từ vựng',
          onTap: lesson.vocabularies.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => FlashcardScreen(
                        title: 'Từ vựng',
                        cards: lesson.vocabularies
                            .map(FlashcardItem.fromVocabulary)
                            .toList(),
                      ),
                    ),
                  );
                },
        ),
        SizedBox(width: 10.w),
        _ResourceChip(
          icon: Icons.translate_rounded,
          label: '${lesson.grammars.length} ngữ pháp',
          onTap: lesson.grammars.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => FlashcardScreen(
                        title: 'Ngữ pháp',
                        cards: lesson.grammars
                            .map(FlashcardItem.fromGrammar)
                            .toList(),
                      ),
                    ),
                  );
                },
        ),
      ],
    );
  }
}

class _ResourceChip extends StatelessWidget {
  const _ResourceChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppTheme.primary.withValues(alpha: onTap == null ? .04 : .08),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 17.sp,
                  color: onTap == null ? AppTheme.muted : AppTheme.primary,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onTap == null ? AppTheme.muted : AppTheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
