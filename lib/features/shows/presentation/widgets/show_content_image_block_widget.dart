import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowContentImageBlockWidget extends StatelessWidget {
  final ShowBlockModel block;
  final ShowModel show;
  const ShowContentImageBlockWidget({required this.block, required this.show,  Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return SeparatedColumn(
      mainAxisSize: MainAxisSize.min,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
      children: <Widget>[

        CustomImagesWidget(images: [block.imageBlock!.url!] , onTap: (index, imageUrls) {

          context.push(context.generateRoutePath(subLocation: showImagesPreviewPage), extra: {
            'show': show,
            'galleryItems': imageUrls,
            'initialPageIndex': index
          });

        },),
        if(!block.imageBlock!.caption.isNullOrEmpty()) ... {
          SizedBox(width: double.maxFinite,
              child : Text(block.imageBlock!.caption!, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center,)
          )
        }
      ],
    );
  }
}
