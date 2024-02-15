import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:gpt_markdown/custom_widgets/custom_divider.dart';
import 'package:gpt_markdown/custom_widgets/custom_error_image.dart';
import 'package:gpt_markdown/custom_widgets/custom_rb_cb.dart';
import 'package:gpt_markdown/custom_widgets/unordered_ordered_list.dart';
import 'md_widget.dart';

/// Markdown components
abstract class MarkdownComponent {
  static List<MarkdownComponent> get components => [
        HTag(),
        IndentMd(),
        UnOrderedList(),
        OrderedList(),
        RadioButtonMd(),
        CheckBoxMd(),
        HrLine(),
        ImageMd(),
        BoldMd(),
        LatexMathMultyLine(),
        LatexMath(),
        ItalicMd(),
        ATagMd(),
      ];

  /// Generate widget for markdown widget
  static List<InlineSpan> generate(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    List<InlineSpan> spans = [];
    List<String> regexes =
        components.map<String>((e) => e.exp.pattern).toList();
    final combinedRegex = RegExp(
      regexes.join("|"),
      multiLine: true,
      dotAll: true,
    );
    List<String> elements = [];
    text.splitMapJoin(
      combinedRegex,
      onMatch: (p0) {
        String element = p0[0] ?? "";
        elements.add(element);
        for (var each in components) {
          if (each.exp.hasMatch(element)) {
            if (each is InlineMd) {
              spans.add(each.span(
                context,
                element,
                style,
                textDirection,
                onLinkTab,
              ));
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
                  each.span(
                    context,
                    element,
                    style,
                    textDirection,
                    onLinkTab,
                  ),
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
            return "";
          }
        }
        return "";
      },
      onNonMatch: (p0) {
        spans.add(
          TextSpan(
            text: p0,
            style: style,
          ),
        );
        return "";
      },
    );

    return spans;
  }

  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
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
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  );
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
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    return WidgetSpan(
      child: build(
        context,
        text,
        style,
        textDirection,
        onLinkTab,
      ),
      alignment: PlaceholderAlignment.middle,
    );
  }

  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  );
}

/// Heading component
class HTag extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^(#{1,6})\ ([^\n]+?)$");
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return Text.rich(
      TextSpan(
        children: [
          ...(MarkdownComponent.generate(
            context,
            "${match?[2]}",
            [
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
            ][match![1]!.length - 1],
            textDirection,
            (url, title) {},
          )),
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
      ),
      textDirection: textDirection,
    );
  }

  // @override
  // String toHtml(String text) {
  //   var match = exp.firstMatch(text.trim());
  //   return "<h${match![1]!.length}>${TexText.toHtmlData(match[2].toString().trim())}<h${match[1]!.length}>";
  // }
}

/// Horizontal line component
class HrLine extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^(--)[-]+$");
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    return CustomDivider(
      height: 2,
      color: style?.color ?? Theme.of(context).colorScheme.outline,
    );
  }
}

/// Checkbox component
class CheckBoxMd extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^\[(\x?)\]\ (\S[^\n]*?)$");
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return CustomCb(
      value: ("${match?[1]}" == "x"),
      textDirection: textDirection,
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        textDirection: textDirection,
        style: style,
      ),
    );
  }
}

/// Radio Button component
class RadioButtonMd extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^\((\x?)\)\ (\S[^\n]*)$");
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return CustomRb(
      value: ("${match?[1]}" == "x"),
      textDirection: textDirection,
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        textDirection: textDirection,
        style: style,
      ),
    );
  }
}

/// Indent
class IndentMd extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^(\ +)([^\n]+)$");
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    [
      r"\\\[(.*?)\\\]",
      r"\\\((.*?)\\\)",
      r"(?<!\\)\$((?:\\.|[^$])*?)\$(?!\\)",
    ].join("|");
    var match = exp.firstMatch(text);
    int spaces = (match?[1] ?? "").length;
    return UnorderedListView(
      bulletColor: style?.color,
      padding: spaces * 5,
      bulletSize: 0,
      textDirection: textDirection,
      child: RichText(
          text: TextSpan(
        children: MarkdownComponent.generate(
          context,
          "${match?[2]}",
          style,
          textDirection,
          onLinkTab,
        ),
      )),
    );
  }
}

/// Unordered list component
class UnOrderedList extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^(?:\-|\*)\ ([^\n]+)$");
  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text);
    return UnorderedListView(
      bulletColor: style?.color,
      padding: 10.0,
      bulletSize: 3,
      textDirection: textDirection,
      child: MdWidget(
        "${match?[1]}",
        onLinkTab: onLinkTab,
        textDirection: textDirection,
        style: style,
      ),
    );
  }
}

/// Ordered list component
class OrderedList extends BlockMd {
  @override
  RegExp get exp => RegExp(r"^([0-9]+\.)\ ([^\n]+)$");

  get onLinkTab => null;

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return OrderedListView(
      no: "${match?[1]}",
      textDirection: textDirection,
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.w100),
      child: MdWidget(
        "${match?[2]}",
        onLinkTab: onLinkTab,
        textDirection: textDirection,
        style: style,
      ),
    );
  }
}

