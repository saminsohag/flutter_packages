library tex_text;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
export 'package:flutter_math_fork/flutter_math.dart';

/// A LaTex text view.
///
/// Example:
/// ```dart
/// TexText(r"The equation is $x^2+y^2=z^2$") //Output: The equation is <LaTex formatted equation>
///
/// // \$ shows $ result
/// TexText(r"The equation is \$") //Output: The equation is $
/// ```
class TexText extends StatelessWidget {
  const TexText(
    this.text, {
    super.key,
    TextStyle? style,
    this.textDirection = TextDirection.ltr,
    this.mathStyle = MathStyle.text,
  }) : _style = style;
  final String text;
  final TextStyle? _style;
  final TextDirection textDirection;
  final MathStyle mathStyle;
  // final TexAlignment alignment;

  /// LaTex to HTML parser
  String toHtml() {
    return toHtmlData(text);
  }

  /// LaTex custom syntax
  static String _newEasySyntax(String data) {
    return data
        .replaceAll(r"\frac", r"\cfrac")
        .replaceAll(r"\left[", r"[")
        .replaceAll(r"\right]", r"]")
        .replaceAll(r"[", r"{\left[{")
        .replaceAll(r"]", r"}\right]}")
        .replaceAllMapped(
          RegExp(r'\\sqrt\{\\left\[\{(.*?)\}\\right\]\}'),
          (match) =>
              "\\sqrt[${match[1].toString().replaceAll(r"\cfrac", r"\frac")}]",
        )
        .replaceAll(r"\left\{", r"\{")
        .replaceAll(r"\right\}", r"\}")
        .replaceAll(r"\{", r"{\left\{{")
        .replaceAll(r"\}", r"}\right\}}")
        .replaceAll(r"\left(", r"(")
        .replaceAll(r"\right)", r")")
        .replaceAll(r"(", r"{\left({")
        .replaceAll(r")", r"}\right)}")
        .replaceAll(RegExp(r"\\tf"), r"\therefore")
        .replaceAll(RegExp(r"\\bc"), r"\because")
        .replaceAllMapped(
            RegExp(r"([^A-Za-z\\]|^)(sin|cos|tan|cosec|sec|cot)([^A-Za-z]|$)"),
            (match) =>
                "${match[1].toString()}{\\,\\${match[2].toString()}}${match[3].toString()}")
        .replaceAll(r"=>", r"{\Rightarrow}")
        .replaceAll(RegExp(r"\\AA(\s|$)"), r"{\text{Å}}")
        .replaceAll(r"*", r"{\times}")
        .replaceAllMapped(
            RegExp(r"\\([a-z]?)mat(\s+?\S.*?)\\([a-z]?)mat"),
            (match) =>
                "\\begin{${match[1].toString()}matrix}${match[2].toString().replaceAll("\\&", r"{\&}").replaceAll(",", "&").replaceAll("&&", "\\\\")}\\end{${match[3].toString()}matrix}");
  }

  /// LaTex to HTML parser
  static String toHtmlData(String data) {
    const dollar = r"\[-~`::36]";
    return data.replaceAll("\\\$", dollar).splitMapJoin(
      RegExp(
        r"(?!\\)\$(.*?)(?!\\)\$",
      ),
      onMatch: (p0) {
        return "\\(${_newEasySyntax(p0[1].toString().replaceAll(dollar, "\\\$"))}\\)";
      },
      onNonMatch: (p0) {
        return p0
            .replaceAll(dollar, "\$")
            .replaceAll("\n", "</br>")
            .replaceAll(" ", r"&nbsp;");
      },
    ).trim();
  }

  /// Generate spans for widget
  Widget _generateWidget(BuildContext context, String e) {
    TextStyle? style = _style ?? Theme.of(context).textTheme.bodyMedium;
    const dollar = r"\[-~`::36]";
    List<InlineSpan> spans = [];

    e.replaceAll("\\\$", dollar).splitMapJoin(
      RegExp(
        r"\$(.*?)\$",
      ),
      onMatch: (p0) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Math.tex(
              _newEasySyntax(p0[1].toString().replaceAll(dollar, "\\\$")),
              textStyle: style?.copyWith(
                fontFamily: "SansSerif",
              ),
              mathStyle: mathStyle,
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
                style: mathStyle,
              ),
              onErrorFallback: (err) {
                return Text(
                  "\$${p0[1]}\$",
                  textDirection: textDirection,
                  style: style?.copyWith(
                          color: Theme.of(context).colorScheme.error) ??
                      TextStyle(color: Theme.of(context).colorScheme.error),
                );
              },
            ),
          ),
        );
        return p0[1].toString();
      },
      onNonMatch: (p0) {
        spans.add(
          TextSpan(
            text: p0.toString().replaceAll(dollar, "\$"),
            style: style,
          ),
        );
        return p0;
      },
    );
    return Text.rich(
      TextSpan(
        children: spans,
      ),
      textDirection: textDirection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _generateWidget(context, text);
  }
}
