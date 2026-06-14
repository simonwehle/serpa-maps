import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/widgets/place/place_image.dart';
import 'package:serpa_maps/widgets/sheets/sheet_button.dart';

class PlaceAssetsFullscreen extends StatefulWidget {
  final List<Asset> assets;
  final int initialIndex;

  const PlaceAssetsFullscreen({
    super.key,
    required this.assets,
    required this.initialIndex,
  });

  @override
  State<PlaceAssetsFullscreen> createState() => _PlaceAssetsFullscreenState();
}

class _PlaceAssetsFullscreenState extends State<PlaceAssetsFullscreen> {
  late final PageController _pageController;
  double _dragOffset = 0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_dragOffset + details.delta.dy < 0) return;
    setState(() {
      _dragOffset += details.delta.dy;
      _opacity = (1 - _dragOffset / 300).clamp(0.0, 1.0);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset > 120 || velocity > 700) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragOffset = 0;
        _opacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: _opacity),
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Stack(
          children: [
            Opacity(
              opacity: _opacity,
              child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.assets.length,
                itemBuilder: (context, index) {
                  final size = MediaQuery.sizeOf(context);
                  return InteractiveViewer(
                    minScale: 1,
                    maxScale: 15,
                    child: Center(
                      child: PlaceImage(
                        asset: widget.assets[index],
                        width: size.width,
                        height: size.height,
                        fit: BoxFit.contain,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  );
                },
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SheetButton(
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
