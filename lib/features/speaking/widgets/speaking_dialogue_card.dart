import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpeakingDialogueCard extends StatelessWidget {
  const SpeakingDialogueCard({
    required this.dialogue,
    required this.showTranslation,
    required this.onToggleTranslation,
    required this.onSpeakQuestion,
    required this.onSpeakAnswer,
    super.key,
  });

  final SpeakingDialogue dialogue;
  final bool showTranslation;
  final VoidCallback onToggleTranslation;
  final VoidCallback onSpeakQuestion;
  final VoidCallback onSpeakAnswer;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.all(18.w),
      radius: BorderRadius.circular(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpeakingDialogueLine(
            label: 'Câu hỏi',
            japanese: dialogue.questionJapanese,
            vietnamese: dialogue.questionVietnamese,
            showTranslation: showTranslation,
            onSpeak: onSpeakQuestion,
          ),
          Divider(height: 30.h),
          SpeakingDialogueLine(
            label: 'Câu trả lời mẫu',
            japanese: dialogue.answerJapanese,
            vietnamese: dialogue.answerVietnamese,
            showTranslation: showTranslation,
            onSpeak: onSpeakAnswer,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onToggleTranslation,
              icon: Icon(
                showTranslation
                    ? Icons.visibility_off_rounded
                    : Icons.translate_rounded,
              ),
              label: Text(showTranslation ? 'Ẩn bản dịch' : 'Hiện bản dịch'),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeakingDialogueLine extends StatelessWidget {
  const SpeakingDialogueLine({
    required this.label,
    required this.japanese,
    required this.vietnamese,
    required this.showTranslation,
    required this.onSpeak,
    super.key,
  });

  final String label;
  final String japanese;
  final String vietnamese;
  final bool showTranslation;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 7.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                japanese.isEmpty ? 'Chưa có nội dung.' : japanese,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.55,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: japanese.isEmpty ? null : onSpeak,
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ],
        ),
        if (showTranslation) ...[
          SizedBox(height: 7.h),
          Text(
            vietnamese.isEmpty ? 'Chưa có bản dịch.' : vietnamese,
            style: const TextStyle(color: AppTheme.muted, height: 1.45),
          ),
        ],
      ],
    );
  }
}
