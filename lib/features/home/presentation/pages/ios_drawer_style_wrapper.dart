import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/inner_drawer.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/home/presentation/pages/drawer_page.dart';

import '../../data/bloc/home_state.dart';

class IOSDrawerStyleWrapper extends StatefulWidget {

  final Widget page;
  final GlobalKey<InnerDrawerState> drawerKey;
  const IOSDrawerStyleWrapper({Key? key, required this.page,
    required this.drawerKey,
  }) : super(key: key);

  @override
  IOSDrawerWidgetController createState() => IOSDrawerWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _IOSDrawerWidgetView extends WidgetView<IOSDrawerStyleWrapper, IOSDrawerWidgetController> {

  const _IOSDrawerWidgetView(IOSDrawerWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return InnerDrawer(
        key: widget.drawerKey,
        onTapClose: true, // default false
        swipe: true, // default true
        // colorTransitionChild: Colors.red, // default Color.black54
        colorTransitionScaffold: theme.brightness == Brightness.light ? Colors.black26 : Colors.white10, // default Color.black54

        //When setting the vertical offset, be sure to use only top or bottom
        offset: const IDOffset.only(bottom: 0.00, right: 0.0, left: 0.7),

        scale: const IDOffset.horizontal( 1.0 ), // set the offset in both directions

        proportionalChildArea : true, // default true
        borderRadius: 0, // default 0
        leftAnimationType: InnerDrawerAnimation.linear, // default static
        rightAnimationType: InnerDrawerAnimation.linear,
        // backgroundDecoration: const BoxDecoration(color: Colors.red ), // default  Theme.of(context).backgroundColor

        //when a pointer that is in contact with the screen and moves to the right or left
        // onDragUpdate: (double val, InnerDrawerDirection? direction) {
        //   debugPrint("onDragUpdate: -> $val");
        // },
        // tapScaffoldEnabled: true,
        swipeChild: true,
        // velocity: 1,

        // innerDrawerCallback: (a) => debugPrint("innerDrawerCallback: $a"), // return  true (open) or false (close)
        leftChild: const DrawerPage(), // required if rightChild is not set

        //  A Scaffold is generally used but you are free to use other widgets
        // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
        //widget.page
        scaffold: widget.page
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class IOSDrawerWidgetController extends State<IOSDrawerStyleWrapper> {



  late HomeCubit homeCubit;
  late StreamSubscription<HomeState> homeStateStreamStreamSubscription;

  @override
  Widget build(BuildContext context) => _IOSDrawerWidgetView(this);

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    // homeStateStreamStreamSubscription = homeCubit.stream.listen((event) {
    //
    //   //! The tag is used to identify which drawer to open
    //   if(event.status == HomeStatus.onOpenDrawerRequestCompleted) {
    //
    //     if(mounted){
    //       widget.drawerKey.currentState?.open();
    //     }
    //
    //   }
    //
    //   //! The tag is used to identify which drawer to close
    //   if(event.status == HomeStatus.onCloseDrawerRequestCompleted){
    //     if(mounted){
    //       widget.drawerKey.currentState?.close();
    //     }
    //
    //   }
    // });

  }


  @override
  void dispose() {
    super.dispose();
  }

}
