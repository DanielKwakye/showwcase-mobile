import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_iframe_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_twitter_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_lexical_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';


class ShowPreviewLexicalBlockWidget extends StatefulWidget {

  final ShowLexicalBlockModel lexicalBlock;
  final ShowModel show;
  const ShowPreviewLexicalBlockWidget({
    required this.lexicalBlock,
    Key? key, required this.show}) : super(key: key);

  @override
  ShowPreviewLexicalBlockController createState() => ShowPreviewLexicalBlockController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowPreviewLexicalBlockView extends WidgetView<ShowPreviewLexicalBlockWidget, ShowPreviewLexicalBlockController> {

  const _ShowPreviewLexicalBlockView(ShowPreviewLexicalBlockController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final html = widget.lexicalBlock.html;

    return SingleChildScrollView(
      child: HtmlWidget(
        html ?? "",
        // all other parameters are optional, a few notable params:

        // specify custom styling for an element
        // see supported inline styling below
        customStylesBuilder: (element) {

          if (element.classes.contains('editor__paragraph')
              || element.classes.contains('editor__listItem')
          ) {
            // element.localName is the tag name
            // debugPrint("element: ${element.localName}");
            return {
              'font-size': '${defaultFontSize + 1}px',
              'line-height': '1.8'
            };
          }

          if (element.classes.contains('editor__link')) {
            // element.localName is the tag name
            // debugPrint("element: ${element.localName}");
            return {
              'color' : '#4595D0'
            };
          }

          //<p class="editor__paragraph"><br></p>
          // if(element.classes.contains('editor__paragraph') && element.innerHtml == '<br>') {
          //   debugPrint('element: ${element.localName} ${element.innerHtml}');
          //   return {
          //     'margin': '20px'
          //   };
          // }

          return null;

        },



        // this callback will be triggered when user taps a link
        onTapUrl: (url) {
          state._openLink(url);
          return true;
        },

        // render a custom widget
        customWidgetBuilder: (element) {
          // element.localName is the tag name
          // if (element.attributes['foo'] == 'bar') {
          //   return const SizedBox.shrink();
          // }

          if(element.localName == 'img' && element.attributes.containsKey('src')){
            return CustomImagesWidget(
              images: [
                element.attributes['src'] ?? ''
              ],
              heroTag: element.attributes['src'],
              onTap: (index, images){
                context.push(context.generateRoutePath(subLocation: showImagesPreviewPage), extra: {
                  'show': widget.show,
                  'galleryItems': images,
                  'initialPageIndex': index
                });
              },
            );
          }

          if(element.classes.contains('editor__paragraph') && element.innerHtml == '<br>') {
            debugPrint('element: ${element.localName} ${element.innerHtml}');
            return const SizedBox(height: 20,);
          }

          if(element.classes.contains('editor__listItemUnchecked') || element.classes.contains('editor__listItemUnchecked')){
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(value: element.classes.contains('editor__listItemChecked'), onChanged: (newValue) {}, ),
                Text(element.text, style: TextStyle(color: theme.colorScheme.onBackground),)
              ],
            );
          }

          if(element.classes.contains("editor__quote")){
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    color: kAppBlue,
                  ),
                  const SizedBox(width: 10,),
                  Expanded(child: Text(element.text, style: theme.textTheme.bodyMedium?.copyWith(fontSize: defaultFontSize + 1, height: defaultLineHeight),))
                ],
              ),
            );
          }

          if(element.classes.contains('editor__code')) {
            return CustomCodeViewWidget(
              tag: 'lexical_editor__code', code: element.text, codeLanguage: element.attributes.containsKey('data-highlight-language') ? element.attributes['data-highlight-language'] : defaultCodeLanguage,
              onTap: (code, language) {
                context.push(context.generateRoutePath(subLocation: showCodePreviewPage), extra: {
                  "show": widget.show,
                  "code" : element.text,
                  "tag" : 'lexical_editor__code'
                });
              },
            );
          }
          
          if(element.localName == 'hr'){
            return const Padding(
              padding:  EdgeInsets.symmetric(vertical: 20),
              child: CustomBorderWidget(),
            );
          }

          if(element.attributes.containsKey('data-bookmark-url')
              && element.attributes.containsKey('data-embed-type')
              && element.attributes['data-embed-type'] == 'bookmark-external') {

            if(checkIfLinkIsYouTubeLink(element.text)) {
              return CustomYoutubeVideoWidget(
                url: element.text,
                detachOnClick: false,
                pauseVideoOnTap: true,
                onTap: () {
                  // context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  //   "show": widget.show,
                  //   "url" : element.text
                  // });
                  context.push(youtubePreviewPage, extra: element.text);
                },
              );
            }

            return CustomAnyLinkPreviewWidget(
              message: element.text,
              onTap: (link) {
                context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  "show": widget.show,
                  "url" : link
                });
              },
            );

          }
          
          if(element.attributes.containsKey("data-embed-type") && element.attributes["data-embed-type"] == "figma"){
            final url = element.text;
            return CustomIframePreviewWidget(
              url: url,
            );
          }
          
          // if(element.attributes.containsKey('data-markdown')){
          //   // return CustomMarkdownWidget(message: message)
          // }
          

          if(element.attributes.containsKey('data-bookmark-url')
              && element.attributes.containsKey('data-embed-type')
              && element.attributes['data-embed-type'] == 'thread') {

            return CustomAnyLinkPreviewWidget(
              message: "${ApiConfig.websiteUrl}/thread/${element.text}",
              onTap: (link) {
                context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
                  "show": widget.show,
                  "url" : link
                });
              },
            );

          }
          
          

          if(element.attributes.containsKey('data-tweet-id')){

            //check the article below
          // https://medium.com/@TakRutvik/how-to-add-twitter-embed-to-your-flutter-app-with-webviews-50a13a50661a
          //   // return SocialEmbed(
          //   //     socialMediaObj: TwitterEmbedData(embedHtml: element.text)
          //   // );
            return TwitterLinkPreviewWidget(
              tweetId: element.attributes["data-tweet-id"]!,
            );


          }


          return null;
        },

      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowPreviewLexicalBlockController extends State<ShowPreviewLexicalBlockWidget> with LaunchExternalAppMixin {

  @override
  Widget build(BuildContext context) => _ShowPreviewLexicalBlockView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void _openLink(String link) {
    context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
      "show": widget.show,
      "url" : link
    });
  }

}