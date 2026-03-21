import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:video_player/video_player.dart';

const double kPlaceVideoPreviewWidth = 200;
const double kPlaceVideoPreviewHeight = 150;

class PlaceVideoPreview extends StatefulWidget {
  final Asset asset;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  const PlaceVideoPreview({
    super.key,
    required this.asset,
    this.width = kPlaceVideoPreviewWidth,
    this.height = kPlaceVideoPreviewHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<PlaceVideoPreview> createState() => _PlaceVideoPreviewState();
}

class _PlaceVideoPreviewState extends State<PlaceVideoPreview> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant PlaceVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.assetUrl != widget.asset.assetUrl) {
      _disposeController();
      _initController();
    }
  }

  void _initController() {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.asset.assetUrl),
    );
    _controller = controller;
    _initialization = controller.initialize().then((_) {
      controller.setLooping(true);
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
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      child: Container(
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
            final videoWidth = controller.value.size.width;
            final videoHeight = controller.value.size.height;
            final rotationCorrection =
                ((controller.value.rotationCorrection % 360) + 360) % 360;
            final quarterTurns = rotationCorrection ~/ 90;

            return Stack(
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
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
