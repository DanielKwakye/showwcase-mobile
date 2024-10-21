import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:showwcase_v3/core/utils/constants.dart';

class CustomCodeHighlighterWidget extends StatelessWidget {
  final String code;
  final String language;
  const CustomCodeHighlighterWidget({required this.code, required this.language, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  HighlightView(


      // The original code to be highlighted
      code,

      // Specify language
      // It is recommended to give it a value for performance
      language:  language.toLowerCase(),

      // Specify highlight theme
      // All available themes are listed in `themes` folder
      theme: codeTheme,

      // Specify padding
      padding: const EdgeInsets.all(12),


      // // Specify text style
      textStyle: const TextStyle(
        fontSize: defaultFontSize,
      ),
    );
  }
}
