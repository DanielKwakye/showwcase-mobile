import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/straight_line_painter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_view_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gif_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_images_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_youtube_video_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_message_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_poll_widget.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ThreadEditorParentThreadWidget extends StatelessWidget {

  final ThreadModel thread;
  const ThreadEditorParentThreadWidget({Key? key, required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<UserModel> participants =  [];
    if(thread.user != null){
      participants.add(thread.user!);
    }
    if(thread.participants != null){
      participants.addAll(thread.participants!);
    }

    return Padding(
        padding: const EdgeInsets.only(left: 10,),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // const SizedBox(width: 15,),
              SizedBox(
                // color: Colors.yellow,
                width:  35.0,
                child: CustomPaint(
                  painter: StraightLinePaint(color: theme.colorScheme.outline, strokeWidth: 1, startHeight: 40, endOffset: 0),
                  child:  Align(
                    alignment: Alignment.topCenter,
                    child: UnconstrainedBox(
                      child: UserProfileIconWidget(
                          user: thread.user!,
                          size: 35,
                          dimension: '100x'
                      ),
                    ),
                  ),
                ),

              ),

              const SizedBox(width: 15,),

              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Meta data
                      Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 15),
                        child: ThreadUserMetaDataWidget(thread: thread,pageName: threadEditorPage,),
                      ),

                      SizedBox(height: !thread.message.isNullOrEmpty() ? 2 : 5,),
                      /// Main content

                      /// Title section
                      if(!thread.title.isNullOrEmpty())...{
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(thread.title ?? '', style: TextStyle(
                                height: defaultLineHeight,
                                fontSize: defaultFontSize + 2,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onBackground)
                            )
                        )

                      },

                      /// Message Section
                      if(!thread.message.isNullOrEmpty())...{

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: ThreadMessageWidget(
                            threadModel: thread,
                            maxLines: null,
                          ),
                        )

                        // if(isContainingAnyLink(thread.message) && thread.linkPreviewMeta == null)AnyLinkPreviewWidget(message:thread.message!,)
                      },

                      /// Link preview section
                      if(thread.linkPreviewMeta != null )...{
                        CustomLinkPreviewWidget(linkPreviewMeta: thread.linkPreviewMeta!, onTap: (url) {
                          context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                            "url": url,
                            "thread": thread
                          });
                        },),
                      }else if(!thread.message.isNullOrEmpty() && isContainingAnyLink(thread.message)) ...{
                        CustomAnyLinkPreviewWidget(message:thread.message!, onTap: (url) {
                          context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                            "url": url,
                            "thread": thread
                          });
                        },)
                      },

                      /// Images section
                      if((thread.images ?? []).isNotEmpty) ...{
                        CustomImagesWidget(
                          images: thread.images ?? [],
                          onTap: (index, images){
                            context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
                              'thread': thread,
                              'galleryItems': images,
                              'initialPageIndex': index
                            });
                          },
                        ),
                      },

                      /// Video section
                      if(!thread.videoUrl.isNullOrEmpty()) ...{
                        if(checkIfLinkIsYouTubeLink(thread.videoUrl!)) ...{
                          CustomYoutubeVideoWidget(url: thread.videoUrl!, detachOnClick: false, autoplay: true, onTap: () {
                            context.push(context.generateRoutePath(subLocation: threadBrowserPage), extra: {
                              "url": thread.videoUrl!,
                              "thread": thread
                            });
                          },)
                        }else ... {
                          CustomRegularVideoWidget(
                            autoPlay: true,
                            loop: true,
                            mute: true,
                            showDefaultControls: false,
                            showCustomVolumeButton: true,
                            onTap: () => context.push(context.generateRoutePath(subLocation: "thread-video-preview"), extra: thread),
                            tag: thread.videoUrl!,
                            videoSource: VideoSource.mediaId, mediaId: thread.videoUrl!,
                            fit: BoxFit.contain,),
                        }
                      },

                      /// Gif section
                      if(thread.gif != null) ...{
                        CustomGifWidget(url: thread.gif?.tiny?.url ?? '', onTap: () {
                          context.push(context.generateRoutePath(subLocation: "thread-images-preview"), extra: {
                            'thread': thread,
                            'galleryItems': [thread.gif?.tiny?.url ?? ''],
                            'initialPageIndex': 0
                          });
                        },),
                      },


                      /// Code section
                      if(!thread.code.isNullOrEmpty()) ...{
                        CustomCodeViewWidget(tag: thread.id.toString(), code: thread.code ?? '',
                          codeLanguage: thread.codeLanguage,
                          onTap: (code, language) {
                            context.push(context.generateRoutePath(subLocation: "thread-code-preview"), extra: {
                              'thread': thread,
                              'code': thread.code,
                              'tag': thread.id.toString()
                            });
                          },
                        ),
                      },

                      /// Poll Section
                      if(thread.poll != null) ...{
                        Container(
                          color: theme.colorScheme.surface,
                          // padding: const EdgeInsets.only(left: threadSymmetricPadding, right: threadSymmetricPadding),
                          child: ThreadPollWidget(
                            thread:  thread,),
                        ),
                      },

                      /// End of main content


                      const SizedBox(height: 10,),
                      RichText(
                        text: TextSpan(
                          text: "Replying to ",
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                          children:  <TextSpan>[
                            //widget.thread!.user!.username ?? ''
                            // TextSpan(text: , style: const TextStyle(color: kAppBlue)),
                            if(participants.isNotEmpty) ... {
                              ...participants.map((user) {
                                final index = participants.indexOf(user);
                                String concatenation = '';

                                if(index == 1){
                                  if(participants.length == 2){
                                    concatenation = ' and ';
                                  }else {
                                    concatenation = ', ';
                                  }

                                }else if(index > 1) {
                                  if(index == participants.length - 1){
                                    concatenation = ' and ';
                                  }else{
                                    concatenation = ', ';
                                  }
                                }
                                return TextSpan(
                                    text: "$concatenation${user.username}", style: const TextStyle(color: kAppBlue),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      // state._profileCubit.fetchProfile(userName: user.username!);
                                    }
                                );
                              })
                              // ... widget.thread!.participants!.map((p)
                              // => TextSpan(text: p.username ?? "", style: const TextStyle(color: kAppBlue)))
                            }
                          ],
                        ),
                      )

                    ],
                  )
              )
            ],
          ),
        )

      // Column(
      //   children: <Widget>[
      //     // profile icon and meta data
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         ///
      //         CustomUserAvatarWidget(
      //           borderSize: 0, size: 30,
      //           networkImage: widget.thread!.user!.profilePictureKey,
      //         ),
      //         const SizedBox(width: 15,),
      //         Expanded(child: )
      //       ],
      //     ),
      //     // // reply content
      //     Padding(
      //       padding: const EdgeInsets.only(left: 20, right: 5),
      //       child: IntrinsicHeight(
      //         child: Row(
      //           mainAxisSize: MainAxisSize.max,
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //
      //             /// vertical line
      //             Container(
      //               color: Colors.red,
      //               child: CustomPaint(
      //                 painter: StraightLinePaint(),
      //               ),
      //               // height: double.maxFinite,
      //               // child: CustomUserAvatarWidget(
      //               //   borderSize: 0, size: 30,
      //               //   networkImage: widget.thread!.user!.profilePictureKey,
      //               // ),
      //             ),
      //             // const SizedBox(width: 18,),
      //             const SizedBox(width: 24,),
      //
      //
      //             Expanded(child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               // crossAxisAlignment: WrapCrossAlignment.start,
      //               // direction: Axis.vertical,
      //               children: <Widget>[
      //
      //                 SizedBox(height: !widget.thread!.message.isNullOrEmpty() ? 2 : 5,),
      //                 /// Main content
      //                 // _content(theme, context),
      //                 ThreadContentWidget<T>(
      //                     entryId: widget.entryId!,
      //                     thread: widget.thread!),
      //                 const SizedBox(height: 10,),
      //                 GestureDetector(
      //                   splashColor: Colors.transparent,
      //                   onTap: () => context.router.push(ProfilePageRoute(user: widget.thread!.user!)),
      //                   child: RichText(
      //                     text: TextSpan(
      //                       text: "Replying to ",
      //                       style: TextStyle(color: theme.colorScheme.onPrimary),
      //                       children:  <TextSpan>[
      //                         TextSpan(text: widget.thread!.user!.username ?? "", style: const TextStyle(color: kAppBlue)),
      //                       ],
      //                     ),
      //                   ),
      //                 )
      //                 //Text( @${}", style: TextStyle(color: theme.colorScheme.onPrimary),),
      //               ],
      //             ))
      //           ],
      //           // crossAxisAlignment: CrossAxisAlignment.stretch,
      //         ),
      //       ),
      //
      //     ),
      //   ],
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   mainAxisSize: MainAxisSize.min,
      // ),
    );
  }
}
