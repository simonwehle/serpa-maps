import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool optional;
  final bool passwordField;
  const FormTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.optional = false,
    this.passwordField = false,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final i10n = Localizations.of(context, AppLocalizations)!;
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.optional
            ? [widget.label, i10n.optional].join(' ')
            : widget.label,
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        //filled: true,
        suffixIcon: widget.passwordField
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
      obscureText: widget.passwordField ? obscureText : false,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      //textInputAction: TextInputAction.done,
    );
  }
}
