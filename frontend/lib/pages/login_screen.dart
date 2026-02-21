import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/pages/map_screen.dart';
//import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/textfield_screen.dart';
import 'package:serpa_maps/widgets/fields/login_fields.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFieldScreen(
      title: "Login",
      childBuilder: (onRegisterSubmit) =>
          LoginFields(persistChanges: onRegisterSubmit),
      icon: Icons.check,
      navigationTarget: const MapScreen(),
    );
  }
}
