import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/api_provider.dart';
import 'package:serpa_maps/providers/auth_token_provider.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';

class LoginFields extends ConsumerStatefulWidget {
  final ValueChanged<Future<void> Function()>? persistChanges;

  const LoginFields({super.key, this.persistChanges});

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
    final api = ref.read(apiServiceProvider);
    final loginResponse = await api.login(
      email: emailController.text,
      password: passwordController.text,
    );
    ref.read(authTokenProvider.notifier).setToken(loginResponse.token);
  }

  @override
  Widget build(BuildContext context) {
    //final i10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.persistChanges?.call(performLogin);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTextField(label: 'Email', controller: emailController),
        const SizedBox(height: 8),
        FormTextField(
          label: 'Password',
          controller: passwordController,
          passwordField: true,
        ),
        const SizedBox(height: 8),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "register",
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
