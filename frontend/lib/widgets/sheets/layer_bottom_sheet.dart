import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class LayerBottomSheet extends StatelessWidget {
  final String activeLayer;
  final ValueChanged<String> onLayerSelected;

  const LayerBottomSheet({
    super.key,
    required this.activeLayer,
    required this.onLayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SerpaBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'Vector'
                        ? Colors.lightBlue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("Vector");
                    Navigator.of(context).pop();
                  },
                  child: const Text("Vector"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'OSM'
                        ? Colors.lightBlue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("OSM");
                    Navigator.of(context).pop();
                  },
                  child: const Text("OSM"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'Satellite'
                        ? Colors.blue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("Satellite");
                    Navigator.of(context).pop();
                  },
                  child: const Text("Satellite"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
