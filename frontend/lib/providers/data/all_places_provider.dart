import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/group.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';

final allPlacesProvider =
    FutureProvider<({List<Place> places, Map<String, Group> placeIdToGroup})>((
      ref,
    ) async {
      final places = await ref.watch(placeProvider.future);
      final groupData = await ref
          .read(groupProvider.notifier)
          .fetchGroupPlacesData();
      return (
        places: [...places, ...groupData.places],
        placeIdToGroup: groupData.placeIdToGroup,
      );
    });
