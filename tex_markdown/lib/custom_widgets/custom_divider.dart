import 'package:flutter/material.dart';

class CustomDivider extends LeafRenderObjectWidget {
  const CustomDivider({super.key, this.height, this.color});
  final Color? color;
  final double? height;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDivider(color ?? Theme.of(context).colorScheme.outline,
        MediaQuery.of(context).size.width, height ?? 2);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderDivider renderObject) {
    renderObject.color = color ?? Theme.of(context).colorScheme.outline;
    renderObject.height = height ?? 2;
    renderObject.width = MediaQuery.of(context).size.width;
  }
}

class RenderDivider extends RenderBox {
  RenderDivider(Color color, double width, double height)
      : _color = color,
        _height = height,
        _width = width;
  Color _color;
  double _height;
  double _width;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  set height(double value) {
    if (value == _height) {
      return;
    }
    _height = value;
    markNeedsLayout();
  }

  set width(double value) {
    if (value == _width) {
      return;
    }
    _width = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: null, height: _height)
        .enforce(constraints)
        .smallest;
  }

  @override
  void performLayout() {
    size = getDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(offset & Size(Rect.largest.size.width, _height),
        Paint()..color = _color);
  }
}
