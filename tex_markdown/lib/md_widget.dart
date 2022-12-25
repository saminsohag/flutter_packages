import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';

/// It creates a markdown widget closed to each other.
class MdWidget extends StatelessWidget {
  const MdWidget(this.exp,
      {super.key, this.style, this.onLinkTab, this.followLinkColor = false});
  final String exp;
  final TextStyle? style;
  final void Function(String url, String title)? onLinkTab;
  final bool followLinkColor;
  @override
  Widget build(BuildContext context) {
    final RegExp h = RegExp(r"^(#{1,6})\s([^\n]+)$");
    final RegExp b = RegExp(r"^\*{2}(([\S^\*].*)?[\S^\*])\*{2}$");
    final RegExp i = RegExp(r"^\*{1}(([\S^\*].*)?[\S^\*])\*{1}$");
    final RegExp a = RegExp(r"^\[([^\s\*].*[^\s]?)?\]\(([^\s\*]+)?\)$");
    final RegExp img = RegExp(r"^\!\[([^\s].*[^\s]?)?\]\(([^\s]+)\)$");
    final RegExp ul = RegExp(r"^(\-)\s([^\n]+)$");
    final RegExp ol = RegExp(r"^([0-9]+.)\s([^\n]+)$");
    final RegExp rb = RegExp(r"^\((\x?)\)\s(\S.*)$");
    final RegExp cb = RegExp(r"^\[(\x?)\]\s(\S.*)$");
    final RegExp hr = RegExp(r"^(--)[-]+$");
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
        // return const SizedBox();
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
    if (h.hasMatch(exp)) {
      var match = h.firstMatch(exp.trim());
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TexText(
                  "${match?[2]}",
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
                  ][match![1]!.length - 1],
                ),
              ),
            ],
          ),
          if (match[1]!.length == 1) const Divider(height: 6),
        ],
      );
    }
    if (hr.hasMatch(exp)) {
      return const Divider(
        height: 5,
      );
    }
    if (cb.hasMatch(exp)) {
      var match = cb.firstMatch(exp.trim());
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
    if (rb.hasMatch(exp)) {
      var match = rb.firstMatch(exp.trim());
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
    if (ul.hasMatch(exp)) {
      var match = ul.firstMatch(exp.trim());
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
    if (ol.hasMatch(exp)) {
      var match = ol.firstMatch(exp.trim());
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
    if (b.hasMatch(exp)) {
      var match = b.firstMatch(exp.trim());
      return TexText(
        "${match?[1]}",
        style: style?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    if (i.hasMatch(exp)) {
      var match = i.firstMatch(exp.trim());
      return TexText(
        "${match?[1]}",
        style:
            (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
      );
    }
    if (a.hasMatch(exp)) {
      var match = a.firstMatch(exp.trim());
      if (match?[1] == null && match?[2] == null) {
        return const SizedBox();
      }
      return GestureDetector(
        onTap: () {
          if (onLinkTab == null) {
            return;
          }
          onLinkTab!("${match?[2]}", "${match?[1]}");
        },
        child: MdWidget(
          "${match?[1]}",
          onLinkTab: onLinkTab,
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
    List<String> expL = exp.split('\n');
    // .map(
    //   (e) => e.trim(),
    // )
    // .toList();
    bool hasMatch = false;

    for (final each in expL) {
      if (a.hasMatch(each) ||
          b.hasMatch(each) ||
          i.hasMatch(each) ||
          h.hasMatch(each) ||
          hr.hasMatch(each) ||
          ol.hasMatch(each) ||
          rb.hasMatch(each) ||
          cb.hasMatch(each) ||
          img.hasMatch(each) ||
          ul.hasMatch(each)) {
        hasMatch = true;
      }
    }
    if (hasMatch) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: exp
            .split("\n")
            .map<Widget>((e) => MdWidget(
                  e,
                  onLinkTab: onLinkTab,
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
