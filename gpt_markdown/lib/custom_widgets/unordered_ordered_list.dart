import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UnorderedListView extends SingleChildRenderObjectWidget {
  const UnorderedListView(
      {super.key,
      this.spacing = 6,
      this.padding = 10,
      this.bulletColor,
      this.bulletSize = 4,
      this.textDirection = TextDirection.ltr,
      required super.child});
  final double bulletSize;
  final double spacing;
  final double padding;
  final TextDirection textDirection;
  final Color? bulletColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return UnorderedListRenderObject(
      spacing,
      padding,
      bulletColor ?? Theme.of(context).colorScheme.onSurface,
      textDirection,
      bulletSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant UnorderedListRenderObject renderObject) {
    renderObject.bulletColor =
        bulletColor ?? Theme.of(context).colorScheme.onSurface;
    renderObject.bulletSize = bulletSize;
    renderObject.spacing = spacing;
    renderObject.padding = padding;
    renderObject.textDirection = textDirection;
  }
}

class UnorderedListRenderObject extends RenderProxyBox {
  UnorderedListRenderObject(
    double spacing,
    double padding,
    Color bulletColor,
    TextDirection textDirection,
    this._bulletSize, {
    RenderBox? child,
  })  : _bulletColor = bulletColor,
        _spacing = spacing,
        _padding = padding,
        _textDirection = textDirection,
        super(child);
  double _spacing;
  double _padding;
  Offset _bulletOffset = Offset.zero;
  TextDirection _textDirection;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  set padding(double value) {
    if (_padding == value) {
      return;
    }
    _padding = value;
    markNeedsLayout();
  }

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  Color _bulletColor;
  double _bulletSize;
  set bulletSize(double value) {
    if (_bulletSize == value) {
      return;
    }
    _bulletSize = value;
    markNeedsLayout();
  }

  set bulletColor(Color value) {
    if (_bulletColor == value) {
      return;
    }
    _bulletColor = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    child!.layout(
        BoxConstraints(
          maxWidth:
              constraints.maxWidth - _spacing - 6 - _bulletSize - _padding,
        ),
        parentUsesSize: true);
    return child!.size.width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    child!.layout(
        BoxConstraints(
          maxWidth:
              constraints.maxWidth - _spacing - 6 - _bulletSize - _padding,
        ),
        parentUsesSize: true);
    return child!.size.width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    child!.layout(
        BoxConstraints(
          maxWidth:
              constraints.maxWidth - _spacing - 6 - _bulletSize - _padding,
        ),
        parentUsesSize: true);
    return child!.size.height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    child!.layout(
        BoxConstraints(
          maxWidth:
              constraints.maxWidth - _spacing - 6 - _bulletSize - _padding,
        ),
        parentUsesSize: true);
    return child!.size.height;
  }

