import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_highlighter_widget.dart';

class CustomCodeViewWidget extends StatelessWidget {

  final String code;
  final String? codeLanguage;
  final String tag;
  final double borderRadius;
  final Function(String?, String?)? onTap; // code, language
  const CustomCodeViewWidget({
    required this.code,
    this.codeLanguage,
    required this.tag,
    this.borderRadius = 0.0,
    this.onTap,
    Key? key}) : super(key: key);


  /// feed actions
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: GestureDetector(
        onTap: () => onTap?.call(code, codeLanguage),
        // onTap: (){
        //   // changeScreenWithConstructor(context, CodePreviewPage(
        //   //     code: code, tag: tag,
        //   //     codeLanguage: codeLanguage
        //   // ), fullscreenDialog: true);
        // },
        child: Container(
          decoration:  BoxDecoration(
              color: (codeTheme['root'] as TextStyle).backgroundColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: (codeTheme['root'] as TextStyle).backgroundColor,
                padding: const EdgeInsets.only(left: 10,right: 0, top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(onPressed: (){
                          onTap?.call(code, codeLanguage);
                        },
                            icon: const Icon(Icons.expand, size: 14, color: kAppWhite,),
                            label: const Text('Expand',  style: TextStyle(color: kAppWhite, fontSize: defaultFontSize, fontWeight: FontWeight.normal)))
                      ],
                    ),
                    Row(
                      children: [
                        Text((codeLanguage ?? defaultCodeLanguage).capitalize(), style: const TextStyle(color: kAppWhite),),
                        IconButton(onPressed: () => copyTextToClipBoard(context, code), icon: SvgPicture.asset(kCopyIconSvg, color: kAppWhite,))
                      ],
                    )
                  ],
                ),
              ),
              const CustomBorderWidget(color: Color(0xff2C2C2C),),
              Container(
                constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    maxHeight: 300
                ),
                child: Hero(
                  tag: "code-$tag}",
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CustomCodeHighlighterWidget(code: code,
                        language: codeLanguage ?? defaultCodeLanguage
                    ),
                  ),
                )
              )


            ],
          ),

        ),
      ),
    );


  }

}
