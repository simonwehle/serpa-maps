import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

final placeSearchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);
