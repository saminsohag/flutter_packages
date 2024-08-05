import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpt_markdown/custom_widgets/markdow_config.dart';
import 'package:gpt_markdown/markdown_component.dart';

/// It creates a markdown widget closed to each other.
class MdWidget extends StatelessWidget {
  const MdWidget(
    this.exp, {
    super.key,
    required this.config,
  });
  final String exp;
  final GptMarkdownConfig config;

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
        config,
      ),
    );
    return config.getRich(
      TextSpan(
        children: list,
        style: config.style?.copyWith(),
      ),
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
