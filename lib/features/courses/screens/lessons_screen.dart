import 'package:flutter/material.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/course.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/app_page.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatefulWidget {
  final Course course;

  const LessonsScreen({required this.course, super.key});

  @override
  State<LessonsScreen> createState() {
    return _LessonsScreenState();
  }
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  void initState() {
    print("load lessons for ${widget.course.toString()}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateScope.read(context).courses.loadLessons(widget.course);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).courses;
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.name)),
      body: AppPage(
        children: [
          AppSection(
            title:
                'Bài học ${widget.course.name}',
            children: [
              if (provider.isLoading)
                AppPagePadding(vertical: 0, child: const ShadProgress())
              else
                ...provider.lessons.asMap().entries.map(
                  (entry) => AppPagePadding(
                    vertical: 7,
                    child: Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  LessonDetailScreen(lesson: entry.value),
                            ),
                          );
                        },
                        child: ShadCard(
                          padding: EdgeInsets.all(14.w),
                          radius: BorderRadius.circular(16.r),
                          child: Row(
                            children: [
                              Container(
                                width: 42.w,
                                height: 42.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: AppTheme.primary.withValues(alpha: .1),
                                ),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.value.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      entry.value.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppTheme.muted,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.play_circle_outline_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
