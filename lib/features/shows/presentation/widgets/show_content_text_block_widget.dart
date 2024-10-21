import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shows/data/models/blocks/show_text_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';

import '../../../../core/utils/theme.dart';

class ShowContentTextBlockWidget extends StatelessWidget {
  final ShowBlockModel block;
  const ShowContentTextBlockWidget({required this.block, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(block.textBlock?.value == null) {
      return const  SizedBox.shrink();
    }

    final theme = Theme.of(context);

    final ShowTextBlockModel textBlock = block.textBlock!;

    final style = textBlock.style;
    final text = parseHtmlString(textBlock.value ?? '');

    if(text.isNullOrEmpty()){
      return const SizedBox.shrink();
    }

    const normalStyle =  TextStyle(
        fontWeight: FontWeight.normal,
        height: defaultLineHeight
    );

    switch(style) {
      case 1: // Normal
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(text!, style: theme.textTheme.bodyLarge?.copyWith(fontSize: defaultFontSize + 2, height: 1.6),),
        );
        break;
      case 2: // heading1
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(text!, style: theme.textTheme.titleLarge?.copyWith( fontWeight: FontWeight.bold),),
        );
      case 3: // heading2
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(text!, style: theme.textTheme.titleMedium?.copyWith( fontWeight: FontWeight.bold),),
        );
      case 4: // heading3
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(text!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold,),),
        );
      case 5: // bullet point
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: RichText(text:  TextSpan(text: '', children: [
            TextSpan(text: "◉", style: theme.textTheme.bodyLarge?.copyWith(color: kAppBlue)),
            TextSpan(text: "  ", style: theme.textTheme.bodyLarge),
            TextSpan(text: text!, style: theme.textTheme.bodyLarge?.copyWith(fontSize: defaultFontSize + 2, height: 1.6)),
          ])),
        );
    // return '&nbsp;&nbsp; $text';
      case 6: // Numbered
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: RichText(text:  TextSpan(text: '', children: [
            TextSpan(text: textBlock.numberedCount?.toString(), style: theme.textTheme.bodyLarge),
            TextSpan(text: "  ", style: theme.textTheme.bodyLarge),
            TextSpan(text: text!, style: theme.textTheme.bodyLarge?.copyWith(fontSize: defaultFontSize , height: 1.6)),
          ])),
        );
      case 7: // Quote
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  color: kAppBlue,
                ),
                const SizedBox(width: 10,),
                Expanded(child: Text(text!, style: theme.textTheme.bodyLarge?.copyWith(fontSize: defaultFontSize + 2,),))

              ],
            ),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(text!, style: theme.textTheme.bodyLarge,),
        );
    }

    return const SizedBox.shrink();

    // styling here /////

    // var formattedHTMLString = _convertToHTMLString(textBlock.style, textBlock.value!);

    // return Html(
    //   data: formattedHTMLString,
    //   style: {
    //     "p": normalStyle.copyWith(),
    //     "li": normalStyle.copyWith()
    //   },
    //
    //   onLinkTap: (String? url, RenderContext ctx, Map<String, String> attributes,  element) {
    //     //open URL in webview, or launch URL in browser, or any other logic here
    //       if(url != null){
    //           launchBrowser(url, context);
    //       }
    //   }
    // );



  }



}
