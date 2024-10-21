import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/mark_down_parse.dart';

class CustomMarkdownWidget extends StatelessWidget with LaunchExternalAppMixin {

  final String markdown;
  final VoidCallback? onTapText;
  final Function(String)? onLinkTapped;
  final Function(String)? onCommunityTapped;
  final Function(String)? onHashtagTapped;
  final Function(String)? onMentionTapped;
  final Function(String?, String?)? onCodeTapped;
  const CustomMarkdownWidget({Key? key, required this.markdown, this.onTapText, this.onLinkTapped, this.onCommunityTapped, this.onHashtagTapped, this.onMentionTapped, this.onCodeTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var sRunes = markdown.runes;

    //Text(widget.message, style: TextStyle(color: theme(context).colorScheme.onBackground),)

    return MarkdownParse(
      data: String.fromCharCodes(sRunes, 0, sRunes.length),
      physics: const NeverScrollableScrollPhysics(),

      shrinkWrap: true,
      fontSize: defaultFontSize,
      onTapText: onTapText,
      onTapHastag: (String name, String match) {
        // name => hashtag
        // match => #hashtag
        debugPrint('hashTag: $match');
        match = match.replaceFirst('#', '');
        final url = ApiConfig.websiteHashTagSearchUrl(match);
        onHashtagTapped?.call(url);
      },

      onTapCode: onCodeTapped,

      onCommunityTapped: (String name, String match) {
        debugPrint('community: $match');
        match = match.replaceFirst('*', '');
        final url = ApiConfig.websiteCommunityUrl(match);
        onCommunityTapped?.call(url);
      },
      // builders: <String, MarkdownElementBuilder>{
      //
      // },
      onTapMention: (String name, String match) {

        debugPrint('mention: $match');
        match = match.replaceFirst('@', '');

        if (match.contains('.com') || match.contains('.net')) {
          final url = "http://$match";
          // logger.i(url);
          onMentionTapped?.call(url);
          return;
        }

        onMentionTapped?.call(match);

      },
      onTapLink: (link, href, title) {
        final url = href ?? link;
        if(isEmail(url)){
          // open email
          openEmail(url);
          return;
        }
        if(isPhoneNumber(url)){
          makePhoneCall(url);
          return;
        }
        onLinkTapped?.call(url);
        // logger.i('Link clicked : ----- ');
        // logger.i('href: $href , link: $link, title: $title');
        // launchBrowser(href ?? link, context);
      },

    );
  }
}
