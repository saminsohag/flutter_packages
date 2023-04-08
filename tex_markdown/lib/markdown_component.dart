import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';
import 'md_widget.dart';

/// Markdown components
abstract class MarkdownComponent {
  static final List<MarkdownComponent> components = [
    HTag(),
    BoldMd(),
    ItalicMd(),
    ATagMd(),
    ImageMd(),
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
  static Widget generate(
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
                element,
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
                spans.add(
                  each.span(context, element, style, onLinkTab),
                );
              }
            }
            return;
          }
        }
      },
    );
    return Text.rich(
      TextSpan(
        children: List.from(spans),
      ),
      textAlign: TextAlign.left,
    );
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: build(context, text, style, onLinkTab),
      ),
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
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
          ],
        ),
        if (match[1]!.length == 1)
          Divider(
            height: 6,
            thickness: 2,
            color:
                style?.color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      ],
    );
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
    return Divider(
      height: 6,
      thickness: 2,
      color: style?.color ?? Theme.of(context).colorScheme.onSurfaceVariant,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Checkbox(
            // value: true,
            value: ("${match?[1]}" == "x"),
            onChanged: (value) {},
            fillColor: ButtonStyleButton.allOrNull(style?.color),
          ),
        ),
        Expanded(
          child: MdWidget(
            "${match?[2]}",
            onLinkTab: onLinkTab,
            style: style,
          ),
        ),
      ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Radio(
            value: true,
            groupValue: ("${match?[1]}" == "x"),
            onChanged: (value) {},
            fillColor: ButtonStyleButton.allOrNull(style?.color),
          ),
        ),
        Expanded(
          child: MdWidget(
            "${match?[2]}",
            onLinkTab: onLinkTab,
            style: style,
          ),
        ),
      ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.circle,
            color: style?.color,
            size: 8,
          ),
        ),
        Expanded(
          child: MdWidget(
            "${match?[2]}",
            onLinkTab: onLinkTab,
            style: style,
          ),
        ),
      ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Text(
            "${match?[1]}",
            style: (style ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: MdWidget(
            "${match?[2]}",
            onLinkTab: onLinkTab,
            style: style,
          ),
        ),
      ],
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
        child: Image.network(
          "${match?[2]}",
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return Placeholder(
              color: Theme.of(context).colorScheme.error,
              child: Text(
                "${match?[2]}\n$error",
                style: style,
              ),
            );
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
