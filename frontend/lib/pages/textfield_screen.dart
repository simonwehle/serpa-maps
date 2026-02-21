import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldScreen extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Widget Function(ValueChanged<Future<void> Function()>) childBuilder;
  final Widget navigationTarget;

  const TextFieldScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.childBuilder,
    required this.navigationTarget,
  });

  @override
  ConsumerState<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends ConsumerState<TextFieldScreen> {
  Future<void> Function()? _onSubmitCallback;

  void _registerSubmitCallback(Future<void> Function() callback) {
    _onSubmitCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(16),
                child: widget.childBuilder(_registerSubmitCallback),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_onSubmitCallback != null) {
            await _onSubmitCallback!();
          }

          if (!mounted) {
            return;
          } else if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => widget.navigationTarget),
            );
          }
        },
        child: Icon(widget.icon),
      ),
    );
  }
}
