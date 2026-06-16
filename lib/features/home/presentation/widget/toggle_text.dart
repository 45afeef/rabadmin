import 'package:flutter/material.dart';

class ToggleText extends StatefulWidget {
  const ToggleText({
    super.key,
    required this.texts,
    this.initialIndex = 0,
    this.style,
    this.onChanged,
  }) : assert(texts.length > 1, 'Provide at least 2 texts');

  /// List of texts to toggle between
  final List<String> texts;

  /// Starting index
  final int initialIndex;

  /// Optional text style
  final TextStyle? style;

  /// Callback when toggled
  final ValueChanged<int>? onChanged;

  @override
  State<ToggleText> createState() => _ToggleTextState();
}

class _ToggleTextState extends State<ToggleText> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.texts.length - 1);
  }

  void _toggle() {
    setState(() {
      _index = (_index + 1) % widget.texts.length;
    });

    widget.onChanged?.call(_index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          widget.texts[_index],
          key: ValueKey(_index),
          style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
