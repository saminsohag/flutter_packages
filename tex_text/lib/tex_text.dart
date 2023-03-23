library tex_text;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
export 'package:flutter_math_fork/flutter_math.dart';

enum TexAlignment {
  /// [TexAlignment.start] aligns the words at the start of the text
  start,

  /// It aligns the words at the end of the text
  end,

  /// It aligns the words at the center of the text
  center,
}

/// A LaTex text view.
///
/// Example:
/// ```dart
/// TexText(r"The equation is <m>x^2+y^2=z^2<m>") //Output: The equation is <LaTex formatted equation>
///
/// // <m><m> shows <m> result
/// TexText(r"The equation is <m><m>") //Output: The equation is <m>
/// ```
class TexText extends StatelessWidget {
  const TexText(this.text,
      {super.key,
      this.style,
      this.mathStyle = MathStyle.display,
      this.alignment = TexAlignment.start});
  final String text;
  final TextStyle? style;
  final MathStyle mathStyle;
  final TexAlignment alignment;

  List<Widget> generateWidget(String e) {
    const dollar = r"\[-~`::36]";
    List<Widget> widgets = [];

    e.replaceAll("\\\$", dollar).splitMapJoin(
      RegExp(
        r"(?!\\)\$(.*?)(?!\\)\$",
      ),
      onMatch: (p0) {
        widgets.add(
          Math.tex(
            p0[1].toString().replaceAll(dollar, "\\\$"),
            textStyle: style,
            mathStyle: mathStyle,
            textScaleFactor: 1,
            onErrorFallback: (err) {
              return Text(
                "\$${p0[1]}\$",
                style: style?.copyWith(color: Colors.red),
              );
            },
          ),
        );
        return p0[1].toString();
      },
      onNonMatch: (p0) {
        p0
            .toString()
            .replaceAll(dollar, "\$")
            .split(" ")
            .asMap()
            .forEach((key, element) {
          if (key != 0) {
            widgets.add(Text(
              " ",
              textAlign: TextAlign.values[alignment.index],
              style: style,
            ));
          }
          widgets.add(Text(
            element,
            textAlign: TextAlign.values[alignment.index],
            style: style,
          ));
        });
        return p0;
      },
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.values[alignment.index],
      children: text.split('\n').map<Widget>(
        (e) {
          return Wrap(
              alignment: WrapAlignment.values[alignment.index],
              crossAxisAlignment: WrapCrossAlignment.center,
              children: generateWidget(e));
        },
      ).toList(),
    );
  }
}