  @override
  void performLayout() {
    super.performLayout();
    if (child == null) {
      return;
    }
    child!.layout(
        BoxConstraints(
          maxWidth:
              constraints.maxWidth - _spacing - 6 - _bulletSize - _padding,
        ),
        parentUsesSize: true);
    if (_textDirection == TextDirection.ltr) {
      child!.parentData = BoxParentData()
        ..offset = Offset(_spacing + _padding + 6 + _bulletSize, 0);
      var value =
          child!.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      _bulletOffset = Offset(4 + _padding, value! - _bulletSize);
    } else {
      child!.parentData = BoxParentData()
        ..offset = Offset(-_spacing - _padding + 6 + _bulletSize, 0);
      var value =
          child!.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      _bulletOffset =
          Offset(child!.size.width - 4 + _padding, value! - _bulletSize);
    }
    size = constraints.constrain(Size(
        child!.size.width + _spacing + _padding + 6 + _bulletSize,
        child!.size.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if (_textDirection == TextDirection.ltr) {
      context.paintChild(
          child!, offset + (child!.parentData as BoxParentData).offset);
      context.canvas.drawCircle(
          offset + _bulletOffset, _bulletSize, Paint()..color = _bulletColor);
    } else {
      context.paintChild(
          child!, offset + (child!.parentData as BoxParentData).offset);
      context.canvas.drawCircle(
          offset + _bulletOffset, _bulletSize, Paint()..color = _bulletColor);
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    Offset offset = (child!.parentData as BoxParentData).offset;
    return result.addWithPaintOffset(
      offset: offset,
      position: position,
      hitTest: (result, newOffset) {
        return child?.hitTest(result, position: newOffset) ?? false;
      },
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hitTestChildren(result, position: position);
  }
}

class OrderedListView extends SingleChildRenderObjectWidget {
  final String no;
  final double spacing;
  final double padding;
  const OrderedListView(
      {super.key,
      this.spacing = 6,
      this.padding = 10,
      TextStyle? style,
      required super.child,
      this.textDirection = TextDirection.ltr,
      required this.no})
      : _style = style;
  final TextStyle? _style;
  final TextDirection textDirection;

  TextStyle getStyle(BuildContext context) {
    if (_style == null || _style!.inherit) {
      return DefaultTextStyle.of(context).style.merge(_style);
    }
    return _style!;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return OrderedListRenderObject(
      no,
      spacing,
      padding,
      textDirection,
      getStyle(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant OrderedListRenderObject renderObject) {
    renderObject.no = no;
    renderObject.spacing = spacing;
    renderObject.padding = padding;
    renderObject.style = getStyle(context);
    renderObject.textDirection = textDirection;
  }
}

class OrderedListRenderObject extends RenderProxyBox {
  OrderedListRenderObject(
    String no,
    double spacing,
    double padding,
    TextDirection textDirection,
    TextStyle style, {
    RenderBox? child,
  })  : _no = no,
        _style = style,
        _spacing = spacing,
        _padding = padding,
        _textDirection = textDirection,
        super(child);
  double _spacing;
  double _padding;
  TextDirection _textDirection;
  Offset _ptOffset = Offset.zero;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  set padding(double value) {
    if (_padding == value) {
      return;
    }
    _padding = value;
    markNeedsLayout();
  }

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  TextStyle _style;
  set style(TextStyle value) {
    _style = value;
    markNeedsLayout();
  }

  String _no;
  set no(String value) {
    if (_no == value) {
      return;
    }
    _no = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    pt = TextPainter(
        text: TextSpan(
          text: _no,
          style: _style,
        ),
        textDirection: TextDirection.ltr);
    pt.layout(maxWidth: constraints.maxWidth - 50 - _spacing - _padding);
    return child!
        .computeMinIntrinsicHeight(width - pt.width - _spacing - _padding);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    pt = TextPainter(
        text: TextSpan(
          text: _no,
          style: _style,
        ),
        textDirection: TextDirection.ltr);
    pt.layout(maxWidth: constraints.maxWidth - 50 - _spacing - _padding);
    return child!
        .computeMaxIntrinsicHeight(width - pt.width - _spacing - _padding);
  }

  late TextPainter pt;
  @override
  void performLayout() {
    super.performLayout();
    if (child == null) {
      return;
    }
    pt = TextPainter(
        text: TextSpan(
          text: _no,
          style: _style,
        ),
        textDirection: TextDirection.ltr);
    pt.layout(maxWidth: constraints.maxWidth - 50 - _spacing - _padding);
    child!.layout(
        BoxConstraints(
          maxWidth: constraints.maxWidth - pt.width - _spacing - _padding,
        ),
        parentUsesSize: true);
    if (_textDirection == TextDirection.ltr) {
      child!.parentData = BoxParentData()
        ..offset = Offset(_spacing + _padding + pt.width, 0);
      var value =
          child!.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      _ptOffset = Offset(_padding,
          value! - pt.computeDistanceToActualBaseline(TextBaseline.alphabetic));
    } else {
      child!.parentData = BoxParentData()
        ..offset = Offset(-_spacing - _padding + pt.width, 0);
      var value =
          child!.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      _ptOffset = Offset(child!.size.width + _padding - 4,
          value! - pt.computeDistanceToActualBaseline(TextBaseline.alphabetic));
    }
    size = constraints.constrain(Size(
        child!.size.width + _spacing + _padding + pt.width,
        child!.size.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    context.paintChild(
      child!,
      offset + (child!.parentData as BoxParentData).offset,
    );
    pt.paint(context.canvas, offset + _ptOffset);
  }

  @override
  bool hitTestSelf(Offset position) {
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    Offset offset = (child!.parentData as BoxParentData).offset;
    return result.addWithPaintOffset(
      offset: offset,
      position: position,
      hitTest: (result, newOffset) {
        return child?.hitTest(result, position: newOffset) ?? false;
      },
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hitTestChildren(result, position: position);
  }
}
