library tex_markdown;

import 'package:flutter/material.dart';
import 'package:gpt_markdown/custom_widgets/markdow_config.dart';
import 'package:gpt_markdown/markdown_component.dart';

import 'md_widget.dart';

export 'package:gpt_markdown/markdown_component.dart';

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
    this.textScaler,
    this.onLinkTab,
    this.latexBuilder,
    this.codeBuilder,
    this.sourceTagBuilder,
    this.maxLines,
    this.overflow,
    this.customComponents = const [],
  });
  final TextDirection textDirection;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final void Function(String url, String title)? onLinkTab;
  final String Function(String tex)? latexWorkaround;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget Function(
          BuildContext context, String tex, TextStyle style, bool inline)?
      latexBuilder;
  final bool followLinkColor;
  final Widget Function(BuildContext context, String name, String code)?
      codeBuilder;
  final Widget Function(BuildContext, String, TextStyle)? sourceTagBuilder;
  final List<MarkdownComponent> customComponents;

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
      config: GptMarkdownConfig(
        textDirection: textDirection,
        style: style,
        onLinkTab: onLinkTab,
        textAlign: textAlign,
        textScaler: textScaler,
        followLinkColor: followLinkColor,
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
        maxLines: maxLines,
        overflow: overflow,
        sourceTagBuilder: sourceTagBuilder,
        customComponents: customComponents,
      ),
    ));
  }
}
