import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';

/// For showing user avatar
class CustomUserAvatarWidget extends StatelessWidget {

  final String? username;
  final String? networkImage;
  final double? size;
  final double? borderSize;
  final Color? borderColor;
  final Color? backgroundColor;
  final String? dimension;
  const CustomUserAvatarWidget({Key? key,
    this.username,
    this.networkImage,
    this.size,
    this.borderSize,
    this.borderColor,
    this.dimension,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = this.size ?? 40;
    String mainImageUrl = '' ;
    String imageUrl = '' ;
    if( networkImage != null) {
      mainImageUrl = modifyAssetUrl( filename: getProfileImage(networkImage));
      imageUrl = networkImage!.startsWith("http") ? networkImage! : getProfileImage(networkImage!,);
      List<String> stringSplit = imageUrl.split('?') ;

      final extension = p.extension(mainImageUrl);

      if(stringSplit.length == 1){
        mainImageUrl = stringSplit[0] ;

        //get resized image
        const profileAssetBaseUrl = "https://profile-assets.showwcase.com/";
        if(mainImageUrl.startsWith(profileAssetBaseUrl) && extension.isNotEmpty && !dimension.isNullOrEmpty()) {
          final remainingString = mainImageUrl.substring(profileAssetBaseUrl.length);
          mainImageUrl = "$profileAssetBaseUrl$dimension/$remainingString";
        }

      }else{
        mainImageUrl = stringSplit[1].substring(2);
        mainImageUrl = getProfileImage(mainImageUrl);
        List<String> imageParams = mainImageUrl.split('&');
        mainImageUrl = imageParams[0];
      }

    }


    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(width: borderSize ?? 5, color: borderColor ?? theme.colorScheme.primary),
        color: backgroundColor ?? theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: networkImage != null ? ClipRRect(
        borderRadius: BorderRadius.circular(1000),
          child : networkImage!.contains('.svg') ?
          SvgPicture.network(
            networkImage!,
            placeholderBuilder: (BuildContext context) => _fallbackIcon(theme),
          )
          : CachedNetworkImage(
            imageUrl: mainImageUrl,
            errorWidget: (context, url, error) => _fallbackIcon(theme),
            placeholder: (ctx, url) => _fallbackIcon(theme),
            fit: BoxFit.cover,
            //cacheManager: BaseCacheManager(),
            memCacheWidth: size < 100 ? 100.round() : null,
            cacheKey: mainImageUrl,
          )
      )
          : _fallbackIcon(theme),
    );
  }

  Widget _fallbackIcon(ThemeData theme){
    return Center(child: Text(getInitials(username != null ? username!.toUpperCase() : 'Showwcase'), style: TextStyle(color: theme.colorScheme.onBackground),),);
  }
}
