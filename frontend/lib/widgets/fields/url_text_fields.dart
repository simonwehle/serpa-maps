import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serpa_maps/providers/preferences/base_url_provider.dart';
import 'package:serpa_maps/providers/preferences/overlay_url_provider.dart';
import 'package:serpa_maps/providers/preferences/style_dark_provider.dart';
import 'package:serpa_maps/providers/preferences/style_provider.dart';

class UrlTextFields extends ConsumerStatefulWidget {
  final ValueChanged<Future<void> Function()>? persistChanges;

  const UrlTextFields({super.key, this.persistChanges});

  @override
  ConsumerState<UrlTextFields> createState() => _UrlTextFieldsState();
}

class _UrlTextFieldsState extends ConsumerState<UrlTextFields> {
  bool moreOptions = false;
  late TextEditingController serverUrlController;
  late TextEditingController mapStyleUrlController;
  late TextEditingController darkMapStyleUrlController;
  late TextEditingController overlayUrlController;

  @override
  void initState() {
    super.initState();
    serverUrlController = TextEditingController();
    mapStyleUrlController = TextEditingController();
    darkMapStyleUrlController = TextEditingController();
    overlayUrlController = TextEditingController();
  }

  @override
  void dispose() {
    serverUrlController.dispose();
    mapStyleUrlController.dispose();
    darkMapStyleUrlController.dispose();
    overlayUrlController.dispose();
    super.dispose();
  }

  void setUrlIfEmpty(TextEditingController urlController, String url) {
    if (urlController.text.isEmpty && url.isNotEmpty) {
      urlController.text = url;
    }
  }

  Future<void> _persistUrl(
    SharedPreferences prefs,
    String sharedPreferenceString,
    TextEditingController urlController,
    void Function(String url) updateUrl,
  ) async {
    var controllerText = urlController.text;
    if (controllerText.isNotEmpty) {
      await prefs.setString(sharedPreferenceString, controllerText);
      updateUrl(controllerText);
    }
  }

  Future<void> persistAllUrls() async {
    final prefs = await SharedPreferences.getInstance();

    final urlConfigs = {
      'baseUrl': (
        serverUrlController,
        ref.read(baseUrlProvider.notifier).updateBaseUrl,
      ),
      'styleUrl': (
        mapStyleUrlController,
        ref.read(styleUrlProvider.notifier).updateStyleUrl,
      ),
      'styleDarkUrl': (
        darkMapStyleUrlController,
        ref.read(styleDarkUrlProvider.notifier).updateStyleDarkUrl,
      ),
      'overlayUrl': (
        overlayUrlController,
        ref.read(overlayUrlProvider.notifier).updateOverlayUrl,
      ),
    };

    for (final entry in urlConfigs.entries) {
      await _persistUrl(prefs, entry.key, entry.value.$1, entry.value.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final serverUrl = ref.read(baseUrlProvider);
    final styleUrl = ref.read(styleUrlProvider);
    final styleDarkUrl = ref.read(styleDarkUrlProvider);
    final overlayUrl = ref.read(overlayUrlProvider);

    setUrlIfEmpty(serverUrlController, serverUrl);
    setUrlIfEmpty(mapStyleUrlController, styleUrl);
    setUrlIfEmpty(darkMapStyleUrlController, styleDarkUrl);
    setUrlIfEmpty(overlayUrlController, overlayUrl);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.persistChanges?.call(persistAllUrls);
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTextField(label: i10n.serverURL, controller: serverUrlController),
        const SizedBox(height: 8),
        if (moreOptions) ...[
          FormTextField(
            label: i10n.mapStyleURL,
            controller: mapStyleUrlController,
          ),
          const SizedBox(height: 8),
          FormTextField(
            label: i10n.darkMapStyleURL,
            controller: darkMapStyleUrlController,
          ),
          const SizedBox(height: 8),
          FormTextField(
            label: i10n.overlayURL,
            controller: overlayUrlController,
            optional: true,
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                moreOptions ? i10n.lessOptions : i10n.moreOptions,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
    );
  }
}
