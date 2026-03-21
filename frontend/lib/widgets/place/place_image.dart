import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/providers/data/image_provider.dart';
import 'package:serpa_maps/widgets/place/place_asset_base.dart';
import 'package:serpa_maps/widgets/sheets/sheet_button.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaceImage extends ConsumerStatefulWidget {
  final Asset asset;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isEditing;
  final VoidCallback? onDelete;

  const PlaceImage({
    super.key,
    required this.asset,
    this.width = kPlaceAssetWidth,
    this.height = kPlaceAssetHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isEditing = false,
    this.onDelete,
  });

  @override
  ConsumerState<PlaceImage> createState() => _PlaceAssetState();
}

class _PlaceAssetState extends ConsumerState<PlaceImage> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDeleteButton(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Positioned(
      top: 6,
      right: 6,
      child: SheetButton(
        icon: Icons.close,
        onPressed: () async {
          final confirmed = await showDeleteConfirmationDialog(
            context,
            i10n.deleteAsset,
            i10n.deleteAssetQuestion,
          );
          if (confirmed && widget.onDelete != null) {
            widget.onDelete!();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageAsync = ref.watch(imageProvider(widget.asset.assetUrl));

    return Skeletonizer(
      enabled: imageAsync.isLoading,
      child: PlaceAssetBase(
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        borderRadius: widget.borderRadius,
        overlay: widget.isEditing ? _buildDeleteButton(context) : null,
        child: imageAsync.when(
          loading: () => SizedBox.expand(
            child: Container(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          error: (_, _) => Center(child: Icon(Icons.broken_image)),
          data: (bytes) => Image.memory(
            bytes,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          ),
        ),
      ),
    );
  }
}
