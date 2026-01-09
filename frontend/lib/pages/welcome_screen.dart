import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:serpa_maps/l10n/app_localizations.dart';
//import 'package:serpa_maps/providers/base_url_provider.dart';
import 'package:serpa_maps/providers/style_dark_provider.dart';
import 'package:serpa_maps/providers/style_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool moreOptions = false;
  late TextEditingController baseUrlController;
  late TextEditingController styleUrlController;
  late TextEditingController styleDarkUrlController;
  late TextEditingController overlayUrlController;

  @override
  void initState() {
    super.initState();
    baseUrlController = TextEditingController();
    styleUrlController = TextEditingController();
    styleDarkUrlController = TextEditingController();
    overlayUrlController = TextEditingController();
  }

  @override
  void dispose() {
    baseUrlController.dispose();
    styleUrlController.dispose();
    styleDarkUrlController.dispose();
    overlayUrlController.dispose();
    super.dispose();
  }

  void setStyleUrlIfEmpty(
    TextEditingController styleUrlController,
    String styleUrl,
  ) {
    if (styleUrlController.text.isEmpty && styleUrl.isNotEmpty) {
      styleUrlController.text = styleUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final i10n = AppLocalizations.of(context)!;
    final styleUrl = ref.read(styleUrlProvider);
    final styleDarkUrl = ref.read(styleDarkUrlProvider);
    setStyleUrlIfEmpty(styleUrlController, styleUrl);
    setStyleUrlIfEmpty(styleDarkUrlController, styleDarkUrl);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Serpa Maps"),
            const SizedBox(height: 24),
            TextField(
              controller: baseUrlController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Base URL',
              ),
            ),
            const SizedBox(height: 8),
            if (moreOptions) ...[
              TextField(
                controller: styleUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Style URL',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: styleDarkUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dark Style URL',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: overlayUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Overlay URL (optional)',
                ),
              ),
              const SizedBox(height: 8),
            ],
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    moreOptions ? "less options" : "more options",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  moreOptions = !moreOptions;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Pressed"),
        child: Icon(Icons.check),
      ),
    );
  }
}
