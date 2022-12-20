library tex_markdown;

import 'package:flutter/material.dart';

import 'md_widget.dart';

/// This widget create a full markdown widget as a column view.
class TexMarkdown extends StatelessWidget {
  const TexMarkdown(
    this.data, {
    super.key,
    this.style,
    this.followLinkColor = false,
    this.onLinkTab,
  });
  final String data;
  final TextStyle? style;
  final Function(String url, String title)? onLinkTab;
  final bool followLinkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data
          .split("\n\n")
          .map<Widget>(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: MdWidget(
                e,
                style: style,
                followLinkColor: followLinkColor,
                onLinkTab: onLinkTab,
              ),
            ),
          )
          .toList(),
    );
  }
}
