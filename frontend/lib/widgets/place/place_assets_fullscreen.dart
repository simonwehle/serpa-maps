import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.assets.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 15,
                child: Center(
                  child: Image.network(
                    widget.assets[index].assetUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
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
    );
  }
}
