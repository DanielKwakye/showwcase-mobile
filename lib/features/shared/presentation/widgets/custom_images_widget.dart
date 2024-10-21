import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/image_not_found_widget.dart';


class CustomImagesWidget extends StatelessWidget {

  // final ThreadModel thread;
  final List<String> images;
  final String? heroTag;
  final Function(int, List<String>)? onTap;
  final bool compress;
  const CustomImagesWidget({Key? key,
    // required this.thread,
    required this.images,
    this.onTap,
    this.heroTag,
    this.compress = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: images.length == 1 ? ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:  (9 * size.width) / 14,
          ),
          child: _singleImage(context, size: size),
        ) : _gridLayout(context)
    );
  }

  Widget _singleImage(BuildContext context, {int index = 0, bool fill = false, required Size size}) {

    final desiredWidth = size.width;
    return FadeIn(child: GestureDetector(
        onTap: () {
          onTap?.call(index, images);
          // _onImageTap(context, index);
        },
        child: Hero(
          tag: images[index],
          child: SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: images[index],
              placeholder: (ctx, url) =>  const Center(
                child: CustomAdaptiveCircularIndicator(),
              ),
              errorWidget: (context, url, error) =>  const ImageNotFoundWidget(),
              cacheKey: images[index],
              maxWidthDiskCache: compress ? desiredWidth.toInt() : 500,
            ),
          ),
        )
    ));
  }



  Widget _gridLayout(BuildContext context) {
    
    final pairsCount = ( images.length / 2).roundUpAbs;

    return LayoutGrid(
      // set some flexible track sizes based on the crossAxisCount
      // columnSizes: [1.fr, 1.fr],
      // // set all the row sizes to auto (self-sizing height)
      // rowSizes: List.generate(pairsCount, (index) => auto),
      columnSizes: const [auto],
      // set all the row sizes to auto (self-sizing height)
      rowSizes: List.generate(pairsCount, (index) => auto),
      rowGap: 2,
      // equivalent to mainAxisSpacing
      columnGap: 2,
      children: getImagesGrid(context),

    );

  }

  List<Widget> getImagesGrid(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final List<Widget> mImages = [];

    for(int i = 0; i < images.length; i = i + 2){
      // final currentImage = images[i];
      final nextIndex = i + 1;
      if(nextIndex > images.length - 1) {
        mImages.add(SizedBox(
          width: size.width,
          height: (size.width / 2) - 2,
          child: _singleImage(context, index: i, fill: true, size: size),
        ));
        continue;
      }
      mImages.add(Row(
        children: [
          Expanded(child:  SizedBox(
            height: (size.width / 2) - 2,
            child: _singleImage(context, index: i, fill: true, size: size),
          )),
          const SizedBox(width: 2,),
          Expanded(child: SizedBox(
            height: (size.width / 2) - 2,
            child: _singleImage(context, index: nextIndex, fill: true, size: size),
          )),
        ],
      ));
    }

    return mImages;

  }

}
