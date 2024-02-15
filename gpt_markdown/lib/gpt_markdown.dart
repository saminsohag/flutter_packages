library tex_markdown;

import 'package:flutter/material.dart';

import 'md_widget.dart';

/// This widget create a full markdown widget as a column view.
class TexMarkdown extends StatelessWidget {
  const TexMarkdown(
    this.data, {
    super.key,
    this.style,
    this.followLinkColor = false,
    this.textDirection = TextDirection.ltr,
    this.textAlign,
    this.textScaler,
    this.onLinkTab,
  });
  final TextDirection textDirection;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final void Function(String url, String title)? onLinkTab;
  final bool followLinkColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: MdWidget(
      data.trim(),
      textDirection: textDirection,
      style: style,
      onLinkTab: onLinkTab,
      textAlign: textAlign,
      textScaler: textScaler,
      followLinkColor: followLinkColor,
    ));
  }
}
