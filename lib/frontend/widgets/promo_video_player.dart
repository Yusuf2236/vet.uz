import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'remote_image.dart';

/// Maxsus taklif videosini ijro etuvchi premium video pleyer.
class PromoVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String fallbackUrl;

  const PromoVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.fallbackUrl,
  });

  @override
  State<PromoVideoPlayer> createState() => _PromoVideoPlayerState();
}

class _PromoVideoPlayerState extends State<PromoVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(0.0); // Muted by default
      _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('PromoVideoPlayer error initializing: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return RemoteImage(
        url: widget.fallbackUrl,
        fallbackBuilder: (_) => Container(color: const Color(0xFF134E3A)),
      );
    }

    if (!_isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          RemoteImage(
            url: widget.fallbackUrl,
            fallbackBuilder: (_) => Container(color: const Color(0xFF134E3A)),
          ),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          // Play/pause overlay indicator
          AnimatedOpacity(
            opacity: _controller.value.isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          // Sound toggle button in bottom right
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.setVolume(_controller.value.volume == 0.0 ? 1.0 : 0.0);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: Icon(
                  _controller.value.volume == 0.0
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
