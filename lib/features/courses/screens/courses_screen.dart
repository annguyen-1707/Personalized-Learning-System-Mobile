import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/courses/models/course.dart';
import 'package:personalized_learning_system_mobile/features/courses/screens/lessons_screen.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).courses;
    return AppPage(
      children: [
        AppSection(
          title: 'Khóa học công khai',
          children: [
            if (provider.isLoading && provider.courses.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.w),
                child: const Center(child: CircularProgressIndicator()),
              )
            else
              ...provider.courses.map(
                (course) => _CourseCard(
                  course: course,
                ).animate().fadeIn(duration: 350.ms).slideY(begin: .04),
              ),
          ],
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return AppPagePadding(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => LessonsScreen(course: course),
            ),
          );
        },
        child: ShadCard(
          padding: EdgeInsets.all(16.w),
          radius: BorderRadius.circular(18.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShadBadge(child: Text(course.code)),
                  const Spacer(),
                  Icon(Icons.menu_book_rounded, size: 16.sp),
                  SizedBox(width: 5.w),
                  Text('${course.lessonCount} bài'),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                course.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 6.h),
              Text(
                course.description,
                style: TextStyle(color: AppTheme.muted, height: 1.35),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: ShadProgress(
                      value: .16,
                      minHeight: 8.h,
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(Icons.chevron_right_rounded,
                    color: AppTheme.muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
