import 'package:flutter/material.dart';
import 'package:tex_markdown/markdown_component.dart';

/// It creates a markdown widget closed to each other.
class MdWidget extends StatelessWidget {
  const MdWidget(this.exp,
      {super.key, this.style, this.onLinkTab, this.followLinkColor = false});
  final String exp;
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
    final RegExp table = RegExp(
      r"^(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)?$",
    );
    if (table.hasMatch(exp)) {
      final List<Map<int, String>> value = exp
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
      if (maxCol == 0) {
        return Text("", style: style);
      }
      return Table(
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
                      onLinkTab: onLinkTab,
                      style: style,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
    return MarkdownComponent.generate(context, exp, style, onLinkTab);
  }
}
