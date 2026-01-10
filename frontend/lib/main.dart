import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/map_screen.dart';
import 'package:serpa_maps/providers/base_url_provider.dart';
import 'package:serpa_maps/providers/overlay_url_provider.dart';
import 'package:serpa_maps/providers/style_dark_provider.dart';
import 'package:serpa_maps/providers/style_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  runApp(const ProviderScope(child: SerpaMaps()));
}

class SerpaMaps extends ConsumerWidget {
  const SerpaMaps({super.key});

  Future<void> _loadUrlString(
    String sharedPreferenceString,
    void Function(String url) updateUrl,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String url = prefs.getString(sharedPreferenceString) ?? "";
    if (url.isNotEmpty) {
      updateUrl(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _loadUrlString('baseUrl', ref.read(baseUrlProvider.notifier).updateBaseUrl);
    _loadUrlString(
      'styleUrl',
      ref.read(styleUrlProvider.notifier).updateStyleUrl,
    );
    _loadUrlString(
      'styleDarkUrl',
      ref.read(styleDarkUrlProvider.notifier).updateStyleDarkUrl,
    );
    _loadUrlString(
      'overlayUrl',
      ref.read(overlayUrlProvider.notifier).updateOverlayUrl,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serpa Maps',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        dividerColor: Colors.grey[400],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          surface: Colors.white,
          outlineVariant: Colors.grey[200],
          shadow: Colors.black26,
        ),
      ),
      darkTheme: ThemeData(
        dividerColor: Colors.grey[600],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          surface: Colors.black,
          outlineVariant: Colors.grey[800],
          shadow: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MapScreen(),
    );
  }
}
