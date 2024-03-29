import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tex_markdown/markdown_component.dart';

/// It creates a markdown widget closed to each other.
class MdWidget extends StatelessWidget {
  const MdWidget(this.exp,
      {super.key,
      this.style,
      this.textDirection = TextDirection.ltr,
      this.onLinkTab,
      this.followLinkColor = false});
  final String exp;
  final TextDirection textDirection;
  final TextStyle? style;
  final void Function(String url, String title)? onLinkTab;
  final bool followLinkColor;

  /// To convert markdown text to html text.
  static String toHtml(String text) {
    final RegExp table = RegExp(
      r"^(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)?$",
    );
    if (table.hasMatch(text)) {
      final String value = text.trim().splitMapJoin(
            RegExp(r'^\||\|\n\||\|$'),
            onMatch: (p0) => "\n",
            onNonMatch: (p0) {
              if (p0.trim().isEmpty) {
                return "";
              }
              // return p0;
              return '<tr>${p0.trim().splitMapJoin(
                '|',
                onMatch: (p0) {
                  return "";
                },
                onNonMatch: (p0) {
                  return '<td>$p0</td>';
                },
              )}</tr>';
            },
          );
      return '''
<table border="1"  cellspacing="0">
$value
</table>
''';
    }
    return MarkdownComponent.toHtml(text);
  }

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> list = [];
    exp.trim().splitMapJoin(
      RegExp(r"\n\n+"),
      onMatch: (p0) {
        list.add(
          TextSpan(
            text: "\n\n",
            style: TextStyle(
              fontSize: 6,
              color: style?.color,
            ),
          ),
        );
        return "";
      },
      onNonMatch: (eachLn) {
        final RegExp table = RegExp(
          r"^(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)$",
        );
        if (table.hasMatch(eachLn.trim())) {
          final List<Map<int, String>> value = eachLn
              .trim()
              .split('\n')
              .map<Map<int, String>>(
                (e) => e
                    .split('|')
                    .where((element) => element.isNotEmpty)
                    .toList()
                    .asMap(),
              )
              .toList();
          int maxCol = 0;
          for (final each in value) {
            if (maxCol < each.keys.length) {
              maxCol = each.keys.length;
            }
          }
          list.addAll(
            [
              TextSpan(
                text: "\n ",
                style: TextStyle(height: 0, fontSize: 0, color: style?.color),
              ),
              WidgetSpan(
                child: Table(
                  textDirection: textDirection,
                  defaultColumnWidth: CustomTableColumnWidth(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: value
                      .map<TableRow>(
                        (e) => TableRow(
                          children: List.generate(
                            maxCol,
                            (index) => Center(
                              child: MdWidget(
                                (e[index] ?? "").trim(),
                                textDirection: textDirection,
                                onLinkTab: onLinkTab,
                                style: style,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              TextSpan(
                text: "\n ",
                style: TextStyle(height: 0, fontSize: 0, color: style?.color),
              ),
            ],
          );
        } else {
          list.addAll(
            MarkdownComponent.generate(
              context,
              eachLn.trim(),
              style,
              textDirection,
              onLinkTab,
            ),
          );
        }
        return "";
      },
    );
    return Text.rich(
      TextSpan(
        children: list,
        style: style,
      ),
      textDirection: textDirection,
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
