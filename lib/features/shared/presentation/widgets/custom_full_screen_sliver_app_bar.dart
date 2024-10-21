import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';

import 'custom_border_widget.dart';

class CustomFullScreenDialogSliverAppBar extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final bool showCloseButton;
  const CustomFullScreenDialogSliverAppBar({required this.title,
    this.backgroundColor,
    this.showCloseButton = true,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      elevation: 0,
      actions: [
        if(showCloseButton) ...{
          const CloseButton()
         }

      ],
      title: Text(title, style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize),),
      iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      automaticallyImplyLeading: false,
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: CustomBorderWidget()
      ),
    );

  }
}
