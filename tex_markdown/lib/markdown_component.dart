import 'package:flutter/material.dart';
import 'package:tex_markdown/custom_widgets/custom_divider.dart';
import 'package:tex_markdown/custom_widgets/custom_error_image.dart';
import 'package:tex_markdown/custom_widgets/custom_rb_cb.dart';
import 'package:tex_markdown/custom_widgets/unordered_ordered_list.dart';
import 'package:tex_text/tex_text.dart';
import 'md_widget.dart';

/// Markdown components
abstract class MarkdownComponent {
  static final List<MarkdownComponent> components = [
    // TableMd(),
    HTag(),
    BoldMd(),
    ItalicMd(),
    ImageMd(),
    ATagMd(),
    UnOrderedList(),
    OrderedList(),
    RadioButtonMd(),
    CheckBoxMd(),
    HrLine(),
    TextMd(),
  ];

  /// Convert markdown to html
  static String toHtml(String text) {
    String html = "";
    text.split(RegExp(r"\n+")).forEach((element) {
      for (var each in components) {
        if (each.exp.hasMatch(element.trim())) {
          if (each is InlineMd) {
            html += "${each.toHtml(element)}\n";
            break;
          } else if (each is BlockMd) {
            html += "${each.toHtml(element)}\n";
            break;
          }
        }
      }
    });
    return html;
  }

  /// Generate widget for markdown widget
  static List<InlineSpan> generate(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    List<InlineSpan> spans = [];
    text.split(RegExp(r"\n+")).forEach(
      (element) {
        for (var each in components) {
          if (each.exp.hasMatch(element.trim())) {
            if (each is InlineMd) {
              spans.add(each.span(
                context,
                element.trim(),
                style,
                onLinkTab,
              ));
              spans.add(
                TextSpan(
                  text: " ",
                  style: style,
                ),
              );
            } else {
              if (each is BlockMd) {
                spans.addAll([
                  TextSpan(
                    text: "\n ",
                    style: TextStyle(
                      fontSize: 0,
                      height: 0,
                      color: style?.color,
                    ),
                  ),
                  each.span(context, element.trim(), style, onLinkTab),
                  TextSpan(
                    text: "\n ",
                    style: TextStyle(
                      fontSize: 0,
                      height: 0,
                      color: style?.color,
                    ),
                  ),
                ]);
              }
            }
            return;
          }
        }
      },
    );
    return spans;
  }

  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  );

  RegExp get exp;
  bool get inline;
}

/// Inline component
abstract class InlineMd extends MarkdownComponent {
  @override
  bool get inline => true;

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  );
  String toHtml(String text);
}

/// Block component
abstract class BlockMd extends MarkdownComponent {
  @override
  bool get inline => false;
  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    return WidgetSpan(
      child: build(context, text, style, onLinkTab),
      alignment: PlaceholderAlignment.middle,
    );
  }

  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  );
  String toHtml(String text);
}

/// Heading component
class HTag extends BlockMd {
  @override
  final RegExp exp = RegExp(r"^(#{1,6})\s([^\n]+)$");
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return Text.rich(TextSpan(
      children: [
        WidgetSpan(
          child: TexText("${match?[2]}",
              style: [
                Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: style?.color),
                Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: style?.color),
                Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: style?.color),
                Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: style?.color),
                Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: style?.color),
                Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: style?.color),
              ][match![1]!.length - 1]),
        ),
        if (match[1]!.length == 1) ...[
          const TextSpan(
            text: "\n ",
            style: TextStyle(fontSize: 0, height: 0),
          ),
          WidgetSpan(
            child: CustomDivider(
              height: 2,
              color: style?.color ?? Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ],
    ));
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return "<h${match![1]!.length}>${TexText.toHtmlData(match[2].toString().trim())}<h${match[1]!.length}>";
  }
}

/// Horizontal line component
class HrLine extends BlockMd {
  @override
  final RegExp exp = RegExp(r"^(--)[-]+$");
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    return CustomDivider(
      height: 2,
      color: style?.color ?? Theme.of(context).colorScheme.outline,
    );
  }

  @override
  String toHtml(String text) {
    return "<hr/>";
  }
}

/// Checkbox component
class CheckBoxMd extends BlockMd {
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return CustomCb(
      value: ("${match?[1]}" == "x"),
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        style: style,
      ),
    );
  }

  @override
  final RegExp exp = RegExp(r"^\[(\x?)\]\s(\S.*)$");

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<p><input type="checkbox"${("${match?[1]}" == "x") ? "checked" : ""}>${MdWidget.toHtml((match?[2]).toString()).trim()}</p>';
  }
}

