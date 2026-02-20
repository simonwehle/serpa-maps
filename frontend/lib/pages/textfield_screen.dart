import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/pages/map_screen.dart';

class TextFieldScreen extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Widget Function(ValueChanged<Future<void> Function()>) childBuilder;

  const TextFieldScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.childBuilder,
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
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          }
        },
        child: Icon(widget.icon),
      ),
    );
  }
}
