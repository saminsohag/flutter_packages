import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:gpt_markdown/custom_widgets/custom_divider.dart';
import 'package:gpt_markdown/custom_widgets/custom_error_image.dart';
import 'package:gpt_markdown/custom_widgets/custom_rb_cb.dart';
import 'package:gpt_markdown/custom_widgets/unordered_ordered_list.dart';
import 'md_widget.dart';

/// Markdown components
abstract class MarkdownComponent {
  static final List<MarkdownComponent>  components = [
        CodeBlockMd(),
        NewLines(),
        TableMd(),
        HTag(),
        IndentMd(),
        UnOrderedList(),
        OrderedList(),
        RadioButtonMd(),
        CheckBoxMd(),
        HrLine(),
        ImageMd(),
        HighlightedText(),
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
                latexWorkaround,
                latexBuilder,
                codeBuilder,
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
                    latexWorkaround,
                    latexBuilder,
                    codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    return WidgetSpan(
      child: build(
        context,
        text,
        style,
        textDirection,
        onLinkTab,
        latexWorkaround,
        latexBuilder,
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
            latexWorkaround,
            latexBuilder,
            codeBuilder,
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
}

class NewLines extends InlineMd {
  @override
  RegExp get exp => RegExp(r"\n\n+");
  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    return TextSpan(
      text: "\n\n\n\n",
      style: TextStyle(
        fontSize: 6,
        color: style?.color,
      ),
    );
  }
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
            latexWorkaround,
            latexBuilder,
            codeBuilder),
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
      ),
    );
  }
}

class HighlightedText extends InlineMd {
  @override
  RegExp get exp => RegExp(r"`.*?`");

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    return TextSpan(
      text: text,
      style: style?.copyWith(
            fontWeight: FontWeight.bold,
            background: Paint()
              ..color = Theme.of(context).colorScheme.surfaceVariant
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round,
          ) ??
          TextStyle(
            fontWeight: FontWeight.bold,
            background: Paint()
              ..color = Theme.of(context).colorScheme.surfaceVariant
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
        latexWorkaround,
        latexBuilder,
        codeBuilder,
      ),
      style: style?.copyWith(fontWeight: FontWeight.bold) ??
          const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class LatexMathMultyLine extends BlockMd {
  @override
  RegExp get exp => RegExp(
        r"\\\[(.*?)\\\]|(\\begin.*?\\end{.*?})",
        dotAll: true,
      );

  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    void Function(String url, String title)? onLinkTab,
    String Function(String tex)? latexWorkaround,
    Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    var p0 = exp.firstMatch(text.trim());
    p0?.group(0);
    String mathText = p0?[1] ?? p0?[2] ?? "";
    var workaround = latexWorkaround ?? (String tex) => tex;

    var builder = latexBuilder ??
        (BuildContext context, String tex, TextStyle textStyle, bool inline) =>
            Math.tex(
              tex,
              textStyle: textStyle,
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
                  workaround(mathText),
                  textDirection: textDirection,
                  style: textStyle.copyWith(
                      color: (!kDebugMode)
                          ? null
                          : Theme.of(context).colorScheme.error),
                );
              },
            );
    return builder(
        context, workaround(mathText), style ?? const TextStyle(), false);
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    var p0 = exp.firstMatch(text.trim());
    p0?.group(0);
    String mathText = p0?[1]?.toString() ?? "";
    var workaround = latexWorkaround ?? (String tex) => tex;
    var builder = latexBuilder ??
        (BuildContext context, String tex, TextStyle textStyle, bool inline) =>
            Math.tex(
              tex,
              textStyle: textStyle,
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
                  workaround(mathText),
                  textDirection: textDirection,
                  style: textStyle.copyWith(
                      color: (!kDebugMode)
                          ? null
                          : Theme.of(context).colorScheme.error),
                );
              },
            );
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: builder(
          context, workaround(mathText), style ?? const TextStyle(), true),
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    var match = exp.firstMatch(text.trim());
    return TextSpan(
      children: MarkdownComponent.generate(
        context,
        "${match?[1]}",
        (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
        textDirection,
        onLinkTab,
        latexWorkaround,
        latexBuilder,
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
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
    bool heading = RegExp(
      r"^\|.*?\|\n\|-[-\\ |]*?-\|$",
      multiLine: true,
    ).hasMatch(text.trim());
    int maxCol = 0;
    for (final each in value) {
      if (maxCol < each.keys.length) {
        maxCol = each.keys.length;
      }
    }
    if (maxCol == 0) {
      return Text("", style: style);
    }
    final controller = ScrollController();
    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Table(
          textDirection: textDirection,
          defaultColumnWidth: CustomTableColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(
            width: 1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: value
              .asMap()
              .entries
              .map<TableRow>(
                (entry) => TableRow(
                  decoration: (heading)
                      ? BoxDecoration(
                          color: (entry.key == 0)
                              ? Theme.of(context).colorScheme.surfaceVariant
                              : null,
                        )
                      : null,
                  children: List.generate(
                    maxCol,
                    (index) {
                      var e = entry.value;
                      String data = e[index] ?? "";
                      if (RegExp(r"^--+$").hasMatch(data.trim()) ||
                          data.trim().isEmpty) {
                        return const SizedBox();
                      }

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: MdWidget(
                            (e[index] ?? "").trim(),
                            textDirection: textDirection,
                            onLinkTab: onLinkTab,
                            style: style,
                            latexWorkaround: latexWorkaround,
                            latexBuilder: latexBuilder,
                            codeBuilder: codeBuilder,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  RegExp get exp => RegExp(
        r"^(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?))(\n(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?)))+)$",
      );
}

class CodeBlockMd extends BlockMd {
  @override
  RegExp get exp => RegExp(
        r"\s*?```(.*?)\n((.*?)(:?\n\s*?```)|(.*)(:?\n```)?)$",
        multiLine: true,
        dotAll: true,
      );
  @override
  Widget build(
    BuildContext context,
    String text,
    TextStyle? style,
    TextDirection textDirection,
    final void Function(String url, String title)? onLinkTab,
    final String Function(String tex)? latexWorkaround,
    final Widget Function(
            BuildContext context, String tex, TextStyle textStyle, bool inline)?
        latexBuilder,
    final Widget Function(BuildContext context, String name, String code)?
        codeBuilder,
  ) {
    String codes = exp.firstMatch(text)?[2] ?? "";
    String name = exp.firstMatch(text)?[1] ?? "";
    codes = codes.replaceAll(r"```", "").trim();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: codeBuilder != null
          ? codeBuilder(context, name, codes)
          : CodeField(name: name, codes: codes),
    );
  }
}

class CodeField extends StatefulWidget {
  const CodeField({super.key, required this.name, required this.codes});
  final String name;
  final String codes;

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  bool _copied = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onInverseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(widget.name),
              ),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget.codes))
                      .then((value) {
                    setState(() {
                      _copied = true;
                    });
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _copied = false;
                  });
                },
                icon: Icon(
                  (_copied) ? Icons.done : Icons.content_paste,
                  size: 15,
                ),
                label: Text((_copied) ? "Copied!" : "Copy code"),
              ),
            ],
          ),
          const Divider(
            height: 1,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.codes,
            ),
          ),
        ],
      ),
    );
  }
}
