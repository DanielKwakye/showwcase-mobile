import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class ProfileImagePreviewPage extends StatelessWidget {

  final String url;
  final String tag;
  final double borderRadius;
  const ProfileImagePreviewPage({
    required this.url,
    required this.tag,
    this.borderRadius = 1000,
  Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);
    final media = MediaQuery.of(context);

    final imageUrl = url.startsWith("http") ? url : getProfileImage(url,);
    String mainImageUrl = '' ;
    List<String> stringSplit = imageUrl.split('?') ;
    if(stringSplit.length == 1){
      mainImageUrl = stringSplit[0] ;
    }else{
      mainImageUrl = stringSplit[1].substring(2);
      mainImageUrl = getProfileImage(mainImageUrl);
      List<String> imageParams = mainImageUrl.split('&');
      mainImageUrl = imageParams[0];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: const [
          CloseButton()
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2),
            child: CustomBorderWidget()
        ),
      ),
      body: Center(
        child: Dismissible(
            direction: DismissDirection.vertical,
            onDismissed: (_) => Navigator.of(context).pop(),
            key: Key(mainImageUrl),
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: SizedBox(
                    width: media.size.width - 40,
                    height: media.size.width - 40,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: mainImageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) {
                        return const Center(child: SizedBox(width: 20, height: 20, child: CupertinoActivityIndicator(),));
                      },
                      cacheKey: mainImageUrl,
                      errorWidget: (context, url, error) => Image.asset(kImageNotFound),
                    ),
                  ),
                ),
              ),
              // child: Image.network(image)
            )
        ),
      ),
    );
  }
}
