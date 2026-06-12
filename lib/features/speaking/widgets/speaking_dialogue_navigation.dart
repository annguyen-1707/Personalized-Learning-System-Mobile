import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpeakingDialogueNavigation extends StatelessWidget {
  const SpeakingDialogueNavigation({
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canGoPrevious ? onPrevious : null,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Câu trước'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: FilledButton.icon(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Câu tiếp'),
          ),
        ),
      ],
    );
  }
}
