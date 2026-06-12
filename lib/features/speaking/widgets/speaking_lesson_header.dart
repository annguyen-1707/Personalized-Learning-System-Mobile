import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpeakingLessonHeader extends StatelessWidget {
  const SpeakingLessonHeader({
    required this.content,
    required this.dialogueCount,
    super.key,
  });

  final SpeakingContent content;
  final int dialogueCount;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.all(14.w),
      radius: BorderRadius.circular(22.r),
      backgroundColor: AppTheme.ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  content.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              ShadBadge.secondary(
                child: Text(
                  '$dialogueCount câu',
                  style: TextStyle(fontSize: 9.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
