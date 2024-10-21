import 'package:flutter/material.dart';

class DynamicSliverAppBar extends StatefulWidget {

  final Widget child;
  final Color? backgroundColor;
  final double toolbarHeight;
  final IconThemeData? iconTheme;
  final double? elevation;
  final bool pinned;
  final bool? centerTitle;
  final Widget? leading;
  final Widget? title;
  final double reduceBottomSpaceBy;

  const DynamicSliverAppBar({
    required this.child,
    this.backgroundColor,
    this.toolbarHeight = kToolbarHeight,
    this.iconTheme,
    this.elevation,
    this.pinned = false,
    this.centerTitle,
    this.leading,
    this.title,
    this.reduceBottomSpaceBy = 0,
    Key? key,
  }) : super(key: key);

  @override
  DynamicSliverAppBarState createState() => DynamicSliverAppBarState();
}

class DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  final GlobalKey _childKey = GlobalKey();
  bool isHeightCalculated = false;
  double? height;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        isHeightCalculated = true;
        final predictedHeight = (_childKey.currentContext?.findRenderObject() as RenderBox)
            .size
            .height;
        debugPrint("predictedHeight => $predictedHeight");
        setState(() {
          height = predictedHeight - widget.reduceBottomSpaceBy;
        });
      }
    });

    return SliverAppBar(
      expandedHeight: isHeightCalculated ? height : kToolbarHeight,
      backgroundColor: widget.backgroundColor,
      toolbarHeight: widget.toolbarHeight,
      iconTheme: widget.iconTheme,
      elevation: widget.elevation,
      pinned: widget.pinned,
      centerTitle: widget.centerTitle,
      leading:widget.leading,
      title: widget.title,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              key: _childKey,
              child: widget.child,
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}