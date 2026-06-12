import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/stat_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

import '../../courses/screens/lessons_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.watch(context);
    final user = state.auth.user;
    final overview = state.profile.overview;
    final percent = overview.overallPercent.clamp(0.0, 1.0).toDouble();

    return AppPage(
      onRefresh: state.loadInitialData,
      children: [
        AppPagePadding(
          vertical: 10,
          child: ShadCard(
            padding: EdgeInsets.all(18.w),
            radius: BorderRadius.circular(22.r),
            backgroundColor: AppTheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'こんにちは, ${user?.fullName ?? 'Learner'}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Hoàn thành 15 phút luyện tập để giữ streak hôm nay.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .82),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ShadBadge.secondary(
                      child: Text('${(percent * 100).round()}%'),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                ShadProgress(
                  value: percent,
                  minHeight: 10.h,
                  backgroundColor: Colors.white.withValues(alpha: .2),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.school_rounded,
                      label: 'Khóa học',
                      onTap: () => state.changeTab(1),
                    ),
                    SizedBox(width: 10.w),
                    _QuickAction(
                      icon: Icons.mic_rounded,
                      label: 'Speaking',
                      onTap: () => state.changeTab(2),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 420.ms).slideY(begin: .05),
        ),
        AppPagePadding(
          vertical: 12,
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.32,
            children: [
              StatTile(
                label: 'Đã học',
                value: '${overview.vocabularyLearned} từ',
                icon: Icons.translate_rounded,
                color: AppTheme.primary,
              ),
              StatTile(
                label: 'Ngữ pháp',
                value: '${overview.grammarLearned} mẫu',
                icon: Icons.rule_rounded,
                color: AppTheme.amber,
              ),
            ],
          ),
        ),
        AppSection(
          title: 'Lộ trình gợi ý',
          action: ShadButton.ghost(
            onPressed: () => state.changeTab(1),
            child: const Text('Xem tất cả'),
          ),
          children: [
            ...state.courses.courses
                .take(3)
                .map(
                  (course) => AppPagePadding(
                    vertical: 7,
                    child: ShadCard(
                      padding: EdgeInsets.all(14.w),
                      radius: BorderRadius.circular(16.r),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => LessonsScreen(course: course),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 46.w,
                              height: 46.w,
                              decoration: BoxDecoration(
                                color: AppTheme.indigo.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                color: AppTheme.indigo,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    course.description,
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
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withValues(alpha: .16)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 19.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
