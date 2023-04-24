import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum CustomRbSlot {
  rb,
  child,
}

class CustomRb extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<CustomRbSlot> {
  const CustomRb(
      {super.key, this.spacing = 5, required this.child, required this.value});
  final Widget child;
  final bool value;
  final double spacing;

  @override
  Widget? childForSlot(CustomRbSlot slot) {
    switch (slot) {
      case CustomRbSlot.rb:
        return Radio(
          value: value,
          groupValue: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) {},
        );
      case CustomRbSlot.child:
        return child;
    }
  }

  @override
  SlottedContainerRenderObjectMixin<CustomRbSlot> createRenderObject(
      BuildContext context) {
    return RenderCustomRb(spacing);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomRb renderObject) {
    renderObject.spacing = spacing;
  }

  @override
  Iterable<CustomRbSlot> get slots => CustomRbSlot.values;
}

class RenderCustomRb extends RenderBox
    with SlottedContainerRenderObjectMixin<CustomRbSlot> {
  RenderCustomRb(this._spacing);
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  RenderBox? get rb => childForSlot(CustomRbSlot.rb);
  RenderBox? get body => childForSlot(CustomRbSlot.child);

  Size _layoutBox(RenderBox box, BoxConstraints constraints) {
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  @override
  void performLayout() {
    if (rb == null || body == null) {
      size = constraints.constrain(const Size(50, 10));
      return;
    }
    rb;
    Size rbSize =
        _layoutBox(rb!, const BoxConstraints(maxWidth: 50, maxHeight: 20));
    Size bodySize = _layoutBox(
        body!,
        BoxConstraints(
            maxWidth: constraints.maxWidth - rbSize.width - _spacing));
    body!.parentData = BoxParentData()
      ..offset = Offset(rbSize.width + _spacing, 0);
    rb!.parentData = BoxParentData()
      ..offset = Offset(
        0,
        body!.computeDistanceToActualBaseline(TextBaseline.alphabetic)! -
            rb!.size.height / 1.5,
      );
    size = constraints.constrain(Size(bodySize.width + rbSize.width + _spacing,
        max(rbSize.height, bodySize.height)));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(
        body!, offset + (body!.parentData as BoxParentData).offset);
    context.paintChild(rb!, offset + (rb!.parentData as BoxParentData).offset);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}

enum CustomCbSlot {
  cb,
  child,
}

class CustomCb extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<CustomCbSlot> {
  const CustomCb(
      {super.key, this.spacing = 5, required this.child, required this.value});
  final Widget child;
  final bool value;
  final double spacing;

  @override
  Widget? childForSlot(CustomCbSlot slot) {
    switch (slot) {
      case CustomCbSlot.cb:
        return Checkbox(value: value, onChanged: (value) {});
      case CustomCbSlot.child:
        return child;
    }
  }

  @override
  SlottedContainerRenderObjectMixin<CustomCbSlot> createRenderObject(
      BuildContext context) {
    return RenderCustomCb(spacing);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomCb renderObject) {
    renderObject.spacing = spacing;
  }

  @override
  Iterable<CustomCbSlot> get slots => CustomCbSlot.values;
}

class RenderCustomCb extends RenderBox
    with SlottedContainerRenderObjectMixin<CustomCbSlot> {
  RenderCustomCb(this._spacing);
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  RenderBox? get rb => childForSlot(CustomCbSlot.cb);
  RenderBox? get body => childForSlot(CustomCbSlot.child);

  Size _layoutBox(RenderBox box, BoxConstraints constraints) {
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  @override
  void performLayout() {
    if (rb == null || body == null) {
      size = constraints.constrain(const Size(50, 10));
      return;
    }
    rb;
    Size rbSize =
        _layoutBox(rb!, const BoxConstraints(maxWidth: 50, maxHeight: 20));
    Size bodySize = _layoutBox(
        body!,
        BoxConstraints(
            maxWidth: constraints.maxWidth - rbSize.width - _spacing));
    body!.parentData = BoxParentData()
      ..offset = Offset(rbSize.width + _spacing, 0);
    rb!.parentData = BoxParentData()
      ..offset = Offset(
          0,
          body!.computeDistanceToActualBaseline(TextBaseline.alphabetic)! -
              rb!.size.height / 1.5);
    size = constraints.constrain(Size(bodySize.width + rbSize.width + _spacing,
        max(rbSize.height, bodySize.height)));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(
        body!, offset + (body!.parentData as BoxParentData).offset);
    context.paintChild(rb!, offset + (rb!.parentData as BoxParentData).offset);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
