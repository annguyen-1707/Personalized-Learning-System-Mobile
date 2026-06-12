import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';

class SpeakingRecordingButton extends StatelessWidget {
  const SpeakingRecordingButton({
    required this.isRecording,
    required this.isAssessing,
    required this.attempts,
    required this.onPressed,
    super.key,
  });

  final bool isRecording;
  final bool isAssessing;
  final int attempts;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        backgroundColor: isRecording ? AppTheme.coral : AppTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
      ),
      onPressed: isAssessing ? null : onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isAssessing)
            SizedBox.square(
              dimension: 28.sp,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
          else
            Icon(
              isRecording ? Icons.stop_rounded : Icons.mic_rounded,
              size: 34.sp,
            ),
          SizedBox(height: 7.h),
          Text(
            isAssessing
                ? 'Đang chấm'
                : isRecording
                ? 'Dừng ghi âm'
                : 'Bắt đầu ghi âm',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 2.h),
          Text(
            'Lần thử: $attempts',
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
        ],
      ),
    );
  }
}
