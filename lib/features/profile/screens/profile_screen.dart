import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/profile/widgets/profile_avatar.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/stat_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.watch(context);
    final user = state.auth.user;
    final overview = state.profile.overview;
    return AppPage(
      children: [
        AppPagePadding(
          vertical: 12,
          child: ShadCard(
            padding: EdgeInsets.all(18.w),
            radius: BorderRadius.circular(18.r),
            child: Row(
              children: [
                ProfileAvatar(
                  avatarUrl: user?.avatar,
                  fullName: user?.fullName ?? 'F',
                  size: Size.square(64.w),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'Learner',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(color: AppTheme.muted),
                      ),
                      SizedBox(height: 8.h),
                      ShadBadge(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user?.isVip == true
                                  ? Icons.workspace_premium_rounded
                                  : Icons.person_rounded,
                              size: 15.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(user?.membershipLevel ?? 'NORMAL'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSection(
          title: 'Tổng quan học tập',
          children: [
            AppPagePadding(
              vertical: 0,
              child: ShadProgress(
                value: overview.overallPercent.clamp(0.0, 1.0).toDouble(),
                minHeight: 10.h,
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            AppPagePadding(
              vertical: 14,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.32,
                children: [
                  StatTile(
                    label: 'Từ vựng',
                    value:
                        '${overview.vocabularyLearned}/${overview.vocabularyTotal}',
                    icon: Icons.translate_rounded,
                    color: AppTheme.primary,
                  ),
                  StatTile(
                    label: 'Ngữ pháp',
                    value:
                        '${overview.grammarLearned}/${overview.grammarTotal}',
                    icon: Icons.rule_rounded,
                    color: AppTheme.amber,
                  ),
                  StatTile(
                    label: 'Bài tập',
                    value:
                        '${overview.exerciseCompleted}/${overview.exerciseTotal}',
                    icon: Icons.quiz_rounded,
                    color: AppTheme.indigo,
                  ),
                  const StatTile(
                    label: 'Streak',
                    value: '7 ngày',
                    icon: Icons.local_fire_department_rounded,
                    color: AppTheme.coral,
                  ),
                ],
              ),
            ),
          ],
        ),
        AppPagePadding(
          vertical: 0,
          child: ShadButton.outline(
            width: double.infinity,
            height: 50.h,
            onPressed: state.auth.logout,
            leading: const Icon(Icons.logout_rounded),
            child: const Text('Đăng xuất'),
          ),
        ),
      ],
    );
  }
}
