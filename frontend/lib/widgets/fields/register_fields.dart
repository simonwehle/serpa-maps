import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/api_provider.dart';
import 'package:serpa_maps/providers/auth_token_provider.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';

class RegisterFields extends ConsumerStatefulWidget {
  final ValueChanged<Future<void> Function()>? persistChanges;

  const RegisterFields({super.key, this.persistChanges});

  @override
  ConsumerState<RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends ConsumerState<RegisterFields> {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> performLogin() async {
    final api = ref.read(apiServiceProvider);
    final registerResponse = await api.register(
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
    );
    ref.read(authTokenProvider.notifier).setToken(registerResponse.token);
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.persistChanges?.call(performLogin);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTextField(label: i10n.email, controller: emailController),
        const SizedBox(height: 8),
        FormTextField(label: i10n.username, controller: usernameController),
        const SizedBox(height: 8),
        FormTextField(
          label: i10n.password,
          controller: passwordController,
          passwordField: true,
        ),
        const SizedBox(height: 8),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                i10n.login,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
