import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/community_item_widget.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:showwcase_v3/features/file_manager/presentation/pages/gifs_picker_page.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_cubit.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_big_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_gif_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_link_preview_meta_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_editor_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_link_preview_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_regular_video_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/fallback_icon_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_editor_request.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_option_model.dart';
import 'package:showwcase_v3/features/threads/presentation/pages/thread_editor_community_list_page.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_editor_parent_thread_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_mention_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:tenor/tenor.dart';

class ThreadEditorPage extends StatefulWidget {
  final ThreadModel? threadToEdit;
  final ThreadModel? threadToReply;
  final String? usernameToReply;
  final CommunityModel? community;

  const ThreadEditorPage(
      {Key? key,
      this.threadToEdit,
      this.threadToReply,
      this.usernameToReply,
      this.community})
      : super(key: key);

  @override
  ThreadEditorPageController createState() => ThreadEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadEditorPageView
    extends WidgetView<ThreadEditorPage, ThreadEditorPageController> {
  const _ThreadEditorPageView(ThreadEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
        leading: const CloseButton(),
        actions: [
          ValueListenableBuilder<Set<String>>(
              valueListenable: state.activatedActions,
              builder: (ctx, Set<String> actions, _) {
                return _sendButton(actions, context);
              })
        ],
        title: ValueListenableBuilder<CommunityModel?>(
          valueListenable: state.selectedCommunity,
          builder: (ctx, CommunityModel? com, ch) {
            final icon = com?.pictureKey != null
                ? "${ApiConfig.profileUrl}/${com?.pictureKey}"
                : '';
            return widget.threadToReply != null
                ? ch!
                : GestureDetector(
                    onTap: () {
                      // _showCommunitiesModal(context);
                      state._changeCommunity(ctx);
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (com != null) ...{
                            IconButton(
                                onPressed: () {
                                  state.selectedCommunity.value = null;
                                },
                                icon: const Icon(
                                  Icons.remove_circle_sharp,
                                  color: kAppRed,
                                  size: 20,
                                ))
                          },
                          if (com != null) ...{
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorScheme.outline),
                                    borderRadius: BorderRadius.circular(5),
                                    color: theme.colorScheme.outline),
                                padding: const EdgeInsets.all(0),
                                child: icon.contains('.svg')
                                    ? SvgPicture.network(
                                        Uri.encodeFull(icon),
                                        placeholderBuilder:
                                            (BuildContext context) =>
                                                const FallBackIconWidget(
                                          name: 'Communities',
                                        ),
                                      )
                                    : CustomNetworkImageWidget(
                                        imageUrl: Uri.encodeFull(icon)),

                                // ,
                              ),
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              com.name ?? '',
                              style: TextStyle(
                                  color: theme.colorScheme.onBackground,
                                  fontSize: defaultFontSize,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )

                            // SizedBox(
                            //   width: mediaQuery.size.width / 2,
                            //   child: ,
                            // )
                          } else ...{
                            Text(
                              "Select Community",
                              style: TextStyle(
                                  color: theme.colorScheme.onBackground,
                                  fontSize: defaultFontSize,
                                  fontWeight: FontWeight.bold),
                            )
                          },
                          const SizedBox(
                            width: 7,
                          ),
                          const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  );
          },
          child: Text(
            "Reply",
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: defaultFontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        automaticallyImplyLeading: false,
        // bottom: const PreferredSize(
        //     preferredSize: Size.fromHeight(2),
        //     child: CustomBorderWidget()
        // ),
      ),
      body: ColoredBox(
        color: theme.brightness == Brightness.dark
            ? const Color(0xff101011)
            : kAppLightGray,
        child: SafeArea(
            child:
            Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Expanded(
                  child: ValueListenableBuilder(valueListenable: state.showAnonymousPostInfo, builder: (_, showAnonymousPostInfo, ch){

                    if(showAnonymousPostInfo) {
                      return Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                            margin: const EdgeInsets.all(threadSymmetricPadding),
                            decoration: BoxDecoration(
                                color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                                border: theme.brightness == Brightness.dark ? null : Border.all(color: theme.colorScheme.outline),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: SeparatedColumn(
                              mainAxisSize: MainAxisSize.min,
                              separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(height: 0,);
                              },
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CloseButton(onPressed: (){
                                    state.showAnonymousPostInfo.value = false;
                                  },),
                                ),

                                Text("Anonymous Post", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("Stay anonymous. Anonymous posts do not include your display name and profile photo.",
                                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, color: theme.colorScheme.onPrimary),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("""Admins, moderators, and Showwcase’s systems can still see the account linked to the anonymous post. Details you include in an anonymous post could reveal your identity. To protect your privacy, some features are disabled.""",
                                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, color: theme.colorScheme.onPrimary),
                                    textAlign: TextAlign.left,
                                  ),
                                )

                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return ch!;

                  }, child: Stack(
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: state._scrollController,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // duration: 700,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // there are different types of content
                              /// Thread (When user is replying to thread)
                              if(widget.threadToReply != null) ...{
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ThreadEditorParentThreadWidget(thread: widget.threadToReply!,),
                                )
                              },

                              Padding(
                                padding: const EdgeInsets.only(left: threadSymmetricPadding, top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   padding: const EdgeInsets.all(4.0),
                                    //   margin: const EdgeInsets.only(top: 5),
                                    //   child: CustomUserAvatarWidget(
                                    //     borderSize: 0, size: 30,
                                    //     username: AppStorage.currentUserSession!.username,
                                    //     networkImage: AppStorage.currentUserSession!.profilePictureKey!,
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 10,),
                                    Expanded(child:Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        ///Create thread content goes here

                                        /// Anonymous posting setting
                                        if(widget.threadToReply == null) ... {
                                          _wrapScrollTag(index: 0, child: GestureDetector(
                                            onTap: () {
                                              // show anonymous post info

                                              state.showAnonymousPostInfo.value = true;
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                                                  // border: theme.brightness == Brightness.dark ? null : Border.all(color: theme.colorScheme.outline),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              margin: const EdgeInsets.only(right: threadSymmetricPadding, bottom: 18),
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SeparatedRow(separatorBuilder: (_, __){
                                                    return const SizedBox(width: 10,);
                                                  }, children: [
                                                    Image.asset("assets/img/anonymous_post_icon.png", width: 20, height: 20,),
                                                    Text("Post Anonymously", style: theme.textTheme.bodyMedium?.copyWith(),),
                                                    SvgPicture.asset("assets/svg/information_circle.svg", width: 18,),
                                                  ],),

                                                  ValueListenableBuilder<bool>(valueListenable: state.anonymousPostEnabled, builder: (_, anonymousPostEnabled, __){
                                                    return SizedBox(
                                                      width: 40,
                                                      height: 30,
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: CupertinoSwitch(value: anonymousPostEnabled, onChanged: (value) {
                                                          if(state.selectedCommunity.value == null){
                                                            context.showSnackBar("Select community to post anonymously ");
                                                            return;
                                                          }
                                                          state.anonymousPostEnabled.value = value;
                                                        },
                                                          activeColor: kAppBlue,

                                                        ),
                                                      ),
                                                    );
                                                  })

                                                ],
                                              ),
                                            ),
                                          )),
                                        },


                                        /// Title section -> Title appears only when user is creating new thread
                                        if(!(widget.threadToReply != null)) ... [
                                          _wrapScrollTag(index: 1, child: ValueListenableBuilder<bool>(valueListenable: state.showTitleField, builder: (ctx, showTitleField, ch) {

                                            if(showTitleField) {
                                              return Container(
                                                // color: Colors.red,
                                                // padding: const EdgeInsets.only(right: threadSymmetricPadding),
                                                margin: const EdgeInsets.only(right: threadSymmetricPadding),
                                                child: TextField(
                                                  focusNode: state.titleFocusNode,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(80),
                                                  ],
                                                  controller: state.titleController,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                                                  style: TextStyle(
                                                      color: theme.colorScheme.onBackground,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  maxLines: null, // makes text field grow downwards
                                                  decoration: InputDecoration(
                                                      enabledBorder: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      hintText:  'Write your title here',
                                                      hintStyle: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      // contentPadding: const EdgeInsets.only(top: 0),
                                                      // contentPadding: EdgeInsets.zero,
                                                      suffixIcon: ValueListenableBuilder<bool>(valueListenable: state.showCloseTitleButton, builder: (_, showCloseTitleButton, __) {

                                                        if(!showCloseTitleButton) {
                                                          return const SizedBox.shrink();
                                                        }

                                                        return IconButton(onPressed: () {
                                                          state.showCloseTitleButton.value = false;
                                                          if(state.titleController.text.isNotEmpty) {
                                                            state.titleController.clear();
                                                            return;
                                                          }
                                                          // state.showTitleField.value = false;
                                                          state.titleFocusNode.unfocus();
                                                          state.contentFocusNode.requestFocus();
                                                        }, icon: const Icon(Icons.close, color: Colors.red,));
                                                      })

                                                  ),
                                                  onChanged: state.onTitleTextChanged,

                                                ),
                                              );
                                            }

                                            // show this if user doesn't want to add title
                                            return CustomButtonWidget(text: 'Add title', onPressed: () {
                                              state.showTitleField.value = true;
                                              state.contentFocusNode.unfocus();
                                              state.titleFocusNode.requestFocus();
                                            }, appearance: Appearance.secondary,);
                                          }))
                                        ],

                                        /// TextField Content
                                        _wrapScrollTag(index: 2, child: Container(
                                          // color: Colors.blue,
                                          margin: const EdgeInsets.only(right: threadSymmetricPadding),
                                          child: ValueListenableBuilder<CommunityModel?>(
                                              valueListenable: state.selectedCommunity,
                                              builder: (ctx, CommunityModel? com, __) {
                                                return TextFormField(
                                                  focusNode: state.contentFocusNode,
                                                  controller: state.messageController,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                                                  style: TextStyle(
                                                      color: theme.colorScheme.onBackground,
                                                      fontSize: 17
                                                  ),
                                                  maxLines: null, // makes text field grow downwards
                                                  decoration: InputDecoration(
                                                    enabledBorder: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    contentPadding: const EdgeInsets.only(top: 0),
                                                    hintText:  widget.threadToReply  == null ? (com != null) ? "Start a discussion with the community ..." : 'Share your knowledge...' : 'Reply here ...',
                                                  ),
                                                  onChanged: state._onTextFieldChanged,
                                                );
                                                //   Theme(
                                                //   data: theme.copyWith(
                                                //       textSelectionTheme:  TextSelectionThemeData(selectionColor: kAppBlue.withOpacity(0.5),),inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(borderSide: BorderSide.none,)),visualDensity: const VisualDensity(vertical: -4,horizontal: -4),
                                                //   ),
                                                //   child: ,
                                                // );
                                              }
                                          ),
                                        )),


                                        const SizedBox(height: 10,),

                                        Padding(
                                          padding: const EdgeInsets.only(right: threadSymmetricPadding),
                                          child: Column(
                                            children: <Widget>[

                                              /// Link Preview Meta Data
                                              ValueListenableBuilder<SharedLinkPreviewMetaModel?>(valueListenable: state.linkPreview, builder: (_, linkPreview, __) {
                                                if(linkPreview == null){
                                                  return const SizedBox.shrink();
                                                }
                                                return Column(
                                                  children: <Widget>[
                                                    Stack(
                                                      children: [

                                                        CustomLinkPreviewWidget(linkPreviewMeta: linkPreview),
                                                        Positioned(right: 10, top: 10,child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: kAppBlack,
                                                          ),
                                                          child: CloseButton(onPressed:() => state.linkPreview.value = null, color: kAppWhite,),
                                                        ),)

                                                      ],
                                                    ),
                                                    const SizedBox(height: 10,)
                                                  ],
                                                );
                                              }),

                                              /// File (image/video) content

                                              //! if we're editing a thread and its a video
                                              // loading / completed / initial

                                              if(widget.threadToEdit != null && widget.threadToEdit!.images != null) ... {
                                                _dispayEditFilesLoader(context, widget.threadToEdit!.images!.length)
                                              },

                                              ValueListenableBuilder<bool>(valueListenable: state.threadToEditHasVideo, builder: (_, hasVideo, ch) {

                                                if(!hasVideo) {
                                                  return const SizedBox.shrink();
                                                }

                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 15),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Stack(
                                                      children: [
                                                        SizedBox(
                                                          width: double.infinity,
                                                          child: CustomRegularVideoWidget(  autoPlay: false, showDefaultControls: true, loop: true,showCustomVolumeButton: false, videoSource: VideoSource.mediaId, tag: widget.threadToEdit?.videoUrl ?? '', mediaId: widget.threadToEdit?.videoUrl ?? '',),
                                                        ),
                                                        Positioned(
                                                          right: 5,
                                                          top: 5,
                                                          child: Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kAppBlack.withOpacity(0.5),
                                                            ),
                                                            child: CloseButton(onPressed:() {
                                                              state.threadToEditHasVideo.value = false;
                                                              state.editedComponents.add(ThreadComponents.video);
                                                            }, color: kAppWhite, ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                );

                                              }),
                                              //! Endo of if we're editing a thread and its a video


                                              ValueListenableBuilder<List<File>?>(
                                                  valueListenable: state.files,
                                                  builder: (ctx, List<File>? files, _){
                                                    if (files == null || files.isEmpty) {
                                                      return const SizedBox.shrink();
                                                    } else {
                                                      /// Single file UI
                                                      if(files.length == 1){
                                                        final file = files.first;
                                                        return  BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                                          selector: (fileManagerState) {
                                                            return fileManagerState.fileItems.firstWhereOrNull(
                                                                  (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 0,
                                                            );
                                                          },
                                                          builder: (context, fileItemss) {

                                                            return Padding(
                                                              padding: const EdgeInsets.only(right: 15),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: Stack(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: double.infinity,
                                                                      child: state.selectedFilesType == RequestType.video ?
                                                                      CustomRegularVideoWidget(file: file,
                                                                        fit: BoxFit.none,
                                                                        autoPlay: false, showDefaultControls: true, loop: true, videoSource: VideoSource.file, tag: file.path,)
                                                                          : Image.file(file),
                                                                    ),
                                                                    Positioned(
                                                                      right: 5,
                                                                      top: 5,
                                                                      child: Container(
                                                                        width: 40,
                                                                        height: 40,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(100),
                                                                          color: kAppBlack.withOpacity(0.5),
                                                                        ),
                                                                        child: CloseButton(onPressed:() => state._removeFile(0), color: kAppWhite,),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );

                                                      }

                                                      const listHeight = 200.0;

                                                      /// return multiple files UI

                                                      return SizedBox(
                                                        height: listHeight,
                                                        child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemBuilder: (ctx, i) {
                                                            final file = files[i];
                                                            return BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                                              selector: (fileManagerState) {
                                                                return fileManagerState.fileItems.firstWhereOrNull(
                                                                      (element) => element.groupId == state.fileUploadGroupId && element.fileTag == i,
                                                                );
                                                              },
                                                              builder: (context, fileItem) {

                                                                return Padding(
                                                                  padding: const EdgeInsets.only(right: 10),
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Stack(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: listHeight,
                                                                          height: listHeight,
                                                                          child: Image.file(file, fit: BoxFit.cover,),
                                                                        ),
                                                                        Positioned(
                                                                          right: 5,
                                                                          top: 5,
                                                                          child: Container(
                                                                            width: 40,
                                                                            height: 40,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              color:  theme.colorScheme.primary,
                                                                            ),
                                                                            child: CloseButton(onPressed:() => state._removeFile(files.indexOf(file)),),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );


                                                          }, itemCount: files.length,),
                                                      );
                                                    }
                                                  }
                                              ),

                                              /// CodeView content

                                              ValueListenableBuilder(valueListenable: state.attachCode, builder: (ctx, bool code, _){
                                                if (!code) {
                                                  return const SizedBox.shrink();
                                                }
                                                return CustomCodeEditorWidget(
                                                  onClose: () => state._toggleCodeEditor(false),
                                                  onChange: (text) => state.codeContent = text,
                                                  initialCodeContent:  state.codeContent,
                                                  onLanguageChanged: (value) =>  state.codeLanguage = value,
                                                );

                                              }),

                                              /// Poll Content
                                              ValueListenableBuilder<ThreadPollModel?>(
                                                  valueListenable: state.poll,
                                                  builder: (ctx, ThreadPollModel? poll, _){
                                                    if (poll == null) {
                                                      return const SizedBox.shrink();
                                                    } else {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: theme.brightness == Brightness.dark ? kAppFaintBlack : kAppWhite,
                                                            // border: theme.brightness == Brightness.light ? Border.all(color: theme.color),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        padding: const EdgeInsets.all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children:  [
                                                                Text('', style: TextStyle(fontWeight: FontWeight.w800, color: theme.colorScheme.onBackground),),
                                                                GestureDetector(onTap: state._removePoll, child: Icon(Icons.close, color: theme.colorScheme.onPrimary,))
                                                              ],
                                                            ),

                                                            /// Question
                                                            // TextFormField(
                                                            //   focusNode: state.pollQuestionFocusNode,
                                                            //   controller: state.pollQuestionController,
                                                            //   cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                                                            //   style: TextStyle(color: theme.colorScheme.onBackground),
                                                            //   maxLines: null, // makes text field grow downwards
                                                            //   decoration: const InputDecoration(
                                                            //     enabledBorder: InputBorder.none,
                                                            //     focusedBorder: InputBorder.none,
                                                            //     border: InputBorder.none,
                                                            //     hintText: 'What are we polling?',
                                                            //   ),
                                                            //   onChanged: state._onTextFieldChanged,
                                                            // ),

                                                            /// option text fields
                                                            const SizedBox(height: 10,),
                                                            ...state.pollOptionsEditingControllers.map((controller) {
                                                              final index = state.pollOptionsEditingControllers.indexOf(controller);
                                                              final isLastItem = index == (state.pollOptionsEditingControllers.length - 1);
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 10),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  child: TextField(
                                                                    controller: state.pollOptionsEditingControllers[index],
                                                                    textCapitalization: TextCapitalization.sentences,
                                                                    style: TextStyle(color: theme.colorScheme.onBackground),
                                                                    cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                                                                    decoration:  InputDecoration(
                                                                        filled: true,
                                                                        border: InputBorder.none,
                                                                        enabledBorder: InputBorder.none,
                                                                        hintText: 'Add an option',
                                                                        suffixIcon: isLastItem ?
                                                                        GestureDetector(
                                                                          onTap: state._addPollOption,
                                                                          child: Container( /// last item
                                                                              decoration: BoxDecoration(
                                                                                  color: kAppBlue,
                                                                                  borderRadius: BorderRadius.circular(100)
                                                                              ),
                                                                              margin: const EdgeInsets.all(10),
                                                                              child: const Icon(Icons.add, size: 18,)
                                                                          ),
                                                                        )
                                                                            : GestureDetector(
                                                                          onTap: () => state._removePollOption(index: index),
                                                                          child: Container( // non last item
                                                                              decoration: BoxDecoration(
                                                                                  color: kAppRed,
                                                                                  borderRadius: BorderRadius.circular(100)
                                                                              ),
                                                                              margin: const EdgeInsets.all(10),
                                                                              child: const Icon(Icons.close, size: 18,)
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),

                                                            // const SizedBox(height: 20,),

                                                            ValueListenableBuilder<String?>(valueListenable: state.pollExpiryDate, builder: (ctx, String? value, _){
                                                              if(value == null) return const SizedBox.shrink();

                                                              if(value.toLowerCase() == "expired") {
                                                                return Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text('Poll duration ended', style: TextStyle(color: theme.colorScheme.onPrimary),),
                                                                );
                                                              }

                                                              return TextButton(onPressed: () {
                                                                _showPollExpiryDate(ctx);
                                                                state.pollDurationDaysFocusNode.requestFocus();
                                                              },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        text: "Expiry ",
                                                                        style: TextStyle(color: theme.colorScheme.onPrimary),
                                                                        children: <TextSpan>[
                                                                          TextSpan(text: value, style: const TextStyle(color: kAppBlue)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onPrimary, ),
                                                                  ],
                                                                ),
                                                              );
                                                            })


                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),

                                              /// Gif Content
                                              ValueListenableBuilder<TenorResult?>(
                                                  valueListenable: state.gif,
                                                  builder: (ctx, TenorResult? gifItem, _){
                                                    if (gifItem == null) {
                                                      return const SizedBox.shrink();
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                              width: double.infinity,
                                                              child: CachedNetworkImage(
                                                                imageUrl: gifItem.media?.gif?.url ?? '',
                                                                errorWidget: (context, url, error) => const SizedBox.shrink(),
                                                                placeholder: (ctx, url) => const  SizedBox(
                                                                  width: double.maxFinite, height: 100,
                                                                  child: Center(
                                                                      child: CustomAdaptiveCircularIndicator(),
                                                                    ),
                                                                ),
                                                                cacheKey: gifItem.media?.gif?.url ?? '',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 5,
                                                              top: 5,
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  color: theme.colorScheme.primary,
                                                                ),
                                                                child: CloseButton(onPressed: state._onRemoveGifItem,),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),

                                              SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)

                                            ],
                                          ),
                                        )

                                      ],
                                    )
                                    )
                                  ],
                                ),
                              ),

                              // SizedBox(height: mediaQuery.size.height / 1.65,)
                              // if(widget.threadToReply != null) ...{
                              //   SizedBox(height: mediaQuery.size.height,)
                              // }
                              SizedBox(height: mediaQuery.size.height,)

                            ],
                          )
                      ),

                      /// Mentions Content UI
                      /// This UI displays the users when user types the @ symbol
                      ValueListenableBuilder<List<UserModel>>(valueListenable: state.suggestedMentionedUsers, builder: (ctx, List<UserModel> showSuggestedUsers, _){
                        if(showSuggestedUsers.isEmpty){
                          return const SizedBox.shrink();
                        }
                        return  Positioned.fill(
                            top: mediaQuery.size.height / 5,
                            child: Column(
                              children: [
                                ValueListenableBuilder<bool>(valueListenable: state.showThreadEditorLoadingIndicator, builder: (_, showEditorLoader, __){
                                  if(showEditorLoader){
                                    return   const LinearProgressIndicator(minHeight: 2, color: kAppBlue,);
                                  }
                                  return const SizedBox.shrink();
                                }),
                                Expanded(child: Container(
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      border: Border(top: BorderSide(color: theme.colorScheme.outline))
                                  ),
                                  child: ListView.builder(itemBuilder: (ctx, i) {
                                    final user = showSuggestedUsers[i];
                                    return GestureDetector(
                                      onTap: () => state._onUserInMentionSuggestionsTapped(user),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15, top:  15),
                                        child: Row(
                                          children: [
                                            CustomUserAvatarWidget(networkImage: user.profilePictureKey, username: user.username, size: 50,),
                                            const SizedBox(width: 10,),
                                            Expanded(child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(user.displayName ?? "", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
                                                const SizedBox(height: 1,),
                                                Text("@${user.username ?? ""}", style: TextStyle(color: theme.colorScheme.onPrimary),)
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    );

                                  }, itemCount: showSuggestedUsers.length,),
                                ))
                              ],
                            ));
                      }),

                      /// Community Mentions
                      ValueListenableBuilder<List<CommunityModel>>(valueListenable: state.suggestedMentionedCommunities, builder: (ctx, List<CommunityModel> showSuggestedMentionedCommunities, _) {

                        if(showSuggestedMentionedCommunities.isEmpty){
                          return const SizedBox.shrink();
                        }

                        return Positioned.fill(
                            top: mediaQuery.size.height / 5 ,
                            child: Column(
                              children: [
                                ValueListenableBuilder<bool>(valueListenable: state.showThreadEditorLoadingIndicator, builder: (_, showEditorLoader, __){
                                  if(showEditorLoader){
                                    return   const LinearProgressIndicator(minHeight: 2, color: kAppBlue,);
                                  }
                                  return const SizedBox.shrink();
                                }),
                                Expanded(child:  Container(
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      border: Border(top: BorderSide(color: theme.colorScheme.outline))
                                  ),
                                  child: ListView.builder(itemBuilder: (ctx, i) {
                                    final community = showSuggestedMentionedCommunities[i];
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        if(community.slug == ''){
                                          return;
                                        }
                                        state._onCommunityMentionsActionTapped(community.slug ?? '');

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15, top:  0),
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: CommunityItemWidget(
                                            community: community,
                                            showJoinedAction: false,
                                            onTap: () {},
                                            pageName: threadEditorPage,
                                            containerName: 'thread_editor_dropdown',
                                          ),
                                        ),
                                      ),
                                    );

                                  }, itemCount: showSuggestedMentionedCommunities.length,),
                                ))
                              ],
                            )

                        );
                      })


                    ],
                  ),)
              ),


              /// Thread editor action bar ------
              //!
              ValueListenableBuilder<List<CommunityModel>>(
                  valueListenable: state.suggestedMentionedCommunities,
                  builder: (_, suggestedMentionedCommunities, __) {
                    if (suggestedMentionedCommunities.isNotEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ValueListenableBuilder<List<UserModel>>(
                        valueListenable: state.suggestedMentionedUsers,
                        builder:
                            (ctx, List<UserModel> suggestedMentionedUsers, _) {
                          if (suggestedMentionedUsers.isNotEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: <Widget>[
                              ValueListenableBuilder<ThreadPollModel?>(
                                  valueListenable: state.poll,
                                  builder: (ctx, ThreadPollModel? poll, _) {
                                    if (poll == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return _pollVisibilityActions(context);
                                  }),
                              _bottomActionsUI(context)
                            ],
                          );
                        });
                  })
            ],
          ),
        )
        ),
      ),
    );
  }
  // Container(
  //                 padding: const EdgeInsets.all(10),
  //                 margin: const EdgeInsets.all(threadSymmetricPadding),
  //                 decoration: BoxDecoration(
  //                     color: theme.colorScheme.background,
  //                     borderRadius: BorderRadius.circular(5)),
  //                 child: SeparatedColumn(
  //                   mainAxisSize: MainAxisSize.min,
  //                   separatorBuilder: (BuildContext context, int index) {
  //                     return const SizedBox(
  //                       height: 10,
  //                     );
  //                   },
  //                   children: [
  //                     // Align(
  //                     //   alignment: Alignment.topRight,
  //                     //   child: ,
  //                     // ),
  //                     CloseButton(
  //                       onPressed: () {
  //                         state.showAnonymousPostInfo.value = false;
  //                       },
  //                     ),
  //                     Text(
  //                       "Anonymous Post",
  //                       style: theme.textTheme.bodyLarge?.copyWith(),
  //                     ),
  //                     Text(
  //                       "Stay anonymous. Anonymous posts do not include your display name and profile photo.",
  //                       style: theme.textTheme.bodyLarge?.copyWith(),
  //                     )
  //                   ],
  //                 ),
  //               ),

  Widget _wrapScrollTag({required int index, required Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: state._scrollController,
      index: index,
      child: child,
    );
  }

  Widget _dispayEditFilesLoader(BuildContext context, int count) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: state.networkToFilesLoading,
      builder: (_, loading, ch) {
        if (!loading) {
          return const SizedBox.shrink();
        }

        return ch!;
      },
      child: count < 1
          ? const SizedBox.shrink()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (count > 1) ...{
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(count, (index) => index).map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kAppBlue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  )
                },
                if (count == 1) ...{
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10)),
                    child: const AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kAppBlue,
                        ),
                      ),
                    ),
                  )
                }
              ],
            ),
    );
  }

  /// Bottom actions (add images, code, add gif, mentions, send)
  Widget _bottomActionsUI(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        ValueListenableBuilder<bool>(
            valueListenable: state.showThreadEditorLoadingIndicator,
            builder: (_, showEditorLoader, __) {
              if (showEditorLoader) {
                return const LinearProgressIndicator(
                  minHeight: 2,
                  color: kAppBlue,
                );
              }
              return const SizedBox.shrink();
            }),
        Divider(
          color: theme.colorScheme.outline,
          height: 1,
        ),
        ValueListenableBuilder<Set<String>>(
          valueListenable: state.activatedActions,
          builder: (ctx, Set<String> actions, _) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              color: theme.colorScheme.background,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: actions.contains('file')
                                    ? state._openGallery
                                    : null,
                                icon: SvgPicture.asset(
                                  kCircularAddIconSvg,
                                  color: actions.contains('file')
                                      ? kAppBlue
                                      : kAppGray,
                                )),
                            IconButton(
                                onPressed: actions.contains('code')
                                    ? () => state._toggleCodeEditor(true)
                                    : null,
                                icon: SvgPicture.asset(kCodeIconSvg,
                                    color: actions.contains('code')
                                        ? kAppBlue
                                        : kAppGray)),
                            IconButton(
                                onPressed: actions.contains('mention')
                                    ? state._onMentionsActionButtonTapped
                                    : null,
                                icon: SvgPicture.asset(kMentionIconSvg,
                                    color: actions.contains('mention')
                                        ? kAppBlue
                                        : kAppGray)),
                            GestureDetector(
                              onTap: actions.contains('asd9')
                                  ? state._onASD9ButtonTapped
                                  : null,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xff6989ff),
                                      Color(0xff49c6ff),
                                    ]),
                                    borderRadius: BorderRadius.circular(5)),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 9),
                                padding: const EdgeInsets.all(2),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset(
                                    kASD9IconPng,
                                    color: kAppBlack,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: actions.contains('gif')
                                    ? () => chooseGif(context)
                                    : null,
                                icon: SvgPicture.asset(kGifIconSvg,
                                    colorFilter: ColorFilter.mode(
                                        actions.contains('gif')
                                            ? kAppBlue
                                            : kAppGray,
                                        BlendMode.srcIn))),
                            IconButton(
                                onPressed: actions.contains('poll')
                                    ? state.createPoll
                                    : null,
                                icon: SvgPicture.asset(kPollIconSvg,
                                    colorFilter: ColorFilter.mode(
                                        actions.contains('poll')
                                            ? kAppBlue
                                            : kAppGray,
                                        BlendMode.srcIn))),
                            // const Spacer(),

                            if (widget.threadToReply == null) ...{
                              ValueListenableBuilder<bool?>(
                                  valueListenable: state.isScheduled,
                                  builder: (ctx, isScheduled, _) {
                                    return IconButton(
                                        onPressed: () {
                                          _showScheduledDate(
                                              context); // show date time
                                        },
                                        icon: SvgPicture.asset(kScheduleIconSvg,
                                            color: actions.contains('schedule')
                                                ? ((isScheduled ?? false)
                                                    ? kAppRed
                                                    : kAppBlue)
                                                : kAppGray));
                                  })
                            },
                          ],
                        ),
                      ),
                    ),

                    // VerticalDivider(color: theme.colorScheme.outline, width: 1,),
                    // Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: UnconstrainedBox(child: _sendButton(actions, context),),
                    // )
                  ],
                ),
              ),
            );
          },
        ),
        Divider(
          color: theme.colorScheme.outline,
          height: 1,
        ),
      ],
    );
  }

  /// show POll Expiry Date
  _showPollExpiryDate(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.primary,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        state._setPollExpiryDate();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(color: kAppBlue, fontSize: 18),
                      )),
                ),
                const CustomBorderWidget(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: state.pollDurationDaysController,
                    focusNode: state.pollDurationDaysFocusNode,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    cursorColor: theme.colorScheme.onPrimary,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.colorScheme.outline)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.colorScheme.outline)),
                        hintText: "Days",
                        prefixIcon: UnconstrainedBox(
                          child: Text(
                            "Days",
                            style:
                                TextStyle(color: theme.colorScheme.onPrimary),
                          ),
                        )),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: state.pollDurationHoursController,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    cursorColor: theme.colorScheme.onPrimary,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.colorScheme.outline)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.colorScheme.outline)),
                        hintText: "Hours",
                        prefixIcon: UnconstrainedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Hours",
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
                            ),
                          ),
                        )),
                  ),
                ),

                TextField(
                  controller: state.pollDurationMinutesController,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  cursorColor: theme.colorScheme.onPrimary,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.colorScheme.outline)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.colorScheme.outline)),
                      hintText: "Minutes",
                      prefixIcon: UnconstrainedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Minutes",
                            style:
                                TextStyle(color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                )
                // const SizedBox(height: kToolbarHeight,)
              ],
            ),
          );
        },
        enableDrag: true);
  }

  Widget _pollVisibilityActions(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return ValueListenableBuilder<String>(
        valueListenable: state.pollVisibility,
        builder: (ctx, String value, _) {
          return Container(
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: theme.colorScheme.outline))),
            padding: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: () => _showPollVisibilityModal(ctx),
              child: Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: theme.colorScheme.onPrimary,
                  )
                ],
              ),
            ),
          );
        });
  }

  /// public / Anonymous
  _showPollVisibilityModal(BuildContext ctx) {
    final theme = Theme.of(ctx);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.primary,
        context: ctx,
        builder: (ctx) {
          return ValueListenableBuilder<String>(
              valueListenable: state.pollVisibility,
              builder: (ctx, String visibility, _) {
                return SafeArea(
                  top: false,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              state.pollVisibility.value = "Public";
                              Navigator.of(ctx).pop();
                            },
                            title: Text(
                              "Public",
                              style: TextStyle(
                                  color: theme.colorScheme.onBackground),
                            ),
                            trailing: visibility == "Public"
                                ? const Icon(Icons.check)
                                : null,
                          ),
                          // const CustomBorderWidget(),
                          ListTile(
                            onTap: () {
                              state.pollVisibility.value = "Anonymous";
                              Navigator.of(ctx).pop();
                            },
                            title: Text(
                              "Anonymous",
                              style: TextStyle(
                                  color: theme.colorScheme.onBackground),
                            ),
                            trailing: visibility == "Anonymous"
                                ? const Icon(Icons.check)
                                : null,
                          ),
                          const SizedBox(
                            height: 2 * kToolbarHeight,
                          )
                        ],
                      )),
                );
              });
        });
  }

  /// show Schedule modal
  _showScheduledDate(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
        enableDrag: true,
        context: context,
        backgroundColor: theme.colorScheme.primary,
        isScrollControlled: true,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        state.isScheduled.value = false;
                      },
                      child: const Text(
                        "Cancel schedule",
                        style: TextStyle(color: kAppRed, fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        state.isScheduled.value = true;
                      },
                      child: const Text(
                        "Schedule",
                        style: TextStyle(color: kAppBlue, fontSize: 14),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                const CustomBorderWidget(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Want to publish your Thread later ?',
                  style: theme.textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Schedule to publish it automatically later',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomBorderWidget(),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomTextFieldWidget(
                      placeHolder: 'specify date',
                      label: 'Date',
                      controller: state.scheduledDateController,
                      focusNode: state.scheduleFocusNode,
                      readOnly: true,
                      onTap: () => selectScheduledDate(ctx),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: CustomTextFieldWidget(
                      controller: state.scheduledTimeController,
                      placeHolder: 'specify time',
                      label: 'Time',
                      readOnly: true,
                      onTap: () => selectScheduledTime(ctx),
                    )),
                  ],
                ),
                const SizedBox(
                  height: kToolbarHeight,
                )
              ],
            ),
          );
        });
    //     .whenComplete(() {
    //   state.scheduleFocusNode.requestFocus();
    // });
  }

  Widget _sendButton(Set<String> actions, BuildContext context) {
    return TextButton(
        onPressed: actions.contains('send')
            ? state._handleThreadEditorSubmission
            : null,
        child: Text(
          "Post",
          style: TextStyle(
              color: actions.contains('send')
                  ? kAppBlue
                  : theme(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ));
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(100),
    //   child: GestureDetector(
    //     onTap: actions.contains('send') ? state._handleThreadEditorSubmission : null, /// submit thread tapped
    //     child: Container(
    //       padding: const EdgeInsets.all(8),
    //       color: actions.contains('send') ? kAppBlue : theme(context).colorScheme.outline,
    //       // child: SvgPicture.asset(kSendIconSvg, colorFilter:  ColorFilter.mode(actions.contains('send') ? kAppWhite : kAppGray, BlendMode.srcIn),
    //       //   width: 22,
    //       //   // height: 22,
    //       // ),
    //
    //     ),
    //     // ,
    //   ),
    // );
  }

  /// Schedule Time
  Future<void> selectScheduledDate(BuildContext context) async {
    showAppDatePicker(context, firstDate: DateTime.now(),
        onDateSelected: (dateTime) {
      final f1 = DateFormat('yyyy-MM-dd');
      state.scheduledDate = f1.format(dateTime);
      final f = DateFormat('MMM dd, yyyy');
      state.scheduledDateController.text = f.format(dateTime);
    });
  }

  /// Schedule Date
  Future<void> selectScheduledTime(BuildContext context) async {
    final theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (ctx, ch) {
          return Theme(
            data: theme.brightness == Brightness.dark
                ? ThemeData.dark().copyWith()
                : ThemeData.light().copyWith(),
            child: ch!,
          );
        });

    if (picked != null) {
      // pickupTime = picked;

      final f1 = DateFormat('hh:mm:ss');
      final f = DateFormat('hh:mm a');
      final now = DateTime.now();
      final rawDate =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      state.scheduledTime = f1.format(rawDate);
      state.scheduledTimeController.text = f.format(rawDate);
    }
  }

  /// Gif
  chooseGif(BuildContext context) {
    state.contentFocusNode.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.90,
          builder: (_, controller) {
            return GifsPickerPage(
              onTap: state._onGifSelected,
            );
          }),
      // bounce: true
      // useRootNavigator: true,
      // expand: false
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadEditorPageController extends State<ThreadEditorPage> {
  late RichTextController messageController;
  late TextEditingController titleController;
  final ValueNotifier<bool> showTitleField = ValueNotifier(true);
  final ValueNotifier<bool> showCloseTitleButton = ValueNotifier(false);
  final ValueNotifier<bool> anonymousPostEnabled = ValueNotifier(false);
  final ValueNotifier<bool> showAnonymousPostInfo = ValueNotifier(false);
  late FocusNode contentFocusNode;
  late FocusNode titleFocusNode;
  late FocusNode pollQuestionFocusNode;
  late FocusNode scheduleFocusNode;
  late TextEditingController pollQuestionController;
  final ValueNotifier<List<File>?> files = ValueNotifier(null);
  RequestType? selectedFilesType;
  final ValueNotifier<bool> attachCode = ValueNotifier(false);
  final Set<UserMentionModel> mentionedUsers = <UserMentionModel>{};
  final ValueNotifier<List<UserModel>> suggestedMentionedUsers =
      ValueNotifier([]);
  final ValueNotifier<List<CommunityModel>> suggestedMentionedCommunities =
      ValueNotifier([]);
  final ValueNotifier<String?> noUsersFound = ValueNotifier(null);
  final ValueNotifier<ThreadPollModel?> poll = ValueNotifier(null);
  final ValueNotifier<TenorResult?> gif = ValueNotifier(null);
  late ThreadCubit _threadsCubit;
  late FileManagerCubit _fileManagerCubit;

  // late StreamSubscription<SharedState> _sharedCubitStreamListener;
  late UserProfileCubit _userCubit;
  late SharedCubit _sharedCubit;
  late CommunityCubit _communitiesCubit;
  final Map<int, String?> uploadedFiles =
      {}; // this records the uploaded images, the index corresponds with the index of ValueNotifier<List<File>?> files

  String codeContent = '';
  String codeLanguage = defaultCodeLanguage;
  final ValueNotifier<String?> pollExpiryDate = ValueNotifier(null);
  final ValueNotifier<String> pollVisibility = ValueNotifier('Public');

  late TextEditingController pollDurationDaysController;
  late TextEditingController pollDurationHoursController;
  late TextEditingController pollDurationMinutesController;
  late FocusNode pollDurationDaysFocusNode;
  String? scheduledDate, scheduledTime;

  ValueNotifier<bool?> isScheduled = ValueNotifier(null);

  //? community;
  late ValueNotifier<CommunityModel?> selectedCommunity;
  final ValueNotifier<SharedLinkPreviewMetaModel?> linkPreview =
      ValueNotifier(null);
  late TextEditingController scheduledDateController, scheduledTimeController;

  final initialActions = <String>{
    'file',
    'code',
    'mention',
    'asd9',
    'gif',
    'poll',
    'schedule'
  };
  late ValueNotifier<Set<String>> activatedActions;

  final pollOptionsEditingControllers = <TextEditingController>[];

  /// ref -> https://pub.dev/packages/scroll_to_index.
  late AutoScrollController _scrollController;

  // final VideoCubit _videoCubit = VideoCubit();
  // ValueNotifier<String>  fetchVideoFileFromUrl = ValueNotifier("INITIAL"); // INITIAL / LOADING / COMPLETED

  final ValueNotifier<bool> networkToFilesLoading = ValueNotifier(false);
  final ValueNotifier<bool> showThreadEditorLoadingIndicator =
      ValueNotifier(false);

  final Set<ThreadComponents> editedComponents = {};

  ValueNotifier<bool> threadToEditHasVideo = ValueNotifier(false);
  final String fileUploadGroupId = "thread_editor_page";

  // /// Mentions section
  final prevMentionUsernames = <String>{};

  @override
  Widget build(BuildContext context) => _ThreadEditorPageView(this);

  @override
  void initState() {
    super.initState();

    _userCubit = context.read<UserProfileCubit>();
    _communitiesCubit = context.read<CommunityCubit>();
    _fileManagerCubit = context.read<FileManagerCubit>();
    _threadsCubit = context.read<ThreadCubit>();
    _sharedCubit = context.read<SharedCubit>();

    contentFocusNode = FocusNode();
    contentFocusNode.addListener(() {
      debugPrint('contentFocusNode:  ${contentFocusNode.hasFocus}');
      _scrollToIndex(2);
    });
    titleFocusNode = FocusNode();
    pollDurationDaysFocusNode = FocusNode();
    pollQuestionFocusNode = FocusNode();
    scheduleFocusNode = FocusNode();
    pollQuestionController = TextEditingController();
    pollDurationDaysController = TextEditingController();
    pollDurationHoursController = TextEditingController();
    pollDurationMinutesController = TextEditingController();
    scheduledDateController = TextEditingController();
    scheduledTimeController = TextEditingController();

    selectedCommunity = ValueNotifier(widget.community);

    /// set poll duration
    pollDurationDaysController.text = "5";
    pollDurationHoursController.text = "1";
    pollDurationMinutesController.text = "0";

    titleController = TextEditingController();
    messageController = RichTextController(
      patternMatchMap: {
        //* Returns every Mention with blue color and bold style.
        //
        RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
          color: kAppBlue,
        ),
        RegExp(r"(?:^\b|)(c/[a-z0-9-]+)", caseSensitive: false):
            const TextStyle(
          color: kAppBlue,
        ), // community detector
        RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"):
            const TextStyle(
          color: kAppBlue,
        )
      },
      deleteOnBack: false,
      onMatch: (List<String> matches) {
        // logger.i("matches: $matches");
        if (matches.isNotEmpty) {
          EasyDebounce.debounce('thread-editor-url-preview-on-text-change',
              const Duration(microseconds: 800), () async {
            final word = matches[matches.length - 1];
            final exp = RegExp(
                r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
            final urlMatch = exp.firstMatch(word);
            if (urlMatch != null) {
              final data =
                  await _sharedCubit.fetchPreviewMetaDataFromUrl(url: word);
              linkPreview.value = data;
            }
          });
        }
      },
    );
    activatedActions = ValueNotifier(initialActions);
    _scrollController = AutoScrollController(
      //add this for advanced viewport boundary. e.g. SafeArea
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).viewInsets.bottom),

      //choose vertical/horizontal
      axis: Axis.vertical,
    );

    /// thread schedule
    //time
    final tf1 = DateFormat('hh:mm:ss');
    final tf = DateFormat('hh:mm a');
    final now = DateTime.now();
    final rawDate =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    scheduledTimeController.text = tf.format(rawDate);
    scheduledTime = tf1.format(rawDate);

    // date
    final df1 = DateFormat('yyyy-MM-dd');
    final df = DateFormat('MMM dd, yyyy');
    scheduledDateController.text = df.format(DateTime.now());
    scheduledDate = df1.format(DateTime.now());

    onWidgetBindingComplete(
        onComplete: () async {
          if(widget.threadToReply == null) {
            titleFocusNode.requestFocus();
          }else{
            //if this reply is for a thread , scroll to text field, to give enough space
            contentFocusNode.requestFocus();
          }


        },
        milliseconds: (widget.threadToReply != null) ? 200 : 100);

    // Edit thread
    _setupThreadUIForEditing();

    // //if the user clicked from the thread preview page,
    // onWidgetBindingComplete(onComplete: (){
    //   final routeInfo = GoRouter.of(context).routeInformationParser;
    //   debugPrint("routeInfo: -> ${routeInfo}");
    // });

  }

  _onMentionsActionButtonTapped() {
    // _scrollController.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
    // _showHideUsers(show: !showUsers.value);
    // messageController.text = messageController.text + '@';
    // messageController.selection = TextSelection.fromPosition(TextPosition(offset: messageController.text.length));
    _addTextToCursorPosition('@');
    _triggerMentionedUsersOnTextChanged(messageController.text);
  }

  _triggerMentionedUsersOnTextChanged(String newQuery) {
    // from here, the last prefix word contains an @ sign

    EasyDebounce.debounce(
        'search-mentioned-user-debouncer',
        // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500), // <-- The debounce duration
        () async {
      String tempQuery = newQuery;

      if (tempQuery.isEmpty) {
        if (suggestedMentionedUsers.value.isNotEmpty) {
          suggestedMentionedUsers.value = [];
          _scrollToIndex(0);
        }
        // _threadsCubit.resetUrlMeta();
        return;
      }

      // get the word at the cursor's current position
      var cursorPos = messageController.selection.base.offset;
      String prefixText = messageController.text.substring(0, cursorPos);
      final prefixWords = prefixText.split(" ");
      final lastPrefixWord = prefixWords.last;
      if (lastPrefixWord == " ") {
        suggestedMentionedUsers.value = [];
        return;
      }
      if (!lastPrefixWord.startsWith("@")) {
        suggestedMentionedUsers.value = [];
        return;
      }

      final regex = RegExp(r"\B@[a-zA-Z0-9]+\b"); // mention regex
      final matches = _allStringMatches(tempQuery, regex);

      if (matches.isNotEmpty) {
        final matchesAsSet = matches.toSet();
        final diffInSets = matchesAsSet.difference(prevMentionUsernames);
        // pick the first difference in set
        if (diffInSets.isNotEmpty) {
          debugPrint("mention text: $lastPrefixWord");
          prevMentionUsernames.clear();
          prevMentionUsernames.addAll(matchesAsSet);
          showThreadEditorLoadingIndicator.value = true;
          final users =
              await _userCubit.searchUser(keyword: lastPrefixWord.substring(1));
          showThreadEditorLoadingIndicator.value = false;
          if ((users ?? []).isEmpty) {
            suggestedMentionedUsers.value = [];
          } else {
            suggestedMentionedUsers.value = users!;
          }
        }
      }
    });
  }

  _triggerMentionedSuggestedCommunitiesOnTextChanged(String newQuery) {
    // from here, the last prefix word contains an @ sign

    EasyDebounce.debounce(
        'search-mentioned-communities-debouncer',
        // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500), // <-- The debounce duration
        () async {
      String tempQuery = newQuery;

      if (tempQuery.isEmpty) {
        if (suggestedMentionedCommunities.value.isNotEmpty) {
          suggestedMentionedCommunities.value = [];
          _scrollToIndex(1);
        }
        return;
      }

      // get the word at the cursor's current position
      var cursorPos = messageController.selection.base.offset;
      String prefixText = messageController.text.substring(0, cursorPos);
      final prefixWords = prefixText.split(" ");
      final lastPrefixWord = prefixWords.last;
      if (lastPrefixWord == " ") {
        suggestedMentionedCommunities.value = [];
        return;
      }
      if (!lastPrefixWord.toLowerCase().startsWith("c/")) {
        suggestedMentionedCommunities.value = [];
        return;
      }

      final regex = RegExp(r'\bc/\w*', caseSensitive: false); // mention regex
      final matches = _allStringMatches(tempQuery, regex);

      if (matches.isNotEmpty) {
        // final matchesAsSet = matches.toSet();
        // final diffInSets = matchesAsSet.difference(prevCommunityMentions);
        // pick the first difference in set
        // if (diffInSets.isNotEmpty) {
        //   _showHideCommunities(show: true);
        //   debugPrint("mention text: $lastPrefixWord");
        //   // prevCommunityMentions.clear();
        //   // prevCommunityMentions.addAll(matchesAsSet);
        //
        // }
        showThreadEditorLoadingIndicator.value = true;
        final communities = await _communitiesCubit.searchCommunities(
            keyword: lastPrefixWord.substring(1));
        showThreadEditorLoadingIndicator.value = false;
        if ((communities ?? []).isEmpty) {
          suggestedMentionedCommunities.value = [];
        } else {
          suggestedMentionedCommunities.value = communities!;
        }
      }
    });
  }

  Iterable<String> _allStringMatches(String text, RegExp regExp) =>
      regExp.allMatches(text).map((m) => m.group(0) ?? '');

  // _showHideSuggestedMentionedUsers({required bool show}){
  //   showMentionedSuggestedUsers.value = show ? ;
  // }
  //
  // _showHideCommunities({required bool show}){
  //   showMentionedSuggestedCommunities.value = show;
  // }

  void onTitleTextChanged(String value) {
    _refreshActions();
    if (!editedComponents.contains(ThreadComponents.title)) {
      editedComponents.add(ThreadComponents.title);
    }
    showCloseTitleButton.value = value.isNotEmpty;
  }

  _onTextFieldChanged(String text) {
    _refreshActions();
    _triggerMentionedUsersOnTextChanged(text);
    _triggerMentionedSuggestedCommunitiesOnTextChanged(text);
    if (!editedComponents.contains(ThreadComponents.message)) {
      editedComponents.add(ThreadComponents.message);
    }
  }

  /// pick an image/video
  _openGallery() async {
    contentFocusNode.unfocus();

    final filesReturned = await pickFilesFromGallery(context,
        multiple: true, requestType: RequestType.common);
    if (filesReturned == null || filesReturned.isEmpty) {
      return null;
    }

    if (threadToEditHasVideo.value == true) {
      threadToEditHasVideo.value = false;
    }

    final List<File> myFiles = files.value != null ? [...files.value!] : [];

    // multiple files
    if (filesReturned.length > 1) {
      if (selectedFilesType == RequestType.video) {
        myFiles.clear();
      }

      myFiles.addAll(filesReturned);
      selectedFilesType = RequestType.image;
      editedComponents.add(ThreadComponents.images);
    } else {
      // single file
      final fileType = getFileType(path: filesReturned.first.path);

      if (fileType == null)
        return; // type determination is not expected to be null

      // this file could be an image or video
      if ((fileType['type'] as RequestType) == RequestType.image) {
        // if its image add to existing files
        myFiles.add(filesReturned.first);
        selectedFilesType = RequestType.image;
        editedComponents.add(ThreadComponents.images);
      } // if its video replace all existing files with this video
      else if ((fileType['type'] as RequestType) == RequestType.video) {
        // //todo trim video first

        if (selectedFilesType == RequestType.video &&
            files.value?.length == 1) {
          _removeFile(0);
        }
        myFiles.clear();
        myFiles.add(filesReturned.first);
        selectedFilesType = RequestType.video;

        editedComponents.add(ThreadComponents.video);
      }
    }

    files.value = myFiles;
    _refreshActions(); // to refresh which thread action shows
    _scrollController.scrollToIndex(0,
        preferPosition: AutoScrollPosition.begin);
  }

  _removeFile(int index) {
    // files.value = null;
    final clonedFiles = [...files.value!];
    clonedFiles.removeAt(index);
    files.value = clonedFiles;
    if (files.value == null || files.value!.isEmpty) {
      selectedFilesType = null;
    }
    editedComponents.add(ThreadComponents.images);
    _refreshActions();
  }

  /// code editing
  void _toggleCodeEditor(bool newValue) {
    // logger.i('open code editor tapped');
    attachCode.value = newValue;
    if (!newValue) {
      codeContent = '';
    }
    _refreshActions();
  }

  /// Thread to edit setup here -----------------
  _setupThreadUIForEditing() async {
    // usernameToReply
    if (!widget.usernameToReply.isNullOrEmpty()) {
      messageController.text = "@${widget.usernameToReply} ";
    }

    if (widget.threadToEdit != null) {
      /// title
      if (!widget.threadToEdit!.title.isNullOrEmpty()) {
        titleController.text = widget.threadToEdit?.title ?? '';
        showTitleField.value = true;
      }

      /// message
      if (!widget.threadToEdit!.message.isNullOrEmpty()) {
        messageController.text = widget.threadToEdit?.message ?? '';
        // Link Preview Meta Data happens by default if message contains link
      }

      /// File (image) content
      if(widget.threadToEdit!.images != null && widget.threadToEdit!.images!.isNotEmpty) {
        selectedFilesType = RequestType.image;
        List<File> mFiles = [];
        // images
        networkToFilesLoading.value = true;
        for(String networkImage in widget.threadToEdit!.images!) {
          final file = await networkImageToFile(networkImage);
          if(file != null) {
            mFiles.add(file);
          }

        }
        networkToFilesLoading.value = false;

        // set it to files object
        files.value = mFiles;

      }else if (!widget.threadToEdit!.videoUrl.isNullOrEmpty()){
        threadToEditHasVideo.value = true;
      }

      /// CodeView content
      else if (!widget.threadToEdit!.code.isNullOrEmpty()) {
        codeContent = widget.threadToEdit!.code!;
        codeLanguage = widget.threadToEdit!.codeLanguage ?? defaultCodeLanguage;
        attachCode.value = true;
      }

      /// Poll Content
      // else if (widget.threadToEdit!.poll != null) {
      //   final previousPoll = create.Poll.fromJson(widget.threadToEdit!.poll!.toJson());
      //   pollVisibility.value = (previousPoll.isPublic ?? true) ? "Public" : "Anonymous";
      //   poll.value = previousPoll;
      //
      //   pollQuestionController.text = previousPoll.question ?? '';
      //   pollOptionsEditingControllers.clear();
      //   for(var i = 0; i < previousPoll.options!.length; i++){
      //     final option = previousPoll.options![i];
      //     final controller = TextEditingController()..text = option.option ?? '';
      //     pollOptionsEditingControllers.add(controller);
      //   }
      //
      //   final previousDateAsString = previousPoll.endDate as String?;
      //   if(previousDateAsString == null) {
      //     _setPollExpiryDate();
      //     return;
      //   }
      //   final existingEndDate = DateTime.parse(previousDateAsString);
      //   final now = DateTime.now();
      //   if(existingEndDate.isBefore(now)){
      //     // date expired
      //     _setPollExpiryDate();
      //     // pollExpiryDate.value = 'Expired';
      //     return;
      //   }
      //
      //   final dateFromNow = existingEndDate.difference(now);
      //   final existingHoursLeft = existingEndDate.subtract(Duration(days: dateFromNow.inDays));
      //   final hoursFromNow = existingHoursLeft.difference(now).inHours;
      //   final existingMinutesLeft = existingHoursLeft.subtract(Duration(days: dateFromNow.inDays, hours: hoursFromNow));
      //   // final minutesFromNow = existingMinutesLeft.subtract(now).;
      //
      //   if(dateFromNow.inDays > 0) {
      //     pollDurationDaysController.text = dateFromNow.inDays.toString();
      //     pollDurationHoursController.text = hoursFromNow.toString();
      //     pollDurationMinutesController.text = existingMinutesLeft.minute.toString();
      //   }
      //   else if(hoursFromNow > 0) {
      //     pollDurationHoursController.text = hoursFromNow.toString();
      //   }
      //   else if(existingMinutesLeft.minute > 0) {
      //     pollDurationMinutesController.text = existingEndDate.minute.toString();
      //   }
      //
      //   _setPollExpiryDate();
      //
      // }

      /// Gif Content
      else if (widget.threadToEdit?.gif != null) {
        final previousGif = widget.threadToEdit!.gif;

        final GifTypes gifTypes = GifTypes(
          size: previousGif!.big!.size,
          dims: previousGif.big!.dims,
          previewUrl: previousGif.big!.preview,
          url: previousGif.big!.url,
        );

        final GifTypes tinyGifTypes = GifTypes(
          size: previousGif.tiny!.size,
          dims: previousGif.tiny!.dims,
          previewUrl: previousGif.tiny!.preview,
          url: previousGif.tiny!.url,
        );

        final TenorGif tenorGif =
            TenorGif(gif: gifTypes, tinygif: tinyGifTypes);

        final tenorResult = TenorResult(
          media: tenorGif,
        );

        gif.value = tenorResult;
      }

      // Community
      if (widget.threadToEdit?.community != null) {
        selectedCommunity.value = widget.threadToEdit!.community!;
      }

      _refreshActions();
    }
  }

  /// Enable and disable thread actions
  _refreshActions() {
    // because its a set, if element already available it will overwrite
    final set = {...initialActions};
    bool touched = false;

    if (messageController.text.isNotEmpty) {
      touched = true;
    }

    if (files.value != null && files.value!.isNotEmpty) {
      set.removeAll(<String>{'code', 'gif', 'poll'});
      touched = true;
    }

    if (gif.value != null) {
      set.removeAll(<String>{'code', 'file', 'poll'});
      touched = true;
    }

    if (attachCode.value) {
      set.removeAll(<String>{'file', 'gif', 'poll'});
      touched = true;
    }

    if (poll.value != null) {
      set.removeAll(<String>{'file', 'gif', 'code'});
      touched = true;
    }

    if (touched) {
      set.addAll(<String>{'send'});
    }

    activatedActions.value = set;
  }

  void _scrollToIndex(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  _onASD9ButtonTapped() {
    _addTextToCursorPosition('@asd9 ');
    _refreshActions();
  }

  _addTextToCursorPosition(String text) {
    // Get cursor current position
    var cursorPos = messageController.selection.base.offset;

    // Right text of cursor position
    String suffixText = messageController.text.substring(cursorPos);

    // Add new text on cursor position
    String specialChars = text;
    int length = specialChars.length;

    // Get the left text of cursor
    String prefixText = messageController.text.substring(0, cursorPos);

    messageController.text = prefixText + specialChars + suffixText;

    // Cursor move to end of added text
    messageController.selection = TextSelection(
      baseOffset: cursorPos + length,
      extentOffset: cursorPos + length,
    );
  }

  /// Polls
  createPoll() {
    pollOptionsEditingControllers.clear();
    pollOptionsEditingControllers.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
    poll.value = const ThreadPollModel().copyWith(
        id: -1,
        options: <ThreadPollOptionModel>[],
        isPublic: true,
        totalVotes: 0);
    pollDurationDaysController.text = "5";
    pollDurationHoursController.text = "1";
    pollDurationMinutesController.text = "0";
    _setPollExpiryDate();
    pollVisibility.value = "Public";
    pollQuestionFocusNode.requestFocus();
    _refreshActions();
  }

  _removePoll() {
    poll.value = null;
    editedComponents.add(ThreadComponents.poll);
    _refreshActions();
  }

  _removePollOption({required int index}) {
    if (poll.value == null) return;
    if (pollOptionsEditingControllers.length <= 2) {
      context.showSnackBar('Poll options cannot be less than two',
          appearance: Appearance.error);
      return;
    }
    // pollOptionsEditingControllers[index].clear();
    setState(() {
      pollOptionsEditingControllers.removeAt(index);
    });
  }

  _addPollOption() {
    if (poll.value == null) return;
    setState(() {
      pollOptionsEditingControllers.add(TextEditingController());
    });
  }

  _onCommunityMentionsActionTapped(String mention) {
    // _addTextToCursorPosition("c/$mention");
    _replaceWordAtCursor(messageController, "c/$mention ");
    _refreshActions();
    suggestedMentionedCommunities.value = [];
  }

  void _replaceWordAtCursor(TextEditingController controller, String newWord) {
    String text = controller.text;
    int cursorPos = controller.selection.baseOffset;
    RegExp wordPattern = RegExp(r'\b(c/\w+)\b', caseSensitive: false);
    Iterable<Match> matches = wordPattern.allMatches(text);
    Match? match;
    for (Match m in matches) {
      if (m.start <= cursorPos && m.end >= cursorPos) {
        match = m;
        break;
      }
    }
    if (match != null) {
      String oldWord = match.group(1)!;
      String newText = text.replaceRange(match.start, match.end, newWord);
      controller.value = TextEditingValue(
        text: newText,
        selection:
            TextSelection.collapsed(offset: match.start + newWord.length),
      );
    }
  }

  _onUserInMentionSuggestionsTapped(UserModel user) {
    // get the word at the cursor's current position
    var cursorPos = messageController.selection.base.offset;
    String prefixText = messageController.text.substring(0, cursorPos);
    final prefixWords = prefixText.split(" ");
    final lastPrefixWord = prefixWords.last;
    final queryText = lastPrefixWord.substring(1);

    final text = messageController.text;
    if (queryText == '' || user.username.isNullOrEmpty()) return;

    final newText = text.replaceFirst(queryText, user.username ?? '');

    messageController.text = newText;
    // find the position of the username
    final cursorPosition =
        newText.indexOf(user.username!) + user.username!.length;
    messageController.selection =
        TextSelection.fromPosition(TextPosition(offset: cursorPosition));
    mentionedUsers.add(UserMentionModel(
        userId: user.id,
        username: user.username,
        displayName: user.displayName,
        currentUsername: user.username));
    suggestedMentionedUsers.value = [];
  }

  _setPollExpiryDate() {
    if (pollDurationDaysController.text.isEmpty) {
      pollDurationDaysController.text = "0";
    }
    if (pollDurationHoursController.text.isEmpty) {
      pollDurationHoursController.text = "0";
    }

    if (pollDurationMinutesController.text.isEmpty) {
      pollDurationMinutesController.text = "0";
    }

    if (int.parse(pollDurationHoursController.text) >= 23) {
      pollDurationHoursController.text = "23";
    }

    if (int.parse(pollDurationMinutesController.text) >= 59) {
      pollDurationHoursController.text = "59";
    }

    final days = pollDurationDaysController.text;
    final hours = pollDurationHoursController.text;
    final minutes = pollDurationMinutesController.text;

    String display = "";
    var daysToAdd = 0;
    if (int.parse(days) > 0) {
      display += "${days}d ";
      daysToAdd = int.parse(days);
    }

    var hoursToAdd = 0;
    if (int.parse(hours) > 0) {
      display += "${hours}h ";
      hoursToAdd = int.parse(hours);
    }

    var minutesToAdd = 0;
    if (int.parse(minutes) > 0) {
      display += "${minutes}m ";
      minutesToAdd = int.parse(minutes);
    }

    pollExpiryDate.value = display.isNotEmpty ? display : "Never";

    final now = DateTime.now();

    final newDateAhead = now.add(
        Duration(days: daysToAdd, hours: hoursToAdd, minutes: minutesToAdd));

    poll.value = poll.value!.copyWith(endDate: newDateAhead);
  }

  bool _preparePollForSubmission() {
    if (poll.value == null) return true; // user is not creating poll

    // if code reaches here, user is creating poll
    // final question = pollQuestionController.text;
    // if(question.isEmpty){
    //   context.showSnackBar('You forgot to set the poll question', appearance: Appearance.error);
    //   return false;
    // }

    // attach question
    final pollOptions = poll.value!.options!;

    // get poll options
    var countNonEmptyOptions = 0;
    poll.value?.options?.clear();
    for (var i = 0; i < pollOptionsEditingControllers.length; i++) {
      final controller = pollOptionsEditingControllers[i];
      if (controller.text.isNotEmpty) {
        countNonEmptyOptions++;

        // final optionId = i + 1;
        const optionId = -1;
        final option = controller.text;
        const pollId = -1;
        const totalVotes = 0;
        pollOptions.add(ThreadPollOptionModel(
            id: optionId,
            option: option,
            pollId: pollId,
            totalVotes: totalVotes));
        // poll.value!.options!.add(create.Option(id: optionId, option: option, totalVotes: votes));
      }
    }

    if (countNonEmptyOptions < 2) {
      context.showSnackBar('Poll options cannot be less than two',
          appearance: Appearance.error);
      return false;
    }

    final currentDate = DateTime.now();
    final days = int.parse(pollDurationDaysController.text);
    final hours = int.parse(pollDurationHoursController.text);
    final minutes = int.parse(pollDurationMinutesController.text);
    // final endDate = DateTime(now.year, months, days, hours, minutes);

    final endDate =
        currentDate.add(Duration(days: days, hours: hours, minutes: minutes));

    // visibility
    // final pollValue = poll.value;
    // poll.value = null;
    poll.value = poll.value?.copyWith(
        question: '',
        options: pollOptions,
        endDate: endDate,
        isPublic: pollVisibility.value == "Public"
    );

    return true;
  }

  Set<UserMentionModel> _prepareMentions() {
    // get mentions from users
    final text = messageController.text;
    final words = text.split(" ");
    // get words that start with @
    final wordsWhichStartsWithMention =
        words.where((element) => element.startsWith("@"));

    final mentions = <UserMentionModel>{};

    // all mentions
    final listOfPossibleMentionedUsers = mentionedUsers.toList();
    for (var element in wordsWhichStartsWithMention) {
      final foundIndex = listOfPossibleMentionedUsers.indexWhere((user) {
        String m = element.substring(1);
        m = m.replaceAll(",", "");
        m = m.replaceAll(".", "");
        return user.username == m;
      });
      if (foundIndex != -1) {
        final mention = listOfPossibleMentionedUsers[foundIndex];
        mentions.add(mention);
      }
    }

    messageController.text = messageController.text.replaceAll("@", "u/");

    return mentions;
  }

  /// Communities modal
  _changeCommunity(BuildContext ctx) {
    pushScreen(ctx,
        ThreadEditorCommunityListPage(onTap: (CommunityModel community) {
      selectedCommunity.value = community;
    }), fullscreenDialog: true);
  }

  _onGifSelected(TenorResult gifItem) {
    gif.value = gifItem;
    editedComponents.add(ThreadComponents.gif);
    _refreshActions();
    _scrollController.scrollToIndex(2, preferPosition: AutoScrollPosition.end);
  }

  _onRemoveGifItem() {
    gif.value = null;
    editedComponents.add(ThreadComponents.gif);
    _refreshActions();
  }

  /// SUBMIT - time to create thread
  void _handleThreadEditorSubmission() async {
    contentFocusNode.unfocus();

    /// submit images to server if any before you submit request
    ///
    if (widget.threadToReply == null && titleController.text.isNullOrEmpty()) {
      context.showSnackBar("Please add a title");
      return;
    }

    // check if there are any mentions and add to request object
    final mentions = _prepareMentions();

    // prepare polls object if user is creating polls
    final pollPrepared = _preparePollForSubmission();
    if (!pollPrepared) return;

    SharedGifModel? createGif;
    if (gif.value != null) {
      createGif = SharedGifModel(
          big: SharedGifBigModel(
              size: gif.value!.media!.gif!.size,
              dims: gif.value!.media!.gif!.dims,
              preview: gif.value!.media!.gif!.previewUrl,
              url: gif.value!.media!.gif!.url),
          tiny: SharedGifBigModel(
              size: gif.value!.media!.tinygif!.size,
              dims: gif.value!.media!.tinygif!.dims,
              preview: gif.value!.media!.tinygif!.previewUrl,
              url: gif.value!.media!.tinygif!.url));
    }

    final createThreadRequest = ThreadEditorRequest(
        id: widget.threadToEdit?.id ?? -1,
        files: files.value ?? [],
        selectedFilesType: selectedFilesType,
        threadToEdit: widget.threadToEdit,
        threadToReply: widget.threadToReply,
        scheduled: isScheduled.value,
        editedComponents: editedComponents.toList(),
        message: messageController.text,
        isAnonymous: anonymousPostEnabled.value == false ? null : true,
        // scheduledAt:  !isScheduled.value ? null : (scheduledTime != null && scheduledDate != null ?  DateTime.now(). : null),
        scheduledAt: (isScheduled.value ?? false) ? DateTime.parse('$scheduledDate $scheduledTime') : null,
        code: codeContent.isNotEmpty ? codeContent : null,
        parentId: widget.threadToReply?.id,
        codeLanguage: codeLanguage,
        communityId: selectedCommunity.value?.id,
        community: selectedCommunity.value,
        mentions: mentions.toList(),
        poll: poll.value,
        gif: createGif,
        images: editedComponents.contains(ThreadComponents.images)
            ? []
            : (widget.threadToEdit?.images ?? []),
        videoUrl: editedComponents.contains(ThreadComponents.video)
            ? null
            : widget.threadToEdit?.videoUrl,
        title: showTitleField.value ? titleController.text : '',
        // showTitleField is checked on purpose
        linkPreviewUrl: linkPreview.value?.url ?? ""
    );

    /// Request thread submission
    _threadsCubit.processThreadSubmission(request: createThreadRequest);
    pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
