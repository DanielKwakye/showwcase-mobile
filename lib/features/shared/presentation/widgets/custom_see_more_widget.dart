import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

import '../../../../core/utils/widget_view.dart';
// import 'package:html_unescape/html_unescape.dart';

class CustomSeeMoreWidget extends StatefulWidget {

  final String text;
  const CustomSeeMoreWidget({
    required this.text,
    Key? key}) : super(key: key);

  @override
  SharedSeeMoreWidgetController createState() => SharedSeeMoreWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SharedSeeMoreWidgetView extends WidgetView<CustomSeeMoreWidget, SharedSeeMoreWidgetController> {

  const _SharedSeeMoreWidgetView(SharedSeeMoreWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal);

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
          text: '',
          style: style,
          children: [
            ..._modifyText(context, state.text , style!),
            if (state.canTruncate && !state.shouldTruncate) ...{
              TextSpan(
                  text: "\nread less...",
                  recognizer: TapGestureRecognizer()
                    ..onTap = state._toggleToReadLess,
                  style: style.copyWith(
                      color: kAppBlue
                  ))
            }
          ]
      ),
    );

  }

  List<TextSpan> _modifyText(BuildContext context, String text,
      TextStyle style) {

    int countWordsInText = 0;

    final wordsWithBackSlashN = text.splitWithDelim(RegExp(r"\n"));

    final List<TextSpan> widgets = [];


    outerLoop:
    for (var word in wordsWithBackSlashN) {

      final wordsWithSpace = word.splitWithDelim(RegExp(r" "));

      innerLoop:
      for(var wbs in wordsWithSpace) {

        // If the number of words match the specified max words, break;
        if(state.canTruncate) {
          if(wbs != " "){
            countWordsInText = countWordsInText + 1;
            // if (word before space) is the last word return see more
            if(state.shouldTruncate && (countWordsInText == state.maxWords)) {
              widgets.add(TextSpan(
                  text: " read more...",
                  recognizer: TapGestureRecognizer()
                    ..onTap = state._toggleToReadMore,
                  style: style.copyWith(
                      color: kAppBlue
                  ))
              ) ;

              break innerLoop;
            }
          }
        }

        if(word != "\n"){
          widgets.add(TextSpan(text: wbs, style: style));
        }

      }

    }

    return widgets;
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SharedSeeMoreWidgetController extends State<CustomSeeMoreWidget> {

  final maxWords = 20;
  int totalWordsCount = 0;
  late bool canTruncate;
  late bool shouldTruncate;
  late String text;

  @override
  Widget build(BuildContext context) => _SharedSeeMoreWidgetView(this);

  @override
  void initState() {
    super.initState();

    final unescape = HtmlUnescape();
    text = unescape.convert(widget.text);
    text = text.replaceAll("\n", " ");
    text = text.trim().replaceAll(RegExp(r' \s+'), ' ');
    final regExp =  RegExp(r"[\w-]+");
    totalWordsCount = regExp.allMatches(text).length;
    canTruncate = totalWordsCount > maxWords;
    shouldTruncate = canTruncate;

  }


  @override
  void dispose() {
    super.dispose();
  }

  void _toggleToReadLess() {
    setState(() {
      shouldTruncate = true;
    });
  }

  void _toggleToReadMore() {
    setState(() {
      shouldTruncate = false;
    });
  }

}