import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/exercises-course/models/exercise.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/primary_button.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({required this.exercise, super.key});

  final Exercise exercise;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final Map<int, int> _answers = <int, int>{};
  late final Stopwatch _stopwatch;
  Timer? _timer;
  int _questionIndex = 0;

  ExerciseQuestion get _question => widget.exercise.questions[_questionIndex];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _submit() async {
    final state = AppStateScope.read(context);
    final score = widget.exercise.questions.where((question) {
      final selectedId = _answers[question.id];
      return question.answers.any(
        (answer) => answer.id == selectedId && answer.isCorrect,
      );
    }).length;

    final saved = await state.exercises.submit(
      userId: state.auth.user?.id ?? 0,
      exercise: widget.exercise,
      totalTime: _stopwatch.elapsed.inSeconds,
      answers: _answers,
    );
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          score == widget.exercise.questions.length
              ? Icons.emoji_events_rounded
              : Icons.check_circle_rounded,
          color: AppTheme.primary,
          size: 44.sp,
        ),
        title: const Text('Hoàn thành bài tập'),
        content: Text(
          'Bạn trả lời đúng $score/${widget.exercise.questions.length} câu.'
          '${saved ? '' : '\nKết quả chưa được đồng bộ lên máy chủ.'}',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Quay lại bài học'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).exercises;
    final questionCount = widget.exercise.questions.length;
    final isLastQuestion = _questionIndex == questionCount - 1;
    final selectedAnswerId = _answers[_question.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: Center(
              child: Text(
                _formatDuration(_stopwatch.elapsed),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Câu ${_questionIndex + 1}/$questionCount',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ShadProgress(
                      value: (_questionIndex + 1) / questionCount,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                _question.text,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _question.answers.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final answer = _question.answers[index];
                    final isSelected = selectedAnswerId == answer.id;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () {
                        setState(() => _answers[_question.id] = answer.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withValues(alpha: .09)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.line,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.muted,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                answer.text,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: isLastQuestion ? 'Nộp bài' : 'Câu tiếp theo',
                icon: isLastQuestion
                    ? Icons.done_all_rounded
                    : Icons.arrow_forward_rounded,
                isLoading: provider.isSubmitting,
                onPressed: selectedAnswerId == null
                    ? null
                    : isLastQuestion
                    ? _submit
                    : () => setState(() => _questionIndex++),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