/// Radio Button component
class RadioButtonMd extends BlockMd {
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return CustomRb(
      value: ("${match?[1]}" == "x"),
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        style: style,
      ),
    );
  }

  @override
  final RegExp exp = RegExp(r"^\((\x?)\)\s(\S.*)$");

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<p><input type="radio"${("${match?[1]}" == "x") ? "checked" : ""}>${MdWidget.toHtml((match?[2]).toString().trim())}</p>';
  }
}

/// Unordered list component
class UnOrderedList extends BlockMd {
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return UnorderedListView(
      bulletColor: style?.color,
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        style: style,
      ),
    );
  }

  @override
  final RegExp exp = RegExp(r"^(\-|\*)\s([^\n]+)$");

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return "<ul><li>${MdWidget.toHtml((match?[2]).toString()).trim()}</li></ul>";
  }
}

/// Ordered list component
class OrderedList extends BlockMd {
  @override
  final RegExp exp = RegExp(r"^([0-9]+\.)\s([^\n]+)$");

  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return OrderedListView(
      no: "${match?[1]}",
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        style: style,
      ),
    );
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<ol start="${match?[1]}"><li>${MdWidget.toHtml((match?[2]).toString()).trim()}</li></ol>';
  }
}

/// Bold text component
class BoldMd extends InlineMd {
  @override
  final RegExp exp = RegExp(r"^\*{2}(([\S^\*].*)?[\S^\*])\*{2}$");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return WidgetSpan(
      // text: "${match?[1]}",
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: TexText(
        "${match?[1]}",
        style: style?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: style?.copyWith(fontWeight: FontWeight.bold) ??
          const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<b>${TexText.toHtmlData((match?[1]).toString()).trim()}</b>';
  }
}

/// Italic text component
class ItalicMd extends InlineMd {
  @override
  final RegExp exp = RegExp(r"^\*{1}(([\S^\*].*)?[\S^\*])\*{1}$");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: TexText(
        "${match?[1]}",
        style:
            (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
      ),
      style: (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
    );
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<i>${TexText.toHtmlData((match?[1]).toString()).trim()}</i>';
  }
}

/// Link text component
class ATagMd extends InlineMd {
  @override
  final RegExp exp = RegExp(r"^\[([^\s\*].*[^\s]?)?\]\(([^\s\*]+)?\)$");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    if (match?[1] == null && match?[2] == null) {
      return const TextSpan();
    }
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: GestureDetector(
        onTap: () {
          if (onLinkTab == null) {
            return;
          }
          onLinkTab("${match?[2]}", "${match?[1]}");
        },
        child: TexText(
          "${match?[1]}",
          style: (style ?? const TextStyle()).copyWith(
            color: Colors.blueAccent,
            decorationColor: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    return '<a href="${match?[2]}">${TexText.toHtmlData((match?[1]).toString())}</a>';
  }
}

/// Image component
class ImageMd extends InlineMd {
  @override
  final RegExp exp = RegExp(r"^\!\[([^\s].*[^\s]?)?\]\(([^\s]+)\)$");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    double? height;
    double? width;
    if (match?[1] != null) {
      var size = RegExp(r"^([0-9]+)?x?([0-9]+)?")
          .firstMatch(match![1].toString().trim());
      width = double.tryParse(size?[1]?.toString().trim() ?? 'a');
      height = double.tryParse(size?[2]?.toString().trim() ?? 'a');
    }
    return WidgetSpan(
      alignment: PlaceholderAlignment.bottom,
      child: SizedBox(
        width: width,
        height: height,
        child: Image(
          image: NetworkImage(
            "${match?[2]}",
          ),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return CustomImageLoading(
              progress: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : 1,
            );
          },
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return const CustomImageError();
          },
        ),
      ),
    );
  }

  @override
  String toHtml(String text) {
    var match = exp.firstMatch(text.trim());
    double? height;
    double? width;
    if (match?[1] != null) {
      var size = RegExp(r"^([0-9]+)?x?([0-9]+)?")
          .firstMatch(match![1].toString().trim());
      width = double.tryParse(size?[1]?.toString().trim() ?? 'a');
      height = double.tryParse(size?[2]?.toString().trim() ?? 'a');
    }
    return '<img src="${match?[2].toString().trim()}" height="$height" width="$width">';
  }
}

/// Table component
class TableMd extends BlockMd {
  @override
  Widget build(BuildContext context, String text, TextStyle? style,
      void Function(String url, String title)? onLinkTab) {
    final List<Map<int, String>> value = text
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

  @override
  RegExp get exp => RegExp(
        r"(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)?",
      );

  @override
  String toHtml(String text) {
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
}

/// Text component
class TextMd extends InlineMd {
  @override
  final RegExp exp = RegExp(".*");

  @override
  InlineSpan span(BuildContext context, String text, TextStyle? style,
      void Function(String url, String title)? onLinkTab) {
    return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: TexText(
          text,
          style: style,
        ));
  }

  @override
  String toHtml(String text) {
    return TexText.toHtmlData(text).trim();
  }
}
