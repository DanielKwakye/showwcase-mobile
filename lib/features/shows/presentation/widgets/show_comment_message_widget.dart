import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowCommentMessageWidget extends StatefulWidget {

  final String message;
  final ShowModel showModel;
  const ShowCommentMessageWidget({Key? key, required this.message, required this.showModel}) : super(key: key);

  @override
  ShowCommentMessageWidgetController createState() => ShowCommentMessageWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowCommentMessageWidgetView extends WidgetView<ShowCommentMessageWidget, ShowCommentMessageWidgetController> {

  const _ShowCommentMessageWidgetView(ShowCommentMessageWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
//
    final style = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        height: defaultLineHeight,
        fontSize: defaultFontSize,
        color: theme.colorScheme.onBackground);

    final text = state.unescape.convert(widget.message ?? '');

    return RichText(
      text: TextSpan(
        children: [...state._parseText(text, style, theme)],
        style: style,
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowCommentMessageWidgetController extends State<ShowCommentMessageWidget> {

  final unescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) => _ShowCommentMessageWidgetView(this);

  @override
  void initState() {
    super.initState();
  }

  List<InlineSpan> _parseText(String text, TextStyle style, ThemeData theme, {String? codeLanguage}) {

    List<InlineSpan> textSpans = [];

    List<Pattern> patterns = [
      // Pattern(
      //   regex: r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b',
      //   style: widget.style.copyWith(color: kAppBlue),
      //   onTap: (email) {
      //     debugPrint('email tapped email');
      //   },
      // ),

      /// url patterns
      Pattern(
        tag: 'url',
        regex: r'https?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?',
        style: style.copyWith(color: kAppBlue),
        onTap: (url) {
          debugPrint('url tapped $url');
          context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
            "url": url,
            "show": widget.showModel
          });
          // launchBrowser(url, context);
        },
      ),

      /// community pattern r"(?:^\b|)(c/[a-z0-9-]+)"
      Pattern(
        tag: 'community',
        regex: r"(?:^\b|)(c/[a-z0-9-]+)",
        style: style.copyWith(color: kAppBlue),
        onTap: (community) {
          debugPrint('community tapped $community');
          if(community.startsWith('c/')){
            community = community.substring(2);
          }
          final url = "https://www.showwcase.com/community/${community.toLowerCase()}";
          context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
            "url": url,
            "show": widget.showModel
          });
          // launchBrowser(url, context);
        },
      ),

      /// mentions pattern r"(?:^\b|)(u/[a-z0-9-]+)"
      Pattern(
        tag: 'mention',
        regex: r"(?:^\b|)(u/[a-z0-9-]+)",
        style: style.copyWith(color: kAppBlue),
        onTap: (mention) {
          debugPrint('mentions tapped $mention');
          if(mention.startsWith('u/')){
            mention = mention.substring(2);
          }
          final url = "https://www.showwcase.com/${mention.toLowerCase()}";
          // launchBrowser(url, context);
          context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
            "url": url,
            "show": widget.showModel
          });
        },
      ),

      /// Cash tagging pattern
      Pattern(
        tag: 'cashTag',
        regex: r"(^|\s)\$([a-z\d-]+)",
        style: style.copyWith(color: kAppBlue),
        onTap: (word) {
          debugPrint('cashTag tapped $word');
          // changeScreenWithConstructor(context, SearchPage(searchText: word.toLowerCase(),));
        },
      ),

      /// Hash tagging pattern
      Pattern(
        tag: 'hashTag',
        regex: r"(^|\s)#([a-z\d-]+)",
        style: style.copyWith(color: kAppBlue),
        onTap: (word) {
          debugPrint('hashTag tapped $word');
          // changeScreenWithConstructor(context, SearchPage(searchText: word.toLowerCase(),));
        },
      ),

      /// -------------------------- Markdown patterns ----------------------------------- ///

      /// Check for headers
      Pattern(
        tag: 'md:header',
        regex: r'^(#{1,6})\s(.*)$',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown header1 tapped $word');
        },
      ),

      /// Check for emphasis and strong emphasis
      Pattern(
        tag: 'md:emphasis',
        regex: r'(\*\*|__|\*|_)(.*?)\1',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown emphasis tapped $word');
        },
      ),

      /// Check for lists
      Pattern(
        tag: 'md:list',
        regex: r'^(\s*)(-|\d\.)\s(.*)$',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown lists tapped $word');
        },
      ),

      /// Check for links
      Pattern(
        tag: 'md:link',
        regex: r'/\[([^\[]+)\]\(([^\)]+)\)/',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown link tapped $word');
          context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
            "url": word,
            "show": widget.showModel
          });
        },
      ),

      /// Check for images
      Pattern(
        tag: 'md:image',
        regex: r'!\[(.*?)\]\((.*?)\)',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown image tapped $word');
        },
      ),

      /// Check for blockquotes
      Pattern(
        tag: 'md:blockquotes',
        regex: r'^>\s(.*)$',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown blockquotes tapped $word');
        },
      ),

      /// Check for inline code
      Pattern(
        tag: 'md:inlineCode',
        regex: r'`([^`]+)`',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown inlineCode tapped $word');
        },
      ),

      /// Check for horizontal rule
      Pattern(
        tag: 'md:horizontalRule',
        regex: r'^[-_*]{3,}$',
        style: style,
        multiLine: true,
        caseInsensitive: true,
        onTap: (word) {
          debugPrint('markdown horizontalRule tapped $word');
        },
      ),

      /// Check for Code Block
      Pattern(
        tag: 'md:codeBlock',
        regex: r"```[\s\S]*?```",
        style: style,
        onTap: (word) {
          debugPrint('codeBlock tapped $word');
        },
      ),



    ];

    String remainingText = text.trim();



    while (remainingText.isNotEmpty) {
      int minStart = remainingText.length;
      Pattern? selectedPattern;
      Match? selectedMatch;

      for (final pattern in patterns) {
        RegExp regExp = RegExp(pattern.regex, multiLine: pattern.multiLine, caseSensitive: pattern.caseInsensitive);
        Match? match = regExp.firstMatch(remainingText);

        if (match != null && match.start < minStart) {
          minStart = match.start;
          selectedPattern = pattern;
          selectedMatch = match;
        }
      }

      if (selectedPattern != null && selectedMatch != null) {
        int start = selectedMatch.start;
        int end = selectedMatch.end;

        String match = remainingText.substring(start, end);

        textSpans.add(TextSpan(text: remainingText.substring(0, start)));

        // [1, 2] are the positions of c/ and u/ in the patterns array
        String modifiedText = match;
        if(['community', 'mention'].contains(selectedPattern.tag)){
          modifiedText = match.substring(2);
        }
        if('md:codeBlock' == selectedPattern.tag){
          modifiedText = stripQuotesFromCodeBlock(match);
        }

        textSpans.add(TextSpan(
          text:  modifiedText,
          style: selectedPattern.style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              selectedPattern?.onTap(match);
            },
        ));

        remainingText = remainingText.substring(end);

      } else {
        textSpans.add(TextSpan(text: remainingText));
        remainingText = '';
      }
    }

    return textSpans;
  }

  String stripQuotesFromCodeBlock(String codeBlock) {
    // Match the opening and closing markers of the code block.
    RegExp codeBlockPattern = RegExp(r"```[\s\S]*?```");
    Match? match = codeBlockPattern.firstMatch(codeBlock);

    if (match != null) {
      // Remove the opening and closing markers from the code block.
      String code = match.group(0)!;
      code = code.substring(3, code.length - 3);
      return code.trim();
    } else {
      return codeBlock;
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

}

// import 'package:flutter/material.dart';
// import 'package:showwcase_v3/core/utils/constants.dart';
//
// class ShowCommentMessageWidget extends StatelessWidget {
//
//   final String message;
//   const ShowCommentMessageWidget({Key? key, required this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//
//     final style = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
//         height: defaultLineHeight,
//         fontSize: defaultFontSize,
//         color: theme.colorScheme.onBackground);
//
//
//     return const Placeholder();
//   }
// }

class Pattern {
  final String regex;
  final TextStyle style;
  final String tag;
  bool multiLine;
  bool caseInsensitive;
  final Function(String) onTap;

  Pattern({required this.tag, required this.regex, required this.style, required this.onTap, this.multiLine = false, this.caseInsensitive = true});
}