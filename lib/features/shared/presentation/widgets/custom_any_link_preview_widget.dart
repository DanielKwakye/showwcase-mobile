import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';


class CustomAnyLinkPreviewWidget extends StatelessWidget  {
  final String message ;
  final double? topPadding ;
  final Function(String)? onTap;
  const CustomAnyLinkPreviewWidget({Key? key, required this.message,  this.topPadding = 10, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final link = getFirstThreadUrl(message);
    return AnyLinkPreview.builder(
        link: link,
        errorWidget: const SizedBox.shrink(),
        placeholderWidget: const SizedBox.shrink(),
        itemBuilder: (context, metadata, imageProvider) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          margin:  EdgeInsets.only(top: topPadding!),
          child: GestureDetector(
            onTap: () {
              // launchBrowser(link, context);
              onTap?.call(link);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageProvider != null) ... {
                  Container(
                    height: 200,
                    width: width(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                },
                Container(
                  width: double.infinity,
                  padding: (!metadata.title.isNullOrEmpty() || !metadata.desc.isNullOrEmpty())  ? const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15): EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (metadata.title != null) ... {
                        Text(
                          metadata.title!,
                          maxLines: 1,
                          style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                      },

                      if (metadata.desc != null) ... {
                        Text(
                            metadata.desc!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: theme.colorScheme.onPrimary,)
                        ),
                        const SizedBox(height: 10,),
                      }


                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String getFirstThreadUrl(String threadMessage){
    RegExp exp =  RegExp(r"(?:(?:(?:ftp|http)s*:\/\/|www\.)[^\.]+\.[^ \n]+)");
    Iterable<RegExpMatch> matches = exp.allMatches(threadMessage);
    return threadMessage.substring(matches.first.start, matches.first.end);
  }
}
