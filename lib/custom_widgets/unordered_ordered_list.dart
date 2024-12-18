import 'package:flutter/material.dart';

class UnorderedListView extends StatelessWidget {
  const UnorderedListView({
    super.key,
    this.spacing = 8,
    this.padding = 12,
    this.bulletColor,
    this.bulletSize = 4,
    this.textDirection = TextDirection.ltr,
    required this.child,
  });
  final double bulletSize;
  final double spacing;
  final double padding;
  final TextDirection textDirection;
  final Color? bulletColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          if (bulletSize == 0)
            SizedBox(
              width: spacing + padding,
            )
          else
            Text.rich(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.only(start: padding, end: spacing),
                  child: Container(
                    width: bulletSize,
                    height: bulletSize,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class OrderedListView extends StatelessWidget {
  final String no;
  final double spacing;
  final double padding;
  const OrderedListView(
      {super.key,
      this.spacing = 6,
      this.padding = 10,
      TextStyle? style,
      required this.child,
      this.textDirection = TextDirection.ltr,
      required this.no})
      : _style = style;
  final TextStyle? _style;
  final TextDirection textDirection;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: padding, end: spacing),
            child: Text.rich(
              TextSpan(
                text: no,
              ),
              style: _style,
            ),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
