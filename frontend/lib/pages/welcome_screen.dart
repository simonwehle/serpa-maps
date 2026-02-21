import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/pages/login_screen.dart';
//import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/textfield_screen.dart';
import 'package:serpa_maps/widgets/fields/url_text_fields.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFieldScreen(
      title: "Welcome to Serpa Maps",
      childBuilder: (onRegisterSubmit) =>
          UrlTextFields(persistChanges: onRegisterSubmit),
      icon: Icons.arrow_forward,
      navigationTarget: const LoginScreen(),
    );
  }
}
