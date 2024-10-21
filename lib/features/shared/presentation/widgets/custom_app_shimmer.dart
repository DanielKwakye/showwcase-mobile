import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// This can be used just like a circular progress indicator
/// By default, each shimmer has 2 bars and a circular avatar on the left just like ListTile with leading, title and subtitle
class CustomAppShimmer extends StatelessWidget {

  /// repeat: The number of times each shimmer should be repeated
  final int repeat;
  final double? firstBarHeight;
  final double? secondBarHeight;
  final bool showFirstBar;
  final bool showSecondBar;
  final bool showLeadingCircularAvatar;
  final double firsBarWidthFactor; /// width Factor should be on a scale of 0 to 1 eg. 0.1, 0.2 ... 1
  final double secondBarWidthFactor; /// width Factor should be on a scale of 0 to 1 eg. 0.1, 0.2 ... 1
  final double firstBarBorderRadius;
  final double secondBarBorderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomAppShimmer({Key? key,
    this.repeat = 3,
    this.firstBarHeight = 10,
    this.secondBarHeight = 10,
    this.showFirstBar = true,
    this.showSecondBar = true,
    this.showLeadingCircularAvatar = true,
    this.firsBarWidthFactor =  0.7,
    this.secondBarWidthFactor = 1,
    this.firstBarBorderRadius = 1000,
    this.secondBarBorderRadius = 1000,
    this.contentPadding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    // const Color(0xffF7F7F7)
    final EdgeInsetsGeometry _contentPadding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.outline,
      highlightColor: theme.colorScheme.outline.withOpacity(0.3),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            runSpacing: 20, // to apply margin in the cross axis of the wrap
            children: <Widget>[

              for(int i = 0; i < repeat; i++)
                Padding(
                  padding: _contentPadding,
                  child: Row(
                     children: [
                       if(showLeadingCircularAvatar)  ... {
                         CircleAvatar(backgroundColor: theme.colorScheme.outline,),
                         const SizedBox(width: 15,)
                       },
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(showFirstBar) ... {
                              FractionallySizedBox(
                                  widthFactor: firsBarWidthFactor,
                                  child: Container(
                                    margin:  EdgeInsets.only(bottom: showSecondBar ? 10 : 0),
                                    height: firstBarHeight,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(firstBarBorderRadius),
                                        color:  theme.colorScheme.outline
                                    ),
                                  )
                              )
                            },
                            if(showSecondBar) ... {
                            FractionallySizedBox(
                                widthFactor: secondBarWidthFactor,
                                child: Container(
                                  height: secondBarHeight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          secondBarBorderRadius),
                                      color: theme.colorScheme.outline),
                                ))
                          }

                          ],
                       ))
                     ],
                  ),
                )
                // ListTile(
                //   visualDensity: const VisualDensity(vertical: -2,),
                //   contentPadding: contentPadding,
                //   leading: showLeadingCircularAvatar ? CircleAvatar(backgroundColor: theme.colorScheme.outline,) : null,
                //   title: showFirstBar ? Align(
                //     alignment: Alignment.centerLeft,
                //     child:,
                //   ): null,
                //   subtitle:  ? Align(
                //     alignment: Alignment.centerLeft,
                //     child: ,
                //   ) : null,
                // ),

            ],
          ),
        ),
      ),
    );
  }
}
