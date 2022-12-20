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
              children: e
                  .split(r'$')
                  .asMap()
                  .map<int, Iterable<Widget>>(
                    (index, e) {
                      if (index.isOdd) {
                        return MapEntry(
                          index,
                          [
                            if (e.isEmpty)
                              Text(
                                r'$',
                                textAlign: TextAlign.values[alignment.index],
                                style: style,
                              )
                            else
                              Math.tex(
                                e,
                                textStyle: style,
                                mathStyle: mathStyle,
                              ),
                          ],
                        );
                      }
                      return MapEntry(
                        index,
                        e
                            .split(" ")
                            .asMap()
                            .map<int, Iterable<Widget>>(
                              (index, e) {
                                return MapEntry(index, [
                                  if (index != 0)
                                    Text(
                                      " ",
                                      style: style,
                                    ),
                                  Text(
                                    e,
                                    textAlign:
                                        TextAlign.values[alignment.index],
                                    style: style,
                                  ),
                                ]);
                              },
                            )
                            .values
                            .expand((element) => element),
                      );
                    },
                  )
                  .values
                  .expand<Widget>((element) => element)
                  .toList());
        },
      ).toList(),
    );
  }
}
