import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/listening/screens/listening_list_screen.dart';
import 'package:personalized_learning_system_mobile/features/reading/screens/reading_list_screen.dart';
import 'package:personalized_learning_system_mobile/features/speaking/screens/speaking_list_screen.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        AppSection(
          title: 'Luyện kỹ năng',
          children: [
            ...[
              _PracticeTile(
                icon: Icons.headphones_rounded,
                title: 'Listening',
                subtitle: 'Nghe hội thoại, xem transcript và trả lời câu hỏi.',
                color: AppTheme.indigo,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ListeningListScreen(),
                    ),
                  );
                },
              ),
              _PracticeTile(
                icon: Icons.article_rounded,
                title: 'Reading',
                subtitle:
                    'Đọc bài theo chủ đề, lưu từ vựng và đánh dấu hoàn thành.',
                color: AppTheme.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ReadingListScreen(),
                    ),
                  );
                },
              ),
              _PracticeTile(
                icon: Icons.mic_rounded,
                title: 'Speaking',
                subtitle:
                    'Ghi âm phát âm và nhận điểm chính xác, lưu loát từ AI.',
                color: AppTheme.coral,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SpeakingListScreen(),
                    ),
                  );
                },
              ),
              // const _PracticeTile(
              //   icon: Icons.smart_toy_rounded,
              //   title: 'AI Conversation',
              //   subtitle:
              //       'Đặc quyền VIP: luyện hội thoại bằng văn bản hoặc giọng nói.',
              //   color: AppTheme.amber,
              // ),
            ].map(
              (tile) => tile
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideX(begin: .04, end: 0),
            ),
          ],
        ),
      ],
    );
  }
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPagePadding(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onTap,
          child: ShadCard(
            padding: EdgeInsets.all(16.w),
            radius: BorderRadius.circular(18.r),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(icon, color: color, size: 25.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(color: AppTheme.muted, height: 1.35),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: onTap == null ? AppTheme.line : AppTheme.ink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
