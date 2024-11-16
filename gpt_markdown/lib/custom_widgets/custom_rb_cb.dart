import 'package:flutter/material.dart';

class CustomRb extends StatelessWidget {
  const CustomRb({
    super.key,
    this.spacing = 5,
    required this.child,
    this.textDirection = TextDirection.ltr,
    required this.value,
  });
  final Widget child;
  final bool value;
  final double spacing;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text.rich(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding:
                    EdgeInsetsDirectional.only(start: spacing, end: spacing),
                child: Radio(
                  value: value,
                  groupValue: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) {},
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

class CustomCb extends StatelessWidget {
  const CustomCb({
    super.key,
    this.spacing = 5,
    required this.child,
    this.textDirection = TextDirection.ltr,
    required this.value,
  });
  final Widget child;
  final bool value;
  final double spacing;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text.rich(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding:
                    EdgeInsetsDirectional.only(start: spacing, end: spacing),
                child: Checkbox(value: value, onChanged: (value) {}),
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
