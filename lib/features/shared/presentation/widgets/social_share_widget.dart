import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/functions.dart';

import '../../../../core/utils/constants.dart';

class SocialShareWidget extends StatelessWidget {

  final String? imageUrl;
  final String? url;
  final String? title;
  final double iconSize;

  const SocialShareWidget({
    this.imageUrl,
    this.url,
    this.title,
    this.iconSize = 20.0,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final FlutterShareMe flutterShareMe = FlutterShareMe();

    return Row(
      children: [

        /// Twitter
        IconButton(onPressed: () {
          // SocialShare.shareTwitter(title ?? 'Showwcase', url: url );
          flutterShareMe.shareToTwitter(url: url ?? ApiConfig.websiteUrl, msg: title ?? '');
        }, icon: SvgPicture.asset(
          kTwitterIconSvg, color: theme.colorScheme.onPrimary,
          height: iconSize,
        ), visualDensity: const VisualDensity(horizontal: -4)),

          /// Facebook
        IconButton(onPressed: () {

          flutterShareMe.shareToFacebook(url: url ?? ApiConfig.websiteUrl, msg: title ?? '');

        }, icon: SvgPicture.asset(
          kFacebookIconSvg,
    colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
          height: iconSize,
        ), visualDensity: const VisualDensity(horizontal: -4)),

        /// Linked In
        IconButton(onPressed: () {
          // SocialShare.shareOptions(url ?? ApiConfig.websiteUrl, imagePath: imageUrl);
          flutterShareMe.shareToSystem(msg: url ?? ApiConfig.websiteUrl);
        }, icon: SvgPicture.asset(
          kLinkedInIconSvg, color: theme.colorScheme.onPrimary,
          height: iconSize,
        ), visualDensity: const VisualDensity(horizontal: -4),),

        /// Copy to clipboard
        IconButton(onPressed: () {
          // SocialShare.copyToClipboard(url ?? ApiConfig.websiteUrl);
          copyTextToClipBoard(context, url ?? ApiConfig.websiteUrl);
        }, icon: Icon(
          Icons.link, color: theme.colorScheme.onPrimary,
          size: iconSize,
        ), visualDensity: const VisualDensity(horizontal: -4),),

      ],
    );
  }
}
