import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonVideoPlayer extends StatefulWidget {
  const LessonVideoPlayer({
    required this.videoUrl,
    required this.onCompleted,
    super.key,
  });

  final String videoUrl;
  final VoidCallback onCompleted;

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  YoutubePlayerController? _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayerController.convertUrlToId(
      widget.videoUrl.trim(),
    );

    debugPrint('Youtube URL: ${widget.videoUrl}');
    debugPrint('Youtube ID: $videoId');

    if (videoId == null || videoId.isEmpty) {
      return;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    _controller!.listen((value) {
      if (!_completed && value.playerState == PlayerState.ended) {
        _completed = true;
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    if (controller == null) {
      return const Center(
        child: Text('Video không hợp lệ'),
      );
    }

    return YoutubePlayer(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}