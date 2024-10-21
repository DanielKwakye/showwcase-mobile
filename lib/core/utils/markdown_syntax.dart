import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:showwcase_v3/core/utils/mark_down_parse.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';

import 'constants.dart';

// Colored hastag syntax
class ColoredHastagSyntax extends md.InlineSyntax {
  ColoredHastagSyntax({String pattern = r'#[^\s#]+'}) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element hastagElement = md.Element.text("hastag", tag);
    parser.addNode(hastagElement);
    return true;
  }
}

// hastag element builder
class ColoredHastagElementBuilder extends MarkdownElementBuilder {
  final MarkdownTapTagCallback? onTapHastag;
  final BuildContext context;

  ColoredHastagElementBuilder(
      this.onTapHastag,
      {required this.context}
      );

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        onTapHastag?.call(
          element.textContent.replaceFirst("#", ""),
          element.textContent,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Text(
          element.textContent,
          style: theme(context).textTheme.bodyMedium?.copyWith(
            color: Colors.blue,
            fontSize: defaultFontSize,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}


// // Colored mention syntax
// class ColoredLinkSyntax extends md.InlineSyntax {
//   // final exp = RegExp(
//   //         r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
//   //     final match = exp.firstMatch(word);
//   ColoredLinkSyntax({String pattern =  r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"})
//       : super(pattern);
//
//   @override
//   bool onMatch(md.InlineParser parser, Match match) {
//     final tag = match.group(0).toString();
//     md.Element hastagElement = md.Element.text("link", tag);
//     parser.addNode(hastagElement);
//     return true;
//   }
// }
//
// // mention element builder
// class ColoredLinkElementBuilder extends MarkdownElementBuilder {
//   final MarkdownTapLinkCallback? onLinkTapped;
//
//   ColoredLinkElementBuilder(this.onLinkTapped);
//
//   @override
//   Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
//     return GestureDetector(
//       onTap: () {
//         onLinkTapped?.call();
//       },
//       child: Text(element.textContent,
//         style: theme(context).textTheme.bodyText2?.copyWith(
//           color: Colors.yellow,
//           fontSize: defaultFontSize,
//           height: 1.5,
//         ),
//       ),
//     );
//   }
// }

// Colored mention syntax
class ColoredMentionSyntax extends md.InlineSyntax {
  ColoredMentionSyntax({String pattern = r'\@[^\s@]+'}) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element hastagElement = md.Element.text("mention", tag);
    parser.addNode(hastagElement);
    return true;
  }
}

// mention element builder
class ColoredMentionElementBuilder extends MarkdownElementBuilder {
  final MarkdownTapTagCallback? onTapMention;
  final BuildContext context;

  ColoredMentionElementBuilder(this.onTapMention,
      {required this.context}
      );

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        onTapMention?.call(
          element.textContent.replaceFirst("@", ""),
          element.textContent,
        );
      },
      child: Text(element.textContent.replaceFirst("@", ""),
        style: theme(context).textTheme.bodyMedium?.copyWith(
          color: Colors.blue,
          fontSize: defaultFontSize,
          height: 1.5,
        ),
      ),
    );
  }
}


// Colored community syntax
class ColoredCommunitySyntax extends md.InlineSyntax {
  ColoredCommunitySyntax({String pattern = r'\±[^\s±]+'}) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element communityElement = md.Element.text("community", tag);
    parser.addNode(communityElement);
    return true;
  }
}

class InlineCodeSyntax extends md.InlineSyntax {

  // static const String _pattern = r"```([^\]]+)```";
  static const String _pattern = r'(`+(?!`))((?:.|\n)*?[^`])\1(?!`)';
  InlineCodeSyntax(): super(_pattern);

  @override
  bool tryMatch(md.InlineParser parser, [int? startMatchPos]) {
    if (parser.pos > 0 && parser.charAt(parser.pos - 1) == $backquote) {
      // Not really a match! We can't just sneak past one backtick to try the
      // next character. An example of this situation would be:
      //
      //     before ``` and `` after.
      //             ^--parser.pos
      return false;
    }

    var match = pattern.matchAsPrefix(parser.source, parser.pos);
    if (match == null) {
      return false;
    }
    parser.writeText();
    if (onMatch(parser, match)) parser.consume(match.match.length);
    return true;
  }

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element codeElement = md.Element.text("inline-code", tag);
    parser.addNode(codeElement);
    return true;
  }
}

extension MatchExtensions on Match {
  /// Returns the whole match String
  String get match => this[0]!;
}


class ColoredCommunityElementBuilder extends MarkdownElementBuilder {
  final MarkdownTapTagCallback? onTapCommunity;
  final BuildContext context;

  ColoredCommunityElementBuilder(this.onTapCommunity,
      {required this.context});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        onTapCommunity?.call(
          element.textContent.replaceFirst("*", ""),
          element.textContent,
        );
      },
      child: Text(element.textContent.replaceFirst("*", ""),
        style: theme(context).textTheme.bodyMedium?.copyWith(
        color: kAppGold,
        fontSize: defaultFontSize,
        height: 1.5,
      ),
        // element.textContent + " ",
        // style: TextStyle(
        //   color: Colors.blue[700],
        //   fontWeight: FontWeight.w500,
        // ),
      ),
    );
  }
}


class InlineCodeElementBuilder extends MarkdownElementBuilder {

  final BuildContext context;


  InlineCodeElementBuilder({required this.context});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {

    // var language = defaultCodeLanguage;
    final textContent = element.textContent;

    // if (element.attributes['class'] != null) {
    //   String lg = element.attributes['class'] as String;
    //   // language = lg.substring(9);
    // }

    return Container(
        decoration: BoxDecoration(
          color: theme(context).brightness == Brightness.light ? const Color(0xff868a90) : (codeTheme['root'] as TextStyle).backgroundColor,
          borderRadius: BorderRadius.circular(2)
        ),
      child: Text(textContent, style: const TextStyle(color: Colors.white),),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {

  final Function(String?, String?)? onTap;
  CodeElementBuilder({required this.onTap});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = defaultCodeLanguage;

    final textContent = element.textContent;

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }

    // return const SizedBox.shrink();
    return CustomCodeViewWidget(
      code: textContent,
      tag: textContent,
      codeLanguage: language,
      onTap: onTap,
    );
  }
}
