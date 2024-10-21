import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadMessageWidget extends StatefulWidget {

  final ThreadModel threadModel;
  final int? maxLines;
  final Color? textColor;
  const ThreadMessageWidget({Key? key, required this.threadModel, this.maxLines, this.textColor}) : super(key: key);

  @override
  ThreadMessageWidgetController createState() => ThreadMessageWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadMessageWidgetView extends WidgetView<ThreadMessageWidget, ThreadMessageWidgetController> {

  const _ThreadMessageWidgetView(ThreadMessageWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final style = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        height: defaultLineHeight,
        fontSize: defaultFontSize,
        color: widget.textColor ?? Theme.of(context).colorScheme.onBackground);

    final htmlEscapedText = state.unescape.convert(widget.threadModel.message ?? '');
    final sRunes = htmlEscapedText.runes;
    final text = String.fromCharCodes(sRunes, 0, sRunes.length);

    if(widget.maxLines == null ) {
      return RichText(
        text: TextSpan(
          children: [...state._parseText(text, style, theme)],
          style: style,
        ),
      );
    }


    int maxCollapsedLines = widget.maxLines ?? 5; // Customize the number of lines before truncating

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            children: [...state._parseText(text, style, theme).where((element) => element is! WidgetSpan )],
            style: style,
          ),
          maxLines: state._isExpanded ? null : maxCollapsedLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isTruncated = textPainter.didExceedMaxLines;
        // const isTruncated = false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [...state._parseText(text, style, theme)],
                style: style,
              ),
              maxLines: state._isExpanded ? null : maxCollapsedLines,
              // overflow: TextOverflow.ellipsis,
            ),
            if(state._displaySeeLessButton || isTruncated)
              InkWell(
                onTap: state._toggleExpanded,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    state._isExpanded ? "read less ..." : "read more...",
                    style: style.copyWith(color: kAppBlue),
                  ),
                ),
              )
            ,
          ],
        );
      },
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadMessageWidgetController extends State<ThreadMessageWidget> {


  bool _isExpanded = false;
  bool _displaySeeLessButton = false;
  final unescape = HtmlUnescape();
  // late T _threadsCubit;

  void _toggleExpanded() {
    setState(() {
      _displaySeeLessButton = true;
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) => _ThreadMessageWidgetView(this);

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
          context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: threadBrowserPage, fallBackRoutePathData:  {
            "url": url,
            "thread": widget.threadModel
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
          context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: threadBrowserPage, fallBackRoutePathData:  {
            "url": url,
            "thread": widget.threadModel
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
          context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: threadBrowserPage, fallBackRoutePathData:  {
            "url": url,
            "thread": widget.threadModel
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
          context.push(context.generateRoutePath(subLocation: searchPage), extra: word.toLowerCase());
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
          context.push(context.generateRoutePath(subLocation: searchPage), extra: word.toLowerCase());
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
          context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
            "url": word,
            "thread": widget.threadModel
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
        // make the first letter capital for tags in this array
        if(['community'].contains(selectedPattern.tag)){
          modifiedText.capitalize();
        }
        if('md:codeBlock' == selectedPattern.tag){
          modifiedText = stripQuotesFromCodeBlock(match);
        }


        // special case for code blocks -----
        // if('md:codeBlock' == selectedPattern.tag) {
        //   textSpans.add(WidgetSpan(child:
        //   CustomCodeViewWidget(
        //     code: modifiedText,
        //     tag: modifiedText,
        //     codeLanguage: codeLanguage ?? defaultCodeLanguage,
        //     onTap: () {
        //       context.push(threadCodePreview, extra: {
        //         'thread': widget.threadModel,
        //         'code': widget.threadModel.code,
        //         'tag': widget.threadModel.id.toString()
        //       });
        //     },
        //   )
        //   ));
        // }
        // else if("md:header" == selectedPattern.tag) {
        //     RegExp regExp = RegExp(selectedPattern.regex, multiLine: selectedPattern.multiLine, caseSensitive: selectedPattern.caseInsensitive);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? headerLevel = regMatch?.group(1);
        //     String? headerText = regMatch?.group(2);
        //     // Match? headerLevel = regMatch.group(group);
        //     // final headerText = modifiedText.replaceAll(regExp, '');
        //     textSpans.add(TextSpan(
        //       text: headerText ?? '',
        //       style: style.copyWith(fontWeight: FontWeight.bold, fontSize: _getHeaderFontSize(style.fontSize ?? defaultFontSize, headerLevel?.length ?? 0))),
        //     );
        // }
        // else if("md:list" == selectedPattern.tag) {
        //     //Match? listMatch = listRegex.firstMatch(line);
        //   //
        //     RegExp regExp = RegExp(selectedPattern.regex);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? listIndent = regMatch?.group(1);
        //     String? listType = regMatch?.group(2);
        //     String? listItemText = regMatch?.group(3);
        //     textSpans.add(TextSpan(
        //       text: "$listIndent$listType $listItemText",
        //       style: style.copyWith(fontWeight: FontWeight.bold, fontSize:  defaultFontSize),
        //     ));
        // }
        // else if("md:link" == selectedPattern.tag) {
        //
        //     RegExp regExp = RegExp(selectedPattern.regex);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? linkText = regMatch?.group(1);
        //     String? linkUrl = regMatch?.group(2);
        //     textSpans.add(TextSpan(
        //       text: linkText,
        //       style: style.copyWith(color: Colors.blue),
        //       recognizer: TapGestureRecognizer()..onTap = () => _openUrl(linkUrl ?? ''),
        //     ));
        //
        // }
        // else if("md:image" == selectedPattern.tag) {
        //
        //     RegExp regExp = RegExp(selectedPattern.regex);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? altText = regMatch?.group(1);
        //     String? imageUrl = regMatch?.group(2);
        //     //todo yet to treat images
        //     // spans.add(
        //     //   WidgetSpan(
        //     //     child: Image.network(imageUrl ?? '', alt: altText ?? ''),
        //     //   ),
        //     // );
        //     // textSpans.add(WidgetSpan(child:
        //
        //     // ));
        // }
        // else if("md:blockquotes" == selectedPattern.tag) {
        //
        //     RegExp regExp = RegExp(selectedPattern.regex);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? blockquoteText = regMatch?.group(1);
        //
        //     textSpans.add(WidgetSpan(child:
        //         IntrinsicHeight(
        //             child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 Container(
        //                   width: 4,
        //                   color: kAppBlue,
        //                 ),
        //                 const SizedBox(width: 10,),
        //                 Expanded(child: Text(blockquoteText ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontSize: defaultFontSize, height: defaultLineHeight),))
        //               ],
        //             )
        //     )));
        //
        // }
        // else if("md:inlineCode" == selectedPattern.tag) {
        //
        //     RegExp regExp = RegExp(selectedPattern.regex);
        //     Match? regMatch = regExp.firstMatch(modifiedText);
        //     String? codeText = regMatch?.group(1);
        //     textSpans.add(WidgetSpan(child:
        //         Container(
        //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        //           decoration: BoxDecoration(
        //             color: theme.colorScheme.outline,
        //             borderRadius: BorderRadius.circular(4)
        //           ),
        //           child: Text(codeText ?? '', style: theme.textTheme.bodyMedium?.copyWith(),),
        //         )
        //       // CustomCodeViewWidget(
        //       //   code: codeText ?? '',
        //       //   tag: codeText ?? '',
        //       //   codeLanguage: codeLanguage ?? defaultCodeLanguage,
        //       // )
        //     ));
        //
        // }
        // else if("md:horizontalRule" == selectedPattern.tag) {
        //
        //     textSpans.add(const WidgetSpan(child:
        //       CustomBorderWidget(top: 0, bottom: 0,)
        //     ));
        //
        // }
        // else if("md:emphasis" == selectedPattern.tag) {
        //   RegExp regExp = RegExp(selectedPattern.regex);
        //   Match? regMatch = regExp.firstMatch(modifiedText);
        //   String? emphasisType = regMatch?.group(1);
        //   String? emphasisText = regMatch?.group(2);
        //   if (emphasisType == '*' || emphasisType == '_') {
        //     textSpans.add(TextSpan(
        //       text: emphasisText,
        //       style: style.copyWith(fontStyle: FontStyle.italic)),
        //     );
        //   }
        //   if (emphasisType == '**' || emphasisType == '__') {
        //     textSpans.add(TextSpan(
        //         text: emphasisText,
        //         style: style.copyWith(fontWeight: FontWeight.bold)),
        //     );
        //   }
        // }
        // else {
        //
        // }
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

  double _getHeaderFontSize(double baseFontSize, int? level) {
    switch (level) {
      case 1:
        return baseFontSize + 6;
      case 2:
        return baseFontSize + 4;
      case 3:
        return baseFontSize + 2;
      default:
        return baseFontSize;
    }
  }

  void _openUrl(String url) {
    // Handle opening the URL
  }


  @override
  void dispose() {
    super.dispose();
  }

}

class Pattern {
  final String regex;
  final TextStyle style;
  final String tag;
  bool multiLine;
  bool caseInsensitive;
  final Function(String) onTap;

  Pattern({required this.tag, required this.regex, required this.style, required this.onTap, this.multiLine = false, this.caseInsensitive = true});
}