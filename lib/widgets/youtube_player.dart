import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeTrailerPlayer extends StatefulWidget {
  final String videoKey;

  const YoutubeTrailerPlayer({super.key, required this.videoKey});

  @override
  State<YoutubeTrailerPlayer> createState() => _YoutubeTrailerPlayerState();
}

class _YoutubeTrailerPlayerState extends State<YoutubeTrailerPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoKey,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        interfaceLanguage: 'es',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9, 
      ),
    );
  }
}