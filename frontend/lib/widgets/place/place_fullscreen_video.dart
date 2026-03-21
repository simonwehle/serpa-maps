import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:video_player/video_player.dart';

class PlaceFullscreenVideo extends StatefulWidget {
  final Asset asset;
  final double width;
  final double height;
  final BoxFit fit;
  final bool autoPlayOnLoad;
  final bool isActive;

  const PlaceFullscreenVideo({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
    required this.fit,
    required this.autoPlayOnLoad,
    required this.isActive,
  });

  @override
  State<PlaceFullscreenVideo> createState() => _PlaceFullscreenVideoState();
}

class _PlaceFullscreenVideoState extends State<PlaceFullscreenVideo> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant PlaceFullscreenVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.assetUrl != widget.asset.assetUrl) {
      _disposeController();
      _initController();
      return;
    }

    if (oldWidget.isActive != widget.isActive && !widget.isActive) {
      _controller?.pause();
    }
  }

  void _initController() {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.asset.assetUrl),
    );
    _controller = controller;
    _initialization = controller.initialize().then((_) {
      controller.setLooping(true);
      if (widget.autoPlayOnLoad && widget.isActive) {
        controller.play();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    _initialization = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Theme.of(context).colorScheme.outlineVariant,
      child: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          if (snapshot.hasError || _controller == null) {
            return const Center(child: Icon(Icons.broken_image));
          }

          final controller = _controller!;
          if (!widget.isActive && controller.value.isPlaying) {
            controller.pause();
          }

          final videoWidth = controller.value.size.width;
          final videoHeight = controller.value.size.height;
          final rotationCorrection =
              ((controller.value.rotationCorrection % 360) + 360) % 360;
          final quarterTurns = rotationCorrection ~/ 90;

          return GestureDetector(
            onTap: widget.isActive
                ? () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                    setState(() {});
                  }
                : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: widget.fit,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: videoWidth,
                    height: videoHeight,
                    child: RotatedBox(
                      quarterTurns: quarterTurns,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                if (!controller.value.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
