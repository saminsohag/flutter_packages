import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';

class MdWidget extends StatelessWidget {
  MdWidget(String expression,
      {super.key, this.style, this.onLinkTab, this.followLinkColor = false})
      : exp = expression.trim();
  final String exp;
  final TextStyle? style;
  final Function(String url, String title)? onLinkTab;
  final bool followLinkColor;
  @override
  Widget build(BuildContext context) {
    final RegExp h = RegExp(r"^(#{1,6})\s(.*)$");
    final RegExp b = RegExp(r"^\*\*([^\s].*[^\s])\*\*$");
    final RegExp a = RegExp(r"^\[([^\s].*[^\s]?)?\]\(([^\s]+)?\)$");
    final RegExp img = RegExp(r"^\!\[([^\s].*[^\s]?)?\]\(([^\s]+)\)$");
    final RegExp ol = RegExp(r"^\*{1}\s(.*)$");
    final RegExp table =
        RegExp(r"^(((\|(.*)?\|)(\s?)+\n(\s?)+)+)?((\|(.*)?\|))$");
    if (table.hasMatch(exp)) {
      final List<Map<int, String>> value = exp
          .split('\n')
          .map<Map<int, String>>(
            (e) => e
                .trim()
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
        return const SizedBox();
      }
      return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(width: 1),
        children: value
            .map<TableRow>(
              (e) => TableRow(
                children: [
                  ...List.generate(
                    maxCol,
                    (index) => Center(
                      child: MdWidget(
                        e[index] ?? "",
                        style: style,
                        // alignment: TexAlignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      );
    }
    if (h.hasMatch(exp)) {
      var match = h.firstMatch(exp.trim());
      return TexText(
        "${match?[2]}",
        style: [
          Theme.of(context).textTheme.headline1?.copyWith(color: style?.color),
          Theme.of(context).textTheme.headline2?.copyWith(color: style?.color),
          Theme.of(context).textTheme.headline3?.copyWith(color: style?.color),
          Theme.of(context).textTheme.headline4?.copyWith(color: style?.color),
          Theme.of(context).textTheme.headline5?.copyWith(color: style?.color),
          Theme.of(context).textTheme.headline6?.copyWith(color: style?.color),
        ][match![1]!.length - 1],
      );
    }
    if (ol.hasMatch(exp)) {
      var match = ol.firstMatch(exp.trim());
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.circle,
              color: style?.color,
              size: 12,
            ),
          ),
          MdWidget(
            "${match?[1]}",
            style: style,
          ),
          // TexText(
          //   "${match?[1]}",
          //   style: style,
          // ),
        ],
      );
    }
    if (b.hasMatch(exp)) {
      var match = b.firstMatch(exp.trim());
      return TexText(
        "${match?[1]}",
        style: style?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    if (a.hasMatch(exp)) {
      var match = a.firstMatch(exp.trim());
      if (match?[1] == null && match?[2] == null) {
        return const SizedBox();
      }
      return GestureDetector(
        onTap: () {
          if (onLinkTab != null) {
            onLinkTab!("${match?[2]}", "${match?[2]}");
          }
        },
        child: MdWidget(
          "${match?[1]}",
          style: ((followLinkColor && style != null)
                  ? style
                  : const TextStyle(color: Colors.blueAccent))
              ?.copyWith(decoration: TextDecoration.underline),
        ),
      );
    }
    if (img.hasMatch(exp)) {
      var match = img.firstMatch(exp.trim());
      double? height;
      double? width;
      if (match?[1] != null) {
        var size = RegExp(r"^([0-9]+)?x?([0-9]+)?")
            .firstMatch(match![1].toString().trim());
        width = double.tryParse(size?[1]?.toString() ?? 'a');
        height = double.tryParse(size?[2]?.toString() ?? 'a');
      }
      return SizedBox(
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
      );
    }
    List<String> expL = exp
        .split('\n')
        .map(
          (e) => e.trim(),
        )
        .toList();
    bool hasMatch = false;

    for (final each in expL) {
      if (a.hasMatch(each) ||
          h.hasMatch(each) ||
          b.hasMatch(each) ||
          img.hasMatch(each) ||
          ol.hasMatch(each)) {
        hasMatch = true;
      }
    }
    if (hasMatch) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 2,
        children: exp
            .split("\n")
            .map<Widget>((e) => MdWidget(
                  e,
                  style: style,
                ))
            .toList(),
      );
    }
    return TexText(
      exp,
      style: style,
    );
  }
}
