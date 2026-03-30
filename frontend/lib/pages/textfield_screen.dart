import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldScreen extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Widget Function(ValueChanged<Future<void> Function()>) childBuilder;
  final Widget navigationTarget;
  final Widget? navigationBackTarget;

  const TextFieldScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.childBuilder,
    required this.navigationTarget,
    this.navigationBackTarget,
  });

  @override
  ConsumerState<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends ConsumerState<TextFieldScreen> {
  Future<void> Function()? _onSubmitCallback;
  bool _isLoading = false;
  String? _errorMessage;

  void _registerSubmitCallback(Future<void> Function() callback) {
    _onSubmitCallback = callback;
  }

  void _pushNavigationTarget(Widget target) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: widget.navigationBackTarget != null
            ? BackButton(
                onPressed: () =>
                    _pushNavigationTarget(widget.navigationBackTarget!),
              )
            : const SizedBox.shrink(),
      ),
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
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_onSubmitCallback == null) return;

                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });

                try {
                  await _onSubmitCallback!();

                  if (!mounted) return;

                  if (context.mounted) {
                    _pushNavigationTarget(widget.navigationTarget);
                  }
                } catch (e) {
                  if (!mounted) return;

                  setState(() {
                    _errorMessage = e.toString().replaceAll('Exception: ', '');
                    _isLoading = false;
                  });
                }
              },
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Icon(widget.icon),
      ),
    );
  }
}
