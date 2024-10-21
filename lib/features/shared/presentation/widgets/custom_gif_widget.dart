import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:showwcase_v3/core/utils/constants.dart';

class CustomGifWidget extends StatelessWidget {

  final String url;
  final Function()? onTap;
  const CustomGifWidget({
    required this.url,
    Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child:  ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: GestureDetector(
          onTap: onTap,
          child: Hero(
            tag: url,
            child: CachedNetworkImage(
              imageUrl:  url,
              placeholder: (ctx, url) => const UnconstrainedBox(child: Center(child: SizedBox(width: 20, height: 20, child: CupertinoActivityIndicator(),))),
              errorWidget: (context, url, error) => Image.asset(kImageNotFound),
              fit: BoxFit.cover,
              cacheKey: url,
              maxWidthDiskCache: size.width.round(),
            ),
          ),
        ),
      ),
      // child:,
    );
  }
}
