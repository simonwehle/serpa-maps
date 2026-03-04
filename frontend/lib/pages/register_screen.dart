import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/pages/login_screen.dart';
import 'package:serpa_maps/pages/map_screen.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/textfield_screen.dart';
import 'package:serpa_maps/widgets/fields/register_fields.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = AppLocalizations.of(context)!;

    return TextFieldScreen(
      title: i10n.register,
      childBuilder: (onRegisterSubmit) => RegisterFields(
        persistChanges: onRegisterSubmit,
        onRegisterTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      ),
      icon: Icons.check,
      navigationTarget: const MapScreen(),
    );
  }
}
