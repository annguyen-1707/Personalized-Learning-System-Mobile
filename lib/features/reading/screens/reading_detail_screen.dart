import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/config/app_config.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/flashcard_item.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/screens/flashcard_screen.dart';
import 'package:personalized_learning_system_mobile/features/reading/models/reading_content.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/primary_button.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReadingDetailScreen extends StatefulWidget {
  const ReadingDetailScreen({required this.content, super.key});

  final ReadingContent content;

  @override
  State<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  late ReadingContent _content;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  bool _showVietnamese = false;
  bool _isPreparingAudio = false;
  String? _audioError;

  bool get _isPlaying => _playerState == PlayerState.playing;

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
    final state = AppStateScope.read(context);
    final content = await state.reading.loadArticle(
      content: widget.content,
      userId: state.auth.user?.id ?? 0,
    );
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
      setState(() => _audioError = 'Bài đọc này chưa có audio đọc mẫu.');
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
        await _player.setSource(
          UrlSource(_absoluteMediaUrl(_content.audioUrl)),
        );
        await _player.resume();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _audioError = 'Không thể phát audio đọc mẫu.');
      }
    } finally {
      if (mounted) {
        setState(() => _isPreparingAudio = false);
      }
    }
  }

  Future<void> _markCompleted() async {
    final state = AppStateScope.read(context);
    final saved = await state.reading.markCompleted(
      userId: state.auth.user?.id ?? 0,
      contentId: _content.id,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'Đã đánh dấu hoàn thành bài đọc.'
              : 'Chưa thể lưu tiến độ lên máy chủ.',
        ),
      ),
    );
  }

  void _openVocabulary() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FlashcardScreen(
          title: 'Từ vựng bài đọc',
          cards: _content.vocabularies
              .map(FlashcardItem.fromVocabulary)
              .toList(),
        ),
      ),
    );
  }

  void _openGrammar() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FlashcardScreen(
          title: 'Ngữ pháp bài đọc',
          cards: _content.grammars.map(FlashcardItem.fromGrammar).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).reading;
    return Scaffold(
      appBar: AppBar(title: const Text('Bài đọc')),
      body: AppPage(
        bottomPadding: 32.h,
        children: [
          _buildCover(),
          AppPagePadding(
            vertical: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ShadBadge.secondary(
                      child: Text(_categoryLabel(_content.category)),
                    ),
                    ShadBadge.outline(child: Text(_content.level)),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  _content.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                    letterSpacing: -.5,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16.sp,
                      color: AppTheme.muted,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _formattedDate,
                      style: TextStyle(color: AppTheme.muted),
                    ),
                    SizedBox(width: 18.w),
                    Icon(
                      Icons.schedule_rounded,
                      size: 17.sp,
                      color: AppTheme.muted,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$_readingMinutes phút đọc',
                      style: TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildAudioPlayer(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(color: AppTheme.line, height: 1),
          ),
          AppPagePadding(
            vertical: 18,
            child: Row(
              children: [
                Text(
                  'Nội dung',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('日本語')),
                    ButtonSegment(value: true, label: Text('Việt')),
                  ],
                  selected: <bool>{_showVietnamese},
                  onSelectionChanged: (selection) {
                    setState(() => _showVietnamese = selection.first);
                  },
                ),
              ],
            ),
          ),
          if (provider.isLoadingDetail)
            const AppPagePadding(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            AppPagePadding(
              vertical: 0,
              child: SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _articleParagraphs
                      .map(
                        (paragraph) => Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: Text(
                            paragraph,
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 18.sp,
                              height: 1.9,
                              letterSpacing: .1,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          AppSection(
            title: 'Kiến thức liên quan',
            children: [
              AppPagePadding(
                child: Row(
                  children: [
                    Expanded(
                      child: _ResourceButton(
                        icon: Icons.style_rounded,
                        label: '${_content.vocabularies.length} từ vựng',
                        onTap: _content.vocabularies.isEmpty
                            ? null
                            : _openVocabulary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _ResourceButton(
                        icon: Icons.translate_rounded,
                        label: '${_content.grammars.length} ngữ pháp',
                        onTap: _content.grammars.isEmpty ? null : _openGrammar,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppPagePadding(
            vertical: 20,
            child: PrimaryButton(
              label: provider.isCompleted
                  ? 'Đã hoàn thành'
                  : 'Đánh dấu đã đọc xong',
              icon: provider.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.done_rounded,
              isLoading: provider.isCompleting,
              onPressed: provider.isCompleted ? null : _markCompleted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _content.imageUrl.trim().isEmpty
          ? _imagePlaceholder()
          : Image.network(
              _absoluteImageUrl(_content.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _imagePlaceholder(),
            ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppTheme.primary.withValues(alpha: .1),
      alignment: Alignment.center,
      child: Icon(
        Icons.newspaper_rounded,
        color: AppTheme.primary,
        size: 64.sp,
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
      padding: EdgeInsets.all(14.w),
      radius: BorderRadius.circular(16.r),
      backgroundColor: AppTheme.primary.withValues(alpha: .07),
      child: Row(
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(13.w),
            ),
            onPressed: _isPreparingAudio ? null : _toggleAudio,
            child: _isPreparingAudio
                ? SizedBox.square(
                    dimension: 22.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 27.sp,
                  ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nghe bài đọc',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Slider(
                  value: position,
                  max: maxMilliseconds,
                  activeColor: AppTheme.primary,
                  inactiveColor: AppTheme.line,
                  onChanged: _duration == Duration.zero
                      ? null
                      : (value) {
                          _player.seek(Duration(milliseconds: value.round()));
                        },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(color: AppTheme.muted, fontSize: 12.sp),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(color: AppTheme.muted, fontSize: 12.sp),
                    ),
                  ],
                ),
                if (_audioError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      _audioError!,
                      style: TextStyle(color: AppTheme.coral, fontSize: 12.sp),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _articleParagraphs {
    final text = _articleText.trim();
    if (text.isEmpty) {
      return const <String>['Bài đọc chưa có nội dung.'];
    }
    final explicitParagraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();
    if (explicitParagraphs.length > 1) {
      return explicitParagraphs;
    }
    return text
        .split(RegExp(r'(?<=[。！？.!?])\s+'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();
  }

  int get _readingMinutes {
    final characterCount = _content.scriptJapanese.trim().length;
    return (characterCount / 400).ceil().clamp(1, 99);
  }

  String get _formattedDate {
    final raw = _content.publishedAt.trim();
    final date = DateTime.tryParse(raw);
    if (date == null) {
      return raw.isEmpty ? 'Không rõ ngày' : raw;
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _categoryLabel(String category) {
    return switch (category.toUpperCase()) {
      'TECHNOLOGY' => 'Công nghệ',
      'SCIENCE' => 'Khoa học',
      'HEALTH' => 'Sức khỏe',
      'BUSINESS' => 'Kinh doanh',
      'ENVIRONMENT' => 'Môi trường',
      'POLITICS' => 'Chính trị',
      'SPORTS' => 'Thể thao',
      'ENTERTAINMENT' => 'Giải trí',
      'TRAVEL' => 'Du lịch',
      _ => 'Giáo dục',
    };
  }

  String _absoluteImageUrl(String value) {
    return _absoluteAssetUrl(value, '/images/content_reading/');
  }

  String _absoluteAssetUrl(String value, String defaultFolder) {
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
    final path = rawValue.startsWith('/')
        ? rawValue
        : rawValue.contains('/')
        ? '/$rawValue'
        : '$defaultFolder$rawValue';
    return base.replace(path: path).toString();
  }

  String get _articleText {
    final value = _showVietnamese
        ? _content.scriptVietnamese
        : _content.scriptJapanese;
    return value.isEmpty ? 'Bài đọc chưa có nội dung.' : value;
  }

  String _absoluteMediaUrl(String value) {
    return _absoluteAssetUrl(value, '/audio/content_reading/');
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _ResourceButton extends StatelessWidget {
  const _ResourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary.withValues(alpha: onTap == null ? .04 : .09),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          child: Column(
            children: [
              Icon(
                icon,
                color: onTap == null ? AppTheme.muted : AppTheme.primary,
              ),
              SizedBox(height: 7.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: onTap == null ? AppTheme.muted : AppTheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
