import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';

class CustomGalleryAssetWidget extends StatefulWidget {

  final AssetEntity asset;
  final Function(File, AssetType, bool)? onItemTap;
  const CustomGalleryAssetWidget({
    required this.asset,
    this.onItemTap,
    Key? key}) : super(key: key);

  @override
  State<CustomGalleryAssetWidget> createState() => _CustomGalleryAssetWidgetState();

}

class _CustomGalleryAssetWidgetState extends State<CustomGalleryAssetWidget> {

  ValueNotifier<bool> selected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: widget.asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) {
          return const Center(
          child: CustomCircularLoader(),
        );
        }
        // If there's data, display it as an image
        // If there's data, display it as an image
        return GestureDetector(
          onTap: () async {
            final file = await widget.asset.file;
            selected.value = !selected.value;
            if(widget.onItemTap != null && file != null){
              widget.onItemTap!(file, widget.asset.type, selected.value);
            }
          },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (widget.asset.type == AssetType.video)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.blue,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),

               ValueListenableBuilder(valueListenable: selected, builder: (ctx, bool value, _){
                 if(!value) return const SizedBox.shrink();

                 return Positioned.fill(child: Container(
                   decoration: BoxDecoration(
                       border: Border.all(color: kAppBlue, width: 4)
                   ),
                   child: const Center(child: Icon(Icons.check_circle, color: kAppBlue,),),
                 )
                 );
               })

            ],
          ),
        );
      },
    );
  }
}
