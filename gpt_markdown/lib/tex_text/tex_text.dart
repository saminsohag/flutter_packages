// library tex_text;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
//
// /// A LaTex text view.
// ///
// /// Example:
// /// ```dart
// /// TexText(r"The equation is $x^2+y^2=z^2$") //Output: The equation is <LaTex formatted equation>
// ///
// /// // \$ shows $ result
// /// TexText(r"The equation is \$") //Output: The equation is $
// /// ```
// class TexText {
//   const TexText(
//     this.text, {
//     TextStyle? style,
//     this.textDirection = TextDirection.ltr,
//     this.mathStyle = MathStyle.text,
//   }) : _style = style;
//   final String text;
//   final TextStyle? _style;
//   final TextDirection textDirection;
//   final MathStyle mathStyle;
//   // final TexAlignment alignment;
//
//   List<InlineSpan> getSpans(BuildContext context) {
//     //
//     String e = text;
//     TextStyle? style = _style ?? Theme.of(context).textTheme.bodyMedium;
//     List<InlineSpan> spans = [];
//
//     e.splitMapJoin(
//       RegExp(
//         r"\\\[(.*?)\\\]|\\\((.*?)\\\)",
//         multiLine: true,
//         dotAll: true,
//       ),
//       onMatch: (p0) {
//         spans.add(
//           WidgetSpan(
//             alignment: PlaceholderAlignment.baseline,
//             baseline: TextBaseline.alphabetic,
//             child: Math.tex(
//               // _newEasySyntax(p0[1].toString().replaceAll(dollar, "\\\$")),
//               p0[1]?.toString() ?? p0[2].toString(),
//               textStyle: style?.copyWith(
//                 fontFamily: "SansSerif",
//               ),
//               mathStyle: mathStyle,
//               textScaleFactor: 1,
//               settings: const TexParserSettings(
//                 strict: Strict.ignore,
//               ),
//               options: MathOptions(
//                 sizeUnderTextStyle: MathSize.large,
//                 color: style?.color ?? Theme.of(context).colorScheme.onSurface,
//                 fontSize: style?.fontSize ??
//                     Theme.of(context).textTheme.bodyMedium?.fontSize,
//                 mathFontOptions: FontOptions(
//                   fontFamily: "Main",
//                   fontWeight: style?.fontWeight ?? FontWeight.normal,
//                   fontShape: FontStyle.normal,
//                 ),
//                 textFontOptions: FontOptions(
//                   fontFamily: "Main",
//                   fontWeight: style?.fontWeight ?? FontWeight.normal,
//                   fontShape: FontStyle.normal,
//                 ),
//                 style: mathStyle,
//               ),
//               onErrorFallback: (err) {
//                 return Text(
//                   "\\(${p0[1] ?? p0[2]}\\)",
//                   textDirection: textDirection,
//                   style: style?.copyWith(
//                           color: Theme.of(context).colorScheme.error) ??
//                       TextStyle(color: Theme.of(context).colorScheme.error),
//                 );
//               },
//             ),
//           ),
//         );
//         return p0[1].toString();
//       },
//       onNonMatch: (p0) {
//         spans.add(
//           TextSpan(
//             text: p0.toString(),
//             style: style,
//           ),
//         );
//         return p0;
//       },
//     );
//     return spans;
//   }
// }
