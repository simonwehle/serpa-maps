import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/map_screen.dart';
import 'package:serpa_maps/widgets/url/url_text_fields.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  Future<void> Function()? _persistUrlsCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UrlTextFields(
        persistChanges: (callback) {
          _persistUrlsCallback = callback;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_persistUrlsCallback != null) {
            await _persistUrlsCallback!();
          }

          if (!mounted) {
            return;
          } else if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
