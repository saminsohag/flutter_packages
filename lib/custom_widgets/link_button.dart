import 'package:flutter/material.dart';

import 'markdow_config.dart';

class LinkButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final String? url;
  final GptMarkdownConfig config;

  const LinkButton(
      {super.key,
      required this.text,
      required this.config,
      this.onPressed,
      this.textStyle,
      this.url});

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    var style = (widget.config.style ?? const TextStyle()).copyWith(
      color: _isHovering ? Colors.red : Colors.blue,
      decoration: TextDecoration.underline,
      decorationColor: _isHovering ? Colors.red : Colors.blue,
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: (_) => _handlePress(true),
        onTapUp: (_) => _handlePress(false),
        onTapCancel: () => _handlePress(false),
        onTap: widget.onPressed,
        child: widget.config.getRich(
          TextSpan(
            text: widget.text,
            style: style,
          ),
        ),
      ),
    );
  }

  void _handleHover(bool hover) {
    setState(() {
      _isHovering = hover;
    });
  }

  void _handlePress(bool pressed) {
    setState(() {});
  }
}
