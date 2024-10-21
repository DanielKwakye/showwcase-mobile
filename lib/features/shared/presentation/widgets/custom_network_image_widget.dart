import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class CustomNetworkImageWidget extends StatelessWidget {

  final String imageUrl;
  final BoxFit? fit;
  final Function()? onError;
  final int? maxCacheWidth;
  final int? maxCacheHeight;
  final String? defaultUrl;
  const CustomNetworkImageWidget({
    required this.imageUrl,
    this.onError,
    this.fit,
    this.maxCacheHeight,
    this.maxCacheWidth,
    this.defaultUrl,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    // return Image.network(testImageUrl, errorBuilder: (ctx, a, b) {
    //   debugPrint("error ${a.toString()}");
    //   return const SizedBox.shrink();
    // },);
    if(imageUrl.endsWith(".svg")){

    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      fadeInCurve: Curves.easeIn,
      cacheKey: imageUrl,
      maxHeightDiskCache: maxCacheHeight,
      maxWidthDiskCache: maxCacheWidth,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 1,),),),
      errorWidget: (context, url, error) {
        debugPrint(error.toString());
        // return const Center(child: Icon(Icons.error_outline),);

        return FutureBuilder<String?>(
          future: _downloadAndDisplayImage(imgUrl: modifyAssetUrl(filename: getProfileImage(imageUrl)) ),
          builder: (ctx, AsyncSnapshot<String?> resultSnapshot) {
              if(resultSnapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
              }else if(resultSnapshot.hasError){
              debugPrint("authResultSnapshot: ${resultSnapshot.error}");
              if(onError != null) {
                onError?.call();
              }
              if(defaultUrl != null) {
                return CachedNetworkImage(imageUrl: defaultUrl!);
              }
              return const SizedBox.shrink();
              }else{
                if(resultSnapshot.data == null) return const SizedBox.shrink();

                final stringReturned = resultSnapshot.data!;

                // String credentials = "username:password";
                // return SvgPicture.string(stringReturned);
                return const SizedBox.shrink();

              }
          },
        );

    //     // );
      },
    );
  }

  Future<String?> _downloadAndDisplayImage({required String imgUrl}) async {

   try{
     var response = await Dio().get(imgUrl);
     return response.data is String ? response.data : null;


   }catch(e){
     return null;
   }
  }
}


