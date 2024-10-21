import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedBoxAdapter extends SingleChildRenderObjectWidget {

  final Widget widget;

  const SliverPinnedBoxAdapter({
    required this.widget,
    Key? key,
  }) : super(key: key, child: widget);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverPinnedBoxAdapter();
  }


}

class _RenderSliverPinnedBoxAdapter extends RenderSliverSingleBoxAdapter {
  _RenderSliverPinnedBoxAdapter({RenderBox? child}) : super(child: child);
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    child?.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final double paintedChildSize =
    calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
    calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: childExtent,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
      paintOrigin: constraints.overlap,
      visible: true,
    );
  }


  @override
  double childMainAxisPosition(RenderBox child) => constraints.overlap;

}