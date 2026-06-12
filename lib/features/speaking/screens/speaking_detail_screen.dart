import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/pronunciation_result_card.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_dialogue_card.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_dialogue_navigation.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_lesson_header.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_recording_button.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_tips_card.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:record/record.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpeakingDetailScreen extends StatefulWidget {
  const SpeakingDetailScreen({required this.content, super.key});

  final SpeakingContent content;

  @override
  State<SpeakingDetailScreen> createState() => _SpeakingDetailScreenState();
}

class _SpeakingDetailScreenState extends State<SpeakingDetailScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  final FlutterTts _tts = FlutterTts();

  int _currentIndex = 0;
  int _attempts = 0;
  bool _showTranslation = false;
  bool _isRecording = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _configureTts();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppStateScope.read(
        context,
      ).speaking.loadDialogues(widget.content.id);
      if (!mounted) {
        return;
      }
      final dialogues = AppStateScope.read(context).speaking.dialogues;
      if (dialogues.isNotEmpty) {
        await _speak(dialogues.first.questionJapanese);
      }
    });
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(.4);
    await _tts.setPitch(1);
  }

  @override
  void dispose() {
    _recorder.dispose();
    _tts.stop();
    final path = _recordingPath;
    if (path != null) {
      File(path).delete().ignore();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).speaking;
    if (provider.isLoadingDetail) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.content.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (provider.dialogues.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.content.title)),
        body: Center(
          child: Text(
            provider.errorMessage ?? 'Bài luyện nói chưa có hội thoại.',
          ),
        ),
      );
    }

    final dialogue = provider.dialogues[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text(widget.content.title)),
      body: AppPage(
        bottomPadding: 32.h,
        children: [
          AppPagePadding(
            child: SizedBox(
              height: 116.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SpeakingLessonHeader(
                      content: widget.content,
                      dialogueCount: provider.dialogues.length,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SpeakingRecordingButton(
                      isRecording: _isRecording,
                      isAssessing: provider.isAssessing,
                      attempts: _attempts,
                      onPressed: () => _toggleRecording(dialogue.id),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSection(
            title: 'Hội thoại',
            action: Text('${_currentIndex + 1}/${provider.dialogues.length}'),
            children: [
              AppPagePadding(
                child: SpeakingDialogueCard(
                  dialogue: dialogue,
                  showTranslation: _showTranslation,
                  onToggleTranslation: () {
                    setState(() => _showTranslation = !_showTranslation);
                  },
                  onSpeakQuestion: () => _speak(dialogue.questionJapanese),
                  onSpeakAnswer: () => _speak(dialogue.answerJapanese),
                ),
              ),
            ],
          ),
          AppSection(
            title: 'Mẹo luyện nói',
            children: const [AppPagePadding(child: SpeakingTipsCard())],
          ),
          AppSection(
            title: 'Kết quả phát âm',
            children: [
              AppPagePadding(
                child: provider.result == null
                    ? const ShadCard(
                        child: Text(
                          'Chưa có kết quả. Hãy ghi âm để nhận phản hồi.',
                        ),
                      )
                    : PronunciationResultCard(
                        result: provider.result!,
                        answer: dialogue.answerJapanese,
                      ),
              ),
            ],
          ),
          AppPagePadding(
            child: SpeakingDialogueNavigation(
              canGoPrevious: _currentIndex > 0 && !_isRecording,
              canGoNext:
                  _currentIndex < provider.dialogues.length - 1 &&
                  !_isRecording,
              onPrevious: () => _changeDialogue(-1),
              onNext: () => _changeDialogue(1),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _toggleRecording(int dialogueId) async {
    if (_isRecording) {
      await _stopAndAssess(dialogueId);
      return;
    }
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hãy cấp quyền microphone để luyện phát âm.'),
          ),
        );
      }
      return;
    }

    await _tts.stop();
    final path =
        '${Directory.systemTemp.path}/fuohayo_${DateTime.now().millisecondsSinceEpoch}.wav';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    if (mounted) {
      setState(() {
        _recordingPath = path;
        _isRecording = true;
      });
    }
  }

  Future<void> _stopAndAssess(int dialogueId) async {
    final provider = AppStateScope.read(context).speaking;
    final path = await _recorder.stop();
    if (mounted) {
      setState(() {
        _isRecording = false;
        _attempts++;
      });
    }
    if (path == null) {
      return;
    }
    final succeeded = await provider.assess(
      dialogueId: dialogueId,
      audioPath: path,
    );
    await File(path).delete().catchError((_) => File(path));
    if (!mounted || succeeded) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Không thể chấm phát âm.'),
      ),
    );
  }

  Future<void> _changeDialogue(int offset) async {
    final provider = AppStateScope.read(context).speaking;
    final nextIndex = _currentIndex + offset;
    setState(() {
      _currentIndex = nextIndex;
      _attempts = 0;
      _recordingPath = null;
    });
    final dialogue = provider.dialogues[nextIndex];
    await provider.loadProgress(dialogue.id);
    await _speak(dialogue.questionJapanese);
  }
}
