import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/data/user_prodiver.dart';
import 'package:serpa_maps/widgets/banner/top_banner.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';

class LoginFields extends ConsumerStatefulWidget {
  final ValueChanged<Future<void> Function()> persistChanges;
  final VoidCallback onRegisterTap;

  const LoginFields({
    super.key,
    required this.persistChanges,
    required this.onRegisterTap,
  });

  @override
  ConsumerState<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends ConsumerState<LoginFields> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> performLogin() async {
    final l10n = AppLocalizations.of(context)!;
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      throw Exception('All fields must be filled');
    }
    final user = await ref
        .read(userProvider.notifier)
        .login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
    showTopBanner(l10n.loginConfirmation(user.name));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.persistChanges.call(performLogin);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTextField(label: l10n.email, controller: emailController),
        const SizedBox(height: 8),
        FormTextField(
          label: l10n.password,
          controller: passwordController,
          passwordField: true,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.onRegisterTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                l10n.register,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
