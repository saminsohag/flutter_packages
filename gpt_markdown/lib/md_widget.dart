import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpt_markdown/markdown_component.dart';

/// It creates a markdown widget closed to each other.
class MdWidget extends StatelessWidget {
  const MdWidget(
    this.exp, {
    super.key,
    this.style,
    this.textDirection = TextDirection.ltr,
    this.onLinkTab,
    this.textAlign,
    this.textScaler,
    this.latexWorkaround,
    this.latexBuilder,
    this.followLinkColor = false,
    this.codeBuilder,
    this.maxLines,
  });
  final String exp;
  final TextDirection textDirection;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final void Function(String url, String title)? onLinkTab;
  final String Function(String tex)? latexWorkaround;
  final Widget Function(
          BuildContext context, String tex, TextStyle textStyle, bool inline)?
      latexBuilder;
  final bool followLinkColor;
  final Widget Function(BuildContext context, String name, String code)?
      codeBuilder;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> list = [];
    list.addAll(
      MarkdownComponent.generate(
        context,
        exp.replaceAllMapped(
            RegExp(
              r"\\\[(.*?)\\\]|(\\begin.*?\\end{.*?})",
              multiLine: true,
              dotAll: true,
            ), (match) {
          //
          String body = (match[1] ?? match[2])?.replaceAll("\n", " ") ?? "";
          return "\\[$body\\]";
        }),
        style,
        textDirection,
        onLinkTab,
        latexWorkaround,
        latexBuilder,
        codeBuilder,
      ),
    );
    return Text.rich(
      TextSpan(
        children: list,
        style: style?.copyWith(),
      ),
      textDirection: textDirection,
      textScaler: textScaler,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTableColumnWidth extends TableColumnWidth {
  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double width = 50;
    for (var each in cells) {
      each.layout(const BoxConstraints(), parentUsesSize: true);
      width = max(width, each.size.width);
    }
    return min(containerWidth, width);
  }

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    return 50;
  }
}
