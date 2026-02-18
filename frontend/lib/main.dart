import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/map_screen.dart';
import 'package:serpa_maps/pages/welcome_screen.dart';
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

  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer();

  final urlConfigs = {
    'baseUrl': container.read(baseUrlProvider.notifier).updateBaseUrl,
    'styleUrl': container.read(styleUrlProvider.notifier).updateStyleUrl,
    'styleDarkUrl': container
        .read(styleDarkUrlProvider.notifier)
        .updateStyleDarkUrl,
    'overlayUrl': container.read(overlayUrlProvider.notifier).updateOverlayUrl,
  };

  for (final entry in urlConfigs.entries) {
    _loadUrlString(prefs, entry.key, entry.value);
  }

  final hasBaseUrl = (prefs.getString('baseUrl') ?? '').isNotEmpty;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SerpaMaps(showWelcome: !hasBaseUrl),
    ),
  );
}

void _loadUrlString(
  SharedPreferences prefs,
  String key,
  void Function(String url) updateUrl,
) {
  final url = prefs.getString(key) ?? '';
  if (url.isNotEmpty) {
    updateUrl(url);
  }
}

class SerpaMaps extends ConsumerWidget {
  final bool showWelcome;

  const SerpaMaps({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      home: showWelcome ? const WelcomeScreen() : const MapScreen(),
    );
  }
}
