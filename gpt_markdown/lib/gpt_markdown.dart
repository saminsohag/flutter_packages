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
    this.latexWorkaround,
    this.textAlign,
    this.textScaleFactor,
    this.onLinkTab,
    this.latexBuilder,
    this.codeBuilder,
  });
  final TextDirection textDirection;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final void Function(String url, String title)? onLinkTab;
  final String Function(String tex)? latexWorkaround;
  final Widget Function(BuildContext context, String tex)? latexBuilder;
  final bool followLinkColor;
  final Widget Function(BuildContext context, String name, String code)?
      codeBuilder;

  @override
  Widget build(BuildContext context) {
    String tex = data.trim();
    if (!tex.contains(r"\(")) {
      tex = tex
          .replaceAllMapped(
              RegExp(
                r"(?<!\\)\$\$(.*?)(?<!\\)\$\$",
                dotAll: true,
              ),
              (match) => "\\[${match[1] ?? ""}\\]")
          .replaceAllMapped(
              RegExp(
                r"(?<!\\)\$(.*?)(?<!\\)\$",
              ),
              (match) => "\\(${match[1] ?? ""}\\)");
      tex = tex.splitMapJoin(
        RegExp(r"\[.*?\]|\(.*?\)"),
        onNonMatch: (p0) {
          return p0.replaceAll("\\\$", "\$");
        },
      );
    }
    return ClipRRect(
        child: MdWidget(
      tex,
      textDirection: textDirection,
      style: style,
      onLinkTab: onLinkTab,
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      followLinkColor: followLinkColor,
      latexWorkaround: latexWorkaround,
      latexBuilder: latexBuilder,
      codeBuilder: codeBuilder,
    ));
  }
}
