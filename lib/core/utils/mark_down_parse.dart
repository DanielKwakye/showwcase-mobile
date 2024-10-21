import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';

import 'constants.dart';
import 'markdown_syntax.dart';

typedef MarkdownTapTagCallback = void Function(
    String name,
    String fullText,
    );

class MarkdownParse extends StatelessWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  const MarkdownParse({
    Key? key,
    required this.data,
    this.onTapLink,
    this.onTapHastag,
    this.onTapMention,
    this.onCommunityTapped,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.syntaxHighlighter,
    this.bulletBuilder,
    this.styleSheetTheme,
    this.styleSheet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.builders = const <String, MarkdownElementBuilder>{},
    this.inlineSyntaxes,
    this.blockSyntaxes,
    this.checkboxIconSize,
    this.onTapText,
    this.padding,
    this.onTapCode,
    required this.fontSize
  }) : super(key: key);

  /// The string markdown to display.
  final String data;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// Called when the user taps a hashtag.
  final MarkdownTapTagCallback? onTapHastag;

  final Function(String?, String?)? onTapCode;

  /// Called when the user taps a mention.
  final MarkdownTapTagCallback? onTapMention;

  /// Called when the user taps a community.
  final MarkdownTapTagCallback? onCommunityTapped;

  /// How the scroll view should respond to user input.
  ///
  /// See also: [ScrollView.physics]
  final ScrollPhysics? physics;

  /// n object that can be used to control the position to which this scroll view is scrolled.
  ///
  /// See also: [ScrollView.controller]
  final ScrollController? controller;

  /// Whether the extent of the scroll view in the scroll direction should be determined by the contents being viewed.
  ///
  /// See also: [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// Creates a format [TextSpan] given a string.
  ///
  /// Used by [MarkdownWidget] to highlight the contents of `pre` elements.
  final SyntaxHighlighter? syntaxHighlighter;

  /// Signature for custom bullet widget.
  ///
  /// Used by [MarkdownWidget.bulletBuilder]
  final MarkdownBulletBuilder? bulletBuilder;

  /// Enum to specify which theme being used when creating [MarkdownStyleSheet]
  ///
  /// [material] - create MarkdownStyleSheet based on MaterialTheme
  /// [cupertino] - create MarkdownStyleSheet based on CupertinoTheme
  /// [platform] - create MarkdownStyleSheet based on the Platform where the
  /// is running on. Material on Android and Cupertino on iOS
  final MarkdownStyleSheetBaseTheme? styleSheetTheme;

  /// Defines which [TextStyle] objects to use for which Markdown elements.
  final MarkdownStyleSheet? styleSheet;

  /// Signature for custom image widget.
  ///
  /// Used by [MarkdownWidget.imageBuilder]
  final MarkdownImageBuilder? imageBuilder;

  /// Signature for custom checkbox widget.
  ///
  /// Used by [MarkdownWidget.checkboxBuilder]
  final MarkdownCheckboxBuilder? checkboxBuilder;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [bodytext2] fonts size.
  final double? checkboxIconSize;

  final Map<String, MarkdownElementBuilder> builders;
  final List<md.InlineSyntax>? inlineSyntaxes;
  final List<md.BlockSyntax>? blockSyntaxes;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTapText;
  final num fontSize ;

  @override
  Widget build(BuildContext context) {

    final style = theme(context).textTheme.bodyMedium?.copyWith(
        height: defaultLineHeight,
        fontSize: defaultFontSize);

    return Markdown(
      key: const Key("defaultmarkdownformatter"),
      data: data,
      selectable: true,
      padding: const EdgeInsets.all(0),
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      onTapText: onTapText,
      syntaxHighlighter: syntaxHighlighter,
      bulletBuilder: bulletBuilder ?? (int number, BulletStyle style) {
            double? fontSize = defaultFontSize;
            return Text(
              "◉",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: fontSize,
              ),
            );
          },
      styleSheetTheme: styleSheetTheme,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [
          md.EmojiSyntax(),
          md.AutolinkExtensionSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,

        ],
      ),

      blockSyntaxes: [
        const md.FencedCodeBlockSyntax(),
        if (blockSyntaxes != null) ...blockSyntaxes!
      ],
      inlineSyntaxes: [
        ColoredHastagSyntax(),
        ColoredMentionSyntax(),
        ColoredCommunitySyntax(),
        InlineCodeSyntax(),

        if (inlineSyntaxes != null) ...inlineSyntaxes!
      ],
      builders: {
        "hastag": ColoredHastagElementBuilder(onTapHastag, context: context),
        "mention": ColoredMentionElementBuilder(onTapMention, context: context),
        "community": ColoredCommunityElementBuilder(onCommunityTapped,  context: context),
        "inline-code": InlineCodeElementBuilder(context: context),
        "code": CodeElementBuilder(onTap: onTapCode),

        // "link": ColoredLinkElementBuilder(onTapLink),
        ...builders
      },
      styleSheet: styleSheet ?? MarkdownStyleSheet.fromTheme(theme(context)).copyWith(
          p: style?.copyWith(fontSize: fontSize.toDouble(),),
          h1: style?.copyWith(fontWeight: FontWeight.w800,fontSize: 20),
          h2: style?.copyWith(fontWeight: FontWeight.w800),
          // h2: style?.copyWith(
          //   fontSize: 22,
          //   fontWeight: FontWeight.w600,
          //   height: 1.8,
          // ),
          h3: style?.copyWith(fontWeight: FontWeight.w800),
          h4: style?.copyWith(fontWeight: FontWeight.w800),
          h5: style?.copyWith(fontWeight: FontWeight.w800),
          h6: style?.copyWith(fontWeight: FontWeight.w800),
          blockquote: style,
          // code: const TextStyle(
          //   color: Colors.black,
          // ),
          // codeblockDecoration: ,

          blockquoteDecoration: BoxDecoration(
            color: theme(context).colorScheme.outline,
            border:  Border(
              left: BorderSide(
                color: theme(context).colorScheme.outline,
                width: 5,
              ),
            ),
          ),
          blockquotePadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
      onTapLink: onTapLink,

      imageBuilder: (Uri uri, String? title, String? alt) {
       if(title == null && alt == null) return const SizedBox.shrink();
        return Container( /// actual image
          color: Theme.of(context).colorScheme.primary,
          alignment: Alignment.center,
          child: Hero(
              tag: uri.toString(),
              child: CustomNetworkImageWidget(imageUrl: uri.toString())), //SvgP.network(mainImageUrl)
        );
      },
      checkboxBuilder: checkboxBuilder ??
              (bool value) {
            return Icon(
              value
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: checkboxIconSize ??
                  Theme.of(context).textTheme.bodyMedium?.fontSize,
              color: value ? Colors.blue[600] : Colors.grey,
            );
          },
    );
  }
}