/// Bold text component
class BoldMd extends InlineMd {
  @override
  RegExp get exp => RegExp(r"\*\*(([\S^\*].*?)?[\S^\*?])\*\*");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return TextSpan(
      children: MarkdownComponent.generate(
        context,
        "${match?[1]}",
        style?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.w900),
        textDirection,
        onLinkTab,
      ),
      style: style?.copyWith(fontWeight: FontWeight.bold) ??
          const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class LatexMathMultyLine extends InlineMd {
  @override
  RegExp get exp => RegExp(
        r"\\\[(.*?)\\\]",
        dotAll: true,
      );

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var p0 = exp.firstMatch(text.trim());
    p0?.group(0);
    String mathText = p0?[1]?.toString() ?? "";
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Math.tex(
        mathText,
        textStyle: style?.copyWith(
          fontFamily: "SansSerif",
        ),
        mathStyle: MathStyle.display,
        textScaleFactor: 1,
        settings: const TexParserSettings(
          strict: Strict.ignore,
        ),
        options: MathOptions(
          sizeUnderTextStyle: MathSize.large,
          color: style?.color ?? Theme.of(context).colorScheme.onSurface,
          fontSize: style?.fontSize ??
              Theme.of(context).textTheme.bodyMedium?.fontSize,
          mathFontOptions: FontOptions(
            fontFamily: "Main",
            fontWeight: style?.fontWeight ?? FontWeight.normal,
            fontShape: FontStyle.normal,
          ),
          textFontOptions: FontOptions(
            fontFamily: "Main",
            fontWeight: style?.fontWeight ?? FontWeight.normal,
            fontShape: FontStyle.normal,
          ),
          style: MathStyle.display,
        ),
        onErrorFallback: (err) {
          return Text(
            mathText,
            textDirection: textDirection,
            style:
                style?.copyWith(color: Theme.of(context).colorScheme.error) ??
                    TextStyle(color: Theme.of(context).colorScheme.error),
          );
        },
      ),
    );
  }
}

/// Italic text component
class LatexMath extends InlineMd {
  @override
  RegExp get exp => RegExp(
        [
          r"\\\((.*?)\\\)",
          // r"(?<!\\)\$((?:\\.|[^$])*?)\$(?!\\)",
        ].join("|"),
        dotAll: true,
      );

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var p0 = exp.firstMatch(text.trim());
    p0?.group(0);
    String mathText = p0?[1]?.toString() ?? "";
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Math.tex(
        mathText,
        textStyle: style?.copyWith(
          fontFamily: "SansSerif",
        ),
        mathStyle: MathStyle.display,
        textScaleFactor: 1,
        settings: const TexParserSettings(
          strict: Strict.ignore,
        ),
        options: MathOptions(
          sizeUnderTextStyle: MathSize.large,
          color: style?.color ?? Theme.of(context).colorScheme.onSurface,
          fontSize: style?.fontSize ??
              Theme.of(context).textTheme.bodyMedium?.fontSize,
          mathFontOptions: FontOptions(
            fontFamily: "Main",
            fontWeight: style?.fontWeight ?? FontWeight.normal,
            fontShape: FontStyle.normal,
          ),
          textFontOptions: FontOptions(
            fontFamily: "Main",
            fontWeight: style?.fontWeight ?? FontWeight.normal,
            fontShape: FontStyle.normal,
          ),
          style: MathStyle.display,
        ),
        onErrorFallback: (err) {
          return Text(
            mathText,
            textDirection: textDirection,
            style:
                style?.copyWith(color: Theme.of(context).colorScheme.error) ??
                    TextStyle(color: Theme.of(context).colorScheme.error),
          );
        },
      ),
    );
  }
}

/// Italic text component
class ItalicMd extends InlineMd {
  @override
  RegExp get exp => RegExp(r"\*(\S(.*?\S)?)\*", dotAll: true);

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
  ) {
    var match = exp.firstMatch(text.trim());
    return TextSpan(
      children: MarkdownComponent.generate(
        context,
        "${match?[1]}",
        (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
        textDirection,
        onLinkTab,
      ),
      style: (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
    );
  }
}

/// Link text component
class ATagMd extends InlineMd {
  @override
  RegExp get exp => RegExp(r"\[([^\s\*][^\n]*?[^\s]?)?\]\(([^\s\*]+)?\)");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
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
        child: Text.rich(
          TextSpan(
            text: "${match?[1]}",
            style: (style ?? const TextStyle()).copyWith(
              color: Colors.blueAccent,
              decorationColor: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
          textDirection: textDirection,
        ),
      ),
    );
  }
}

/// Image component
class ImageMd extends InlineMd {
  @override
  RegExp get exp => RegExp(r"\!\[([^\s][^\n]*[^\s]?)?\]\(([^\s]+)\)");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
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
}

/// Table component
class TableMd extends BlockMd {
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    void Function(String url, String title)? onLinkTab,
  ) {
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
      textDirection: textDirection,
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
    );
  }

  @override
  RegExp get exp => RegExp(
        r"(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)?",
      );
}
