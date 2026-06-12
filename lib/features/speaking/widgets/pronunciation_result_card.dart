import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PronunciationResultCard extends StatelessWidget {
  const PronunciationResultCard({
    required this.result,
    required this.answer,
    super.key,
  });

  final PronunciationResult result;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.all(18.w),
      radius: BorderRadius.circular(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PronunciationOverallScore(score: result.pronunciationScore),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.8,
            children: [
              PronunciationScoreTile(
                label: 'Chính xác',
                score: result.accuracyScore,
                icon: Icons.gps_fixed_rounded,
              ),
              PronunciationScoreTile(
                label: 'Lưu loát',
                score: result.fluencyScore,
                icon: Icons.graphic_eq_rounded,
              ),
              PronunciationScoreTile(
                label: 'Đầy đủ',
                score: result.completenessScore,
                icon: Icons.check_circle_outline_rounded,
              ),
              PronunciationScoreTile(
                label: 'Ngữ điệu',
                score: result.prosodyScore,
                icon: Icons.multiline_chart_rounded,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const Text(
            'AI nhận diện',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7.h),
          SelectableText(
            result.recognizedText.isEmpty
                ? 'Không nhận diện được nội dung.'
                : result.recognizedText,
          ),
          SizedBox(height: 16.h),
          const Text(
            'So với câu mẫu',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7.h),
          PronunciationAnswerComparison(
            answer: answer,
            recognizedText: result.recognizedText,
          ),
          SizedBox(height: 16.h),
          const Text(
            'Gợi ý cải thiện',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7.h),
          if (result.advices.isEmpty)
            const Text('Tiếp tục luyện tập để cải thiện phát âm.')
          else
            ...result.advices.map(
              (advice) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(advice)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PronunciationOverallScore extends StatelessWidget {
  const PronunciationOverallScore({required this.score, super.key});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppTheme.primary.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.record_voice_over_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 14.w),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng điểm phát âm',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 3),
                Text(
                  'Đánh giá tổng thể',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          Text(
            '${score.round()}%',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w900,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class PronunciationScoreTile extends StatelessWidget {
  const PronunciationScoreTile({
    required this.label,
    required this.score,
    required this.icon,
    super.key,
  });

  final String label;
  final double score;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.indigo.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.indigo.withValues(alpha: .16)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppTheme.indigo.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(icon, size: 19.sp, color: AppTheme.indigo),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${score.round()}%',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: AppTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PronunciationAnswerComparison extends StatelessWidget {
  const PronunciationAnswerComparison({
    required this.answer,
    required this.recognizedText,
    super.key,
  });

  final String answer;
  final String recognizedText;

  @override
  Widget build(BuildContext context) {
    final recognizedCharacters = recognizedText.replaceAll('。', '').split('');
    final matched = List<bool>.filled(recognizedCharacters.length, false);

    int findMatch(String character) {
      for (var index = 0; index < recognizedCharacters.length; index++) {
        if (!matched[index] && recognizedCharacters[index] == character) {
          return index;
        }
      }
      return -1;
    }

    final spans = answer.split('').map((character) {
      final matchIndex = findMatch(character);
      if (matchIndex >= 0) {
        matched[matchIndex] = true;
      }
      return TextSpan(
        text: character,
        style: TextStyle(
          color: matchIndex >= 0 ? Colors.green.shade700 : AppTheme.coral,
          fontWeight: FontWeight.w800,
        ),
      );
    }).toList();

    return SelectableText.rich(
      TextSpan(children: spans),
      style: TextStyle(fontSize: 19.sp, height: 1.5),
    );
  }
}
