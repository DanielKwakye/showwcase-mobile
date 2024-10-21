import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SliverAppBarTabBarDelegate extends SliverPersistentHeaderDelegate {

  SliverAppBarTabBarDelegate({
    required this.tabBar,
    this.expandedHeight,
    this.padding,
    this.backgroundColor,
    this.blurredBackground = false

  });

  final TabBar tabBar;
  final double? expandedHeight;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool blurredBackground;

  @override
  double get minExtent => expandedHeight ?? tabBar.preferredSize.height;
  @override
  double get maxExtent => expandedHeight ?? tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    // return tabBar;

    return ValueListenableBuilder<AdaptiveThemeMode>(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (ctx, AdaptiveThemeMode mode, ch) {
        final theme = Theme.of(ctx);
        // update your UI
        if(blurredBackground) {
          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: theme.colorScheme.background.withAlpha(200),
                    border: Border(
                        bottom:
                        BorderSide(color: theme.colorScheme.outline))
                ),
                child: ch,
              ),
            ),
          );
        }

        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.background,
              border: Border(
                  bottom:
                  BorderSide(color: theme.colorScheme.outline))
          ),
          child: ch,
        );
      },
      child: tabBar,
    );


  }

  @override
  bool shouldRebuild(SliverAppBarTabBarDelegate oldDelegate) {
    return true;
  }
}