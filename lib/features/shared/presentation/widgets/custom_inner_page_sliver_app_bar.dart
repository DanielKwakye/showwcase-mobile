import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class CustomInnerPageSliverAppBar extends StatelessWidget{

  final String? pageTitle;
  final bool pinned;
  final List<Widget>? actions ;
  final Color? backgroundColor;
  final Widget? threadCreationIndicatorWidget;
  final bool showBorder;
  final bool showStatelessBorder;
  final Widget? leading;

  const CustomInnerPageSliverAppBar({Key? key,
    this.backgroundColor,
    this.pinned = true,
    this.showBorder = true,
    this.showStatelessBorder = false,
    this.threadCreationIndicatorWidget,
    this.leading,
    this.pageTitle, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
      pinned: pinned,
      elevation: 0.0,
      floating: !pinned ? true : false,
      centerTitle: true,
      leading: leading,
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      title: Text(pageTitle ?? "",  style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700,fontSize: defaultFontSize ),),
      expandedHeight: kToolbarHeight,
      bottom: showBorder ? (showStatelessBorder ? const PreferredSize(preferredSize: Size.fromHeight(2), child:  CustomBorderWidget()) : const PreferredSize(
          preferredSize:   Size.fromHeight(2),
          child: CustomBorderWidget()
      )) : null,
      actions: actions,
    );

  }



}
