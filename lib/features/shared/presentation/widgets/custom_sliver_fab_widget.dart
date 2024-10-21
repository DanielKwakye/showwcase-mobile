import 'package:flutter/material.dart';

/// A helper class if you want a FloatingActionButton to be pinned in the FlexibleAppBar
class SliverFabWidget extends StatefulWidget {
  ///List of header slivers placed in CustomScrollView
  final List<Widget> headerSlivers;

  ///List of body slivers placed in CustomScrollView
  final Widget? body;

  ///FloatingActionButton placed on the edge of FlexibleAppBar and rest of view
  final Widget? floatingWidget;

  ///Expanded height of FlexibleAppBar
  final double? expandedHeight;

  ///Number of pixels from top from which the [floatingWidget] should start shrinking.
  ///E.g. If your SliverAppBar is pinned, I would recommend this leaving as default 96.0
  ///     If you want [floatingActionButton] to shrink earlier, increase the value.
  final double? topScalingEdge;

  ///Position of the widget.
  final FloatingPosition? floatingPosition;

  final ScrollController? controller;

  SliverFabWidget({
    Key? key,
    required this.headerSlivers,
    this.body,
    required this.floatingWidget,
    this.floatingPosition = const FloatingPosition(left: 8.0),
    this.expandedHeight = 256.0,
    this.topScalingEdge = 96.0,
    this.controller
  }) : super(key: key) {
    assert(floatingWidget != null);
    assert(floatingPosition != null);
    assert(expandedHeight != null);
    assert(topScalingEdge != null);
  }

  @override
  State<StatefulWidget> createState() {
    return SliverFabWidgetState();
  }
}

class SliverFabWidgetState extends State<SliverFabWidget> {

  // late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(() {
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          NestedScrollView(
              controller: widget.controller,
              headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
                return widget.headerSlivers;
              }, body: widget.body ?? const SizedBox.shrink()
          ),
          _buildFab(),
        ]
    );
    // return Stack(
    //   children: <Widget>[
    //     CustomScrollView(
    //       controller: widget.scrollController,
    //       slivers: widget.slivers,
    //     ),
    //     _buildFab(),
    //   ],
    // );
  }

  Widget _buildFab() {
    const double defaultFabSize = 56.0;
    final double paddingTop = MediaQuery.of(context).padding.top;
    final double defaultTopMargin = widget.expandedHeight! + paddingTop + (widget.floatingPosition?.top ?? 0) -
        defaultFabSize / 2;

    final double scale0edge = widget.expandedHeight! - kToolbarHeight;
    final double scale1edge = defaultTopMargin - widget.topScalingEdge!;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (widget.controller != null && widget.controller!.hasClients) {
      double offset = widget.controller!.offset;
      top -= offset > 0 ? offset : 0;
      if (offset < scale1edge) {
        scale = 1.0;
      } else if (offset > scale0edge) {
        scale = 0.0;
      } else {
        scale = (scale0edge - offset) / (scale0edge - scale1edge);
      }
    }

    return Positioned(
      top: top,
      right: widget.floatingPosition?.right,
      left: widget.floatingPosition?.left,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: widget.floatingWidget,
      ),
    );
  }
}

///A class representing position of the widget.
///At least one value should be not null
class FloatingPosition {
  ///Can be negative. Represents how much should you change the default position.
  ///E.g. if your widget is bigger than normal [FloatingActionButton] by 20 pixels,
  ///you can set it to -10 to make it stick to the edge
  final double? top;

  ///Margin from the right. Should be positive.
  ///The widget will stretch if both [right] and [left] are not nulls.
  final double? right;

  ///Margin from the left. Should be positive.
  ///The widget will stretch if both [right] and [left] are not nulls.
  final double? left;

  const FloatingPosition({this.top, this.right, this.left});
}
