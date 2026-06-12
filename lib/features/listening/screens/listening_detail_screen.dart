import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/config/app_config.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/listening/models/listening_content.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/primary_button.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ListeningDetailScreen extends StatefulWidget {
  const ListeningDetailScreen({required this.content, super.key});

  final ListeningContent content;

  @override
  State<ListeningDetailScreen> createState() => _ListeningDetailScreenState();
}

class _ListeningDetailScreenState extends State<ListeningDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Map<int, int> _answers = <int, int>{};
  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  late ListeningContent _content;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  bool _showVietnamese = false;
  bool _isPreparingAudio = false;
  String? _audioError;
  Map<int, ListeningResult> _results = const <int, ListeningResult>{};

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _hasSubmitted => _results.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _subscriptions.addAll([
      _player.onDurationChanged.listen((duration) {
        if (mounted) {
          setState(() => _duration = duration);
        }
      }),
      _player.onPositionChanged.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      }),
      _player.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() => _playerState = state);
        }
      }),
      _player.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() => _position = Duration.zero);
        }
      }),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final content = await AppStateScope.read(
      context,
    ).listening.loadLesson(widget.content);
    if (mounted) {
      setState(() => _content = content);
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_content.audioUrl.isEmpty) {
      setState(() => _audioError = 'Bài nghe này chưa có tệp audio.');
      return;
    }

    setState(() {
      _audioError = null;
      _isPreparingAudio = true;
    });
    try {
      if (_isPlaying) {
        await _player.pause();
      } else if (_playerState == PlayerState.paused) {
        await _player.resume();
      } else {
        final audioUrl = _absoluteMediaUrl(_content.audioUrl);
        print( 'Playing audio from URL: $audioUrl');

        await _player.setSource(UrlSource(audioUrl));
        await _player.resume();
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _audioError =
              'Không thể phát audio. Hãy kiểm tra máy chủ và tệp bài nghe.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPreparingAudio = false);
      }
    }
  }

  Future<void> _submit() async {
    final provider = AppStateScope.read(context).listening;
    final results = await provider.submit(content: _content, answers: _answers);
    if (!mounted) {
      return;
    }
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa thể chấm bài. Vui lòng thử lại.')),
      );
      return;
    }
    setState(() {
      _results = <int, ListeningResult>{
        for (final result in results) result.questionId: result,
      };
    });
    final score = results.where((result) => result.isCorrect).length;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          score == results.length
              ? Icons.emoji_events_rounded
              : Icons.fact_check_rounded,
          color: AppTheme.indigo,
          size: 44.sp,
        ),
        title: const Text('Kết quả luyện nghe'),
        content: Text(
          'Bạn trả lời đúng $score/${results.length} câu.\n'
          'Đáp án đúng được tô xanh, đáp án sai được tô đỏ.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Xem kết quả'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).listening;
    final questions = provider.questions;
    final answeredAll =
        questions.isNotEmpty && _answers.length == questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(_content.title)),
      body: AppPage(
        bottomPadding: 32.h,
        children: [
          AppPagePadding(child: _buildAudioPlayer()),
          AppSection(
            title: 'Transcript',
            action: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('日本語')),
                ButtonSegment(value: true, label: Text('Tiếng Việt')),
              ],
              selected: <bool>{_showVietnamese},
              onSelectionChanged: (selection) {
                setState(() => _showVietnamese = selection.first);
              },
            ),
            children: [
              AppPagePadding(
                child: ShadCard(
                  padding: EdgeInsets.all(18.w),
                  radius: BorderRadius.circular(18.r),
                  child: SelectableText(
                    _transcript,
                    style: TextStyle(fontSize: 16.sp, height: 1.75),
                  ),
                ),
              ),
            ],
          ),
          AppSection(
            title: 'Câu hỏi',
            action: questions.isEmpty ? null : Text('${questions.length} câu'),
            children: [
              if (provider.isLoadingDetail)
                const AppPagePadding(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (questions.isEmpty)
                const AppPagePadding(
                  child: Center(child: Text('Bài nghe chưa có câu hỏi.')),
                )
              else ...[
                ...questions.asMap().entries.map(
                  (entry) => _QuestionCard(
                    number: entry.key + 1,
                    question: entry.value,
                    selectedAnswerId: _answers[entry.value.id],
                    result: _results[entry.value.id],
                    hasSubmitted: _hasSubmitted,
                    onSelected: (answerId) {
                      setState(() => _answers[entry.value.id] = answerId);
                    },
                  ),
                ),
                AppPagePadding(
                  vertical: 18,
                  child: PrimaryButton(
                    label: _hasSubmitted ? 'Làm lại' : 'Nộp bài nghe',
                    icon: _hasSubmitted
                        ? Icons.refresh_rounded
                        : Icons.done_all_rounded,
                    isLoading: provider.isSubmitting,
                    onPressed: _hasSubmitted
                        ? () {
                            setState(() {
                              _answers.clear();
                              _results = const <int, ListeningResult>{};
                            });
                          }
                        : answeredAll
                        ? _submit
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    final maxMilliseconds = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final position = _position.inMilliseconds
        .clamp(0, maxMilliseconds.toInt())
        .toDouble();

    return ShadCard(
      padding: EdgeInsets.all(20.w),
      radius: BorderRadius.circular(22.r),
      backgroundColor: AppTheme.ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShadBadge.secondary(child: Text(_content.level)),
              SizedBox(width: 8.w),
              Text(
                _content.category,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .72),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(17.w),
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.ink,
                ),
                onPressed: _isPreparingAudio ? null : _toggleAudio,
                child: _isPreparingAudio
                    ? SizedBox.square(
                        dimension: 25.sp,
                        child: const CircularProgressIndicator(strokeWidth: 3),
                      )
                    : Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 31.sp,
                      ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  children: [
                    Slider(
                      value: position,
                      max: maxMilliseconds,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withValues(alpha: .25),
                      onChanged: _duration == Duration.zero
                          ? null
                          : (value) {
                              _player.seek(
                                Duration(milliseconds: value.round()),
                              );
                            },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position)),
                        Text(_formatDuration(_duration)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_audioError != null) ...[
            SizedBox(height: 12.h),
            Text(
              _audioError!,
              style: const TextStyle(color: Color(0xFFFCA5A5)),
            ),
          ],
        ],
      ),
    );
  }

  String get _transcript {
    final value = _showVietnamese
        ? _content.scriptVietnamese
        : _content.scriptJapanese;
    return value.isEmpty ? 'Chưa có transcript.' : value;
  }

  String _absoluteMediaUrl(String value) {
    final rawValue = value.trim().replaceAll('\\', '/');
    final base = Uri.parse(AppConfig.defaultBaseUrl);
    final uri = Uri.tryParse(rawValue);

    if (uri != null && uri.hasScheme) {
      if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
        return uri
            .replace(
              scheme: base.scheme,
              host: base.host,
              port: base.hasPort ? base.port : null,
            )
            .toString();
      }
      return uri.toString();
    }

    final normalizedPath = rawValue.startsWith('/')
        ? rawValue
        : rawValue.contains('/')
        ? '/$rawValue'
        : '/audio/content_listening/$rawValue';
    return base.replace(path: normalizedPath).toString();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.number,
    required this.question,
    required this.selectedAnswerId,
    required this.result,
    required this.hasSubmitted,
    required this.onSelected,
  });

  final int number;
  final ListeningQuestion question;
  final int? selectedAnswerId;
  final ListeningResult? result;
  final bool hasSubmitted;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppPagePadding(
      vertical: 8,
      child: ShadCard(
        padding: EdgeInsets.all(18.w),
        radius: BorderRadius.circular(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu $number. ${question.text}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
            SizedBox(height: 14.h),
            ...question.answers.map((answer) {
              final selected = answer.id == selectedAnswerId;
              final isCorrectAnswer = answer.isCorrect;
              final isSelectedWrong =
                  hasSubmitted && selected && result?.isCorrect == false;
              final showCorrect = hasSubmitted && isCorrectAnswer;
              final feedbackColor = showCorrect
                  ? AppTheme.primary
                  : isSelectedWrong
                  ? AppTheme.coral
                  : null;
              return Padding(
                padding: EdgeInsets.only(bottom: 9.h),
                child: InkWell(
                  borderRadius: BorderRadius.circular(13.r),
                  onTap: hasSubmitted ? null : () => onSelected(answer.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: EdgeInsets.all(13.w),
                    decoration: BoxDecoration(
                      color: feedbackColor != null
                          ? feedbackColor.withValues(alpha: .1)
                          : selected
                          ? AppTheme.indigo.withValues(alpha: .08)
                          : AppTheme.canvas,
                      border: Border.all(
                        color:
                            feedbackColor ??
                            (selected ? AppTheme.indigo : AppTheme.line),
                        width: feedbackColor != null || selected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          showCorrect
                              ? Icons.check_circle_rounded
                              : isSelectedWrong
                              ? Icons.cancel_rounded
                              : selected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color:
                              feedbackColor ??
                              (selected ? AppTheme.indigo : AppTheme.muted),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            answer.text,
                            style: TextStyle(
                              color: feedbackColor,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
