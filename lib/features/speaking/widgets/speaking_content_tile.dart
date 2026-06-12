import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpeakingContentTile extends StatelessWidget {
  const SpeakingContentTile({
    required this.content,
    required this.onTap,
    super.key,
  });

  final SpeakingContent content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPagePadding(
      vertical: 7,
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
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: AppTheme.coral.withValues(alpha: .11),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.mic_rounded,
                    color: AppTheme.coral,
                    size: 27.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 7.h),
                      Wrap(
                        spacing: 7.w,
                        runSpacing: 5.h,
                        children: [
                          ShadBadge.outline(child: Text(content.level)),
                          ShadBadge.secondary(
                            child: Text(
                              speakingCategoryLabel(content.category),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String speakingCategoryLabel(String category) {
  return switch (category.toUpperCase()) {
    'GREETINGS' => 'Chào hỏi',
    'INVITE' => 'Mời',
    'THANKS' => 'Cảm ơn',
    'PERMISSIONS' => 'Xin phép',
    'HOSPITAL' => 'Bệnh viện',
    'RESTAURANTS' => 'Nhà hàng',
    'SHOPPING' => 'Mua sắm',
    'SORRY' => 'Xin lỗi',
    'MESSAGE' => 'Tin nhắn',
    'ADVICE' => 'Lời khuyên',
    'PRAISE' => 'Khen ngợi',
    'TRAVEL' => 'Du lịch',
    'PRESENTATION' => 'Thuyết trình',
    _ => category,
  };
}
