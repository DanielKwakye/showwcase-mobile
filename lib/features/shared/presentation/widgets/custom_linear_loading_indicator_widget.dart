import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_play_icon.dart';

class CustomLinearLoadingIndicatorWidget extends StatelessWidget {

  final bool loading;
  final bool? attachedVideo;
  final File? attachedImage;
  final double? progress;

  const CustomLinearLoadingIndicatorWidget({Key? key,
    this.loading = true,
    this.attachedImage,
    this.attachedVideo = false,
    this.progress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(loading == false){
      return const SizedBox.shrink();
    }
    if(attachedImage != null){
      return _loadingAttachment(context);
    }

    if(attachedVideo  == true){
      return _loadingAttachment(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: const LinearProgressIndicator(color: kAppBlue, minHeight: 2,),
    );

  }

  Widget _loadingAttachment(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(bottom: BorderSide(color: theme.colorScheme.outline),
                // top:  BorderSide(color: theme.colorScheme.outline)
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: attachedImage != null ?
                _imageIconPlaceHolder(context, attachedImage!)
                    : _videoIconPlaceholder(context),
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(attachedImage != null ?  'Uploading your image(s)...' : 'Uploading your video...',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onPrimary),),
                const SizedBox(height: 12,),
                if(progress != null) ...{
                  // linear percentage indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearPercentIndicator(
                      lineHeight: 10.0,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      percent: ((progress ?? 0) > 0 ? (progress ?? 0) - 1 : 0) / 100,
                      backgroundColor: theme.colorScheme.outline,
                      progressColor: kAppBlue,
                      animation: true,
                      animationDuration: 800,
                      animateFromLastPercent: true,
                      center: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${((progress ?? 0) > 0 ? (progress ?? 0) - 1 : 0).round()} %",
                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  )

                }else ... {

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(color: kAppBlue, minHeight: 2,),
                  )

                }

              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _imageIconPlaceHolder(BuildContext context, File file){
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.file(file, fit: BoxFit.cover,),
    );
  }

  Widget _videoIconPlaceholder(BuildContext context) {

    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CustomPlayIcon(border: 0, iconSize: 10,),
      ),
    );
  }
}
