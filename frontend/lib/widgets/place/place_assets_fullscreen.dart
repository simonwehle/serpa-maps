import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';

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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.assets.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.assets[index].assetUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Close button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
