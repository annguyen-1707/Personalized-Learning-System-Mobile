import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpeakingTipsCard extends StatelessWidget {
  const SpeakingTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadCard(
      child: Column(
        children: [
          SpeakingTip(text: 'Nghe và bắt chước ngữ điệu của câu mẫu.'),
          SpeakingTip(text: 'Chú ý cao độ của từng từ tiếng Nhật.'),
          SpeakingTip(text: 'Nói chậm, rõ trước rồi mới tăng tốc độ.'),
        ],
      ),
    );
  }
}

class SpeakingTip extends StatelessWidget {
  const SpeakingTip({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.replay_rounded, color: AppTheme.primary),
          SizedBox(width: 9.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
