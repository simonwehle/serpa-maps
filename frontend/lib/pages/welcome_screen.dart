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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to Serpa Maps",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: UrlTextFields(
                  persistChanges: (callback) {
                    _persistUrlsCallback = callback;
                  },
                ),
              ),
            ],
          ),
        ),
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
