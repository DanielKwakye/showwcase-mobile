import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_editor_request.dart';

import '../../../file_manager/data/bloc/file_manager_enums.dart';


//! This widget prepares thread request and submits to the server server (create / edit / reply)
class ThreadSubmissionWidget extends StatefulWidget {

  final Widget child;
  const ThreadSubmissionWidget({Key? key, required this.child}) : super(key: key);

  @override
  ThreadSubmissionWidgetController createState() => ThreadSubmissionWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadSubmissionWidgetView extends WidgetView<ThreadSubmissionWidget, ThreadSubmissionWidgetController> {

  const _ThreadSubmissionWidgetView(ThreadSubmissionWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }




}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadSubmissionWidgetController extends State<ThreadSubmissionWidget> {

  late ThreadCubit threadCubit;
  late HomeCubit homeCubit;
  late FileManagerCubit fileManagerCubit;
  late StreamSubscription<ThreadState> threadStateStreamSubscription;
  late StreamSubscription<FileManagerState>? fileManagerStateStreamSubscription;
  late ThreadEditorRequest? threadRequest;
  Timer? _videoStatusCheckTimer;

  @override
  Widget build(BuildContext context) => _ThreadSubmissionWidgetView(this);

  @override
  void initState() {

    threadCubit = context.read<ThreadCubit>();
    homeCubit = context.read<HomeCubit>();
    fileManagerCubit = context.read<FileManagerCubit>();
    threadStateStreamSubscription = threadCubit.stream.listen((event) => threadCubitListener(event));
    fileManagerStateStreamSubscription = fileManagerCubit.stream.listen((event) => fileManagerCubitListener(event));
    super.initState();

  }


  @override
  void dispose() {
    fileManagerStateStreamSubscription?.cancel();
    threadStateStreamSubscription.cancel();
    super.dispose();
  }

  void threadCubitListener(ThreadState event) async {

    if(event.status == ThreadStatus.processThreadSubmissionRequested) {

      threadRequest = event.data as ThreadEditorRequest;
      fileManagerCubit.clearFilesGroup(groupId: "thread_submission_images");
      fileManagerCubit.clearFilesGroup(groupId: "thread_submission_video");
      //parameters: { attachImage: File , attachedVideo: bool }


      // first check if the thread as videos or images and process them.
      if(threadRequest!.editedComponents.contains(ThreadComponents.video) || threadRequest!.editedComponents.contains(ThreadComponents.images)){

        // if image was removed -----
        if(threadRequest!.editedComponents.contains(ThreadComponents.images)){
          if(threadRequest!.selectedFilesType == null){
            final updatedRequest = threadRequest!.copyWith(
              images: null
            );
            homeCubit.enablePageLoad();
            await _handleThreadSubmission(updatedRequest);
            homeCubit.dismissPageLoad();
            return;
          }
        }

        // if video was removed -----
        if(threadRequest!.editedComponents.contains(ThreadComponents.video)){
          if(threadRequest!.selectedFilesType == null){
            final updatedRequest = threadRequest!.copyWith(
                videoUrl: null
            );
            homeCubit.enablePageLoad();
            await _handleThreadSubmission(updatedRequest);
            homeCubit.dismissPageLoad();
            return;
          }
        }


        /// Uploading images
        if(threadRequest!.selectedFilesType == RequestType.image) {

          homeCubit.enablePageLoad(parameters: {"attachImage": threadRequest!.files.first});
          // upload all images simultaneously and NOT sequentially --------------
          for(int i = 0; i < threadRequest!.files.length; i++){
            final file = threadRequest!.files[i];
            fileManagerCubit.uploadImage(file: file, bucketName: projectBucket, fileTag: i, groupId: "thread_submission_images");
          }

        }
        /// Uploading video
        else if (threadRequest!.selectedFilesType == RequestType.video) {
          // homeCubit.enablePageLoad(parameters: {"attachVideo": true, "progress": 0.0});
          homeCubit.enablePageLoad(parameters: {"attachVideo": true});
          final file = threadRequest!.files.first;
          final xFile = XFile(file.path);
          fileManagerCubit.uploadVideo(file: xFile, fileTag: 0, groupId: "thread_submission_video");
        }

      }else {
        homeCubit.enablePageLoad();
        await _handleThreadSubmission(threadRequest!);
        homeCubit.dismissPageLoad();
      }


    }
  }

  void fileManagerCubitListener(FileManagerState event) async {

      if(event.status == FileManagerStatus.uploadImageSuccessful){

        if(threadRequest != null){
          // check if all files have been successfully uploaded
          final completed = event.fileItems.where((element) => element.groupId == "thread_submission_images" && element.status != FileItemStatus.successful).isEmpty;

          if(completed) {
            final fileItems = event.fileItems.where((element) => element.groupId == "thread_submission_images" && element.status == FileItemStatus.successful);
            final completedImages = fileItems.where((element) => element.preSignedUrl?.preSignedUrlFields?.key != null).map((e) =>  "${ApiConfig.projectUrl}/${e.preSignedUrl!.preSignedUrlFields!.key!}" ).toList();
            final updatedRequest = threadRequest?.copyWith(
                images:  completedImages
            );

            // show only progressBar without attachment
            homeCubit.enablePageLoad();
            await _handleThreadSubmission(updatedRequest!);
            threadRequest == null;
            homeCubit.dismissPageLoad();
          }
        }


      }

      else if(event.status == FileManagerStatus.uploadVideoInProgress){
        final fileItem = event.fileItems.where((element) => element.groupId == "thread_submission_video" && element.status == FileItemStatus.inProgress).firstOrNull;
        if(fileItem?.videoProgressValue != null){
          // homeCubit.enablePageLoad(parameters: {"attachVideo": true, "progress": fileItem?.videoProgressValue ?? 0});
          homeCubit.enablePageLoad(parameters: {"attachVideo": true,});
        }

      }

      else if(event.status == FileManagerStatus.uploadVideoSuccessful){

        final completed = event.fileItems.where((element) => element.groupId == "thread_submission_video" && element.status != FileItemStatus.successful).isEmpty;
        if(completed){
          final fileItem = event.fileItems.where((element) => element.groupId == "thread_submission_video" && element.status == FileItemStatus.successful).first;
          final mediaId = fileItem.videoMediaId;
          // before creating thread check the status of of the video url to see if the processing is done
          if(mediaId != null) {

            // initialize timer only if its equal to null
            _videoStatusCheckTimer ??= Timer.periodic(const Duration(milliseconds: 500), (timer) async {


              debugPrint("customLog: timerTrack: timer called");

              // after every 500  millisecond try checking the video status again
              final either = await fileManagerCubit.fetchVideoFromMediaId(mediaId: mediaId);

              if(_videoStatusCheckTimer == null){
                return;
              }

              if(either.isLeft()){
                final error  = either.asLeft();
                debugPrint("customLog: video upload error: $error");
                if(mounted){
                  context.showSnackBar('Sorry! Unable to post video', appearance: Appearance.primary);
                }

                timer.cancel();
                _videoStatusCheckTimer?.cancel();
                _videoStatusCheckTimer = null;
                threadRequest = null;
                homeCubit.dismissPageLoad();
                return;
              }

              final status = either.asRight();
              // video status returned
              if(status.status?.state == "ready" && status.status?.pctComplete == "100.000000") {

                debugPrint("customLog: timerTrack: status -> ready");

                timer.cancel();
                _videoStatusCheckTimer?.cancel();
                _videoStatusCheckTimer = null;
                final updatedRequest = threadRequest?.copyWith(
                    videoUrl:  mediaId
                );

                // show only progressBar without attachment
                homeCubit.enablePageLoad();
                await _handleThreadSubmission(updatedRequest!);
                threadRequest = null;
                homeCubit.dismissPageLoad();
              }

            });


          }

        }


      }

      else if(event.status ==  FileManagerStatus.uploadImageFailed){
        if(threadRequest != null){
          //once one of the files fail to upload, thread can't be submitted
          final itemFailed = event.fileItems.where((element) => element.groupId == "thread_submission_images" && element.status == FileItemStatus.failed).length == 1;
          if(itemFailed) {
            context.showSnackBar("Sorry!. Image(s) upload failed");
          }
          threadRequest = null;
          homeCubit.dismissPageLoad();
        }

      }

      else if(event.status ==  FileManagerStatus.uploadVideoFailed){

        if(threadRequest != null){
          //once one of the files fail to upload, thread can't be submitted
          final itemFailed = event.fileItems.where((element) => element.groupId == "thread_submission_video" && element.status == FileItemStatus.failed).length == 1;
          if(itemFailed) {
            context.showSnackBar("Sorry!. Video upload failed");
          }
          threadRequest = null;
          homeCubit.dismissPageLoad();
        }


      }

  }


  Future<void> _handleThreadSubmission(ThreadEditorRequest request) async {

    if(request.threadToEdit != null) {

      /// Edit thread
      final either = await threadCubit.editThread(createThreadRequest: request);
      if(mounted) {
        if(either.isLeft()){
          context.showSnackBar(either.asLeft());
          return;
        }
        context.showSnackBar("Thread edited", onTap: () {
          // tapping on the snackbar should take you to the thread
          context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: either.asRight());
        });
      }


    }else {

      /// Create / reply thread
      final either =  await threadCubit.createOrReplyThread(createThreadRequest:  request);
      if(mounted)  {
        if(either.isLeft()){
          context.showSnackBar(either.asLeft());
          return;
        }
        final createdThread = either.asRight();
        context.showSnackBar(createdThread.parentId != null ? "Reply sent" : "Thread created", onTap: () {
          // tapping on the snackbar should take you to the thread
          context.push(context.generateRoutePath(subLocation: threadPreviewPage), extra: createdThread);
        });
      }

    }

  }


  // _processAttachedFiles(CreateThreadRequest? request) async {
  //
  //   uploadedFiles.clear();
  //
  //   /// Uploading images
  //   if(request != null && request.selectedFilesType == RequestType.image) {
  //
  //     /// Prevent Images re-upload if user didn't edit anything on the image
  //     if(request.threadToEdit != null && !request.editedComponents.contains(ThreadComponents.images)) {
  //       _handleThreadSubmission(request);
  //       return;
  //     }
  //
  //     for (int i = 0; i < request.files.length; i++) {
  //       /// set all uploaded files to null
  //       uploadedFiles[i] = null;
  //     }
  //
  //     for(int i = 0; i < request.files.length; i++){
  //       final file = request.files[i];
  //       // _sharedCubit.uploadFile(file: file, bucketName: bucketTypes[BucketName.otherData]!, fileTag: i);
  //     }
  //
  //   }
  //
  //   /// Uploading Video
  //   else if (request != null &&  request.selectedFilesType == RequestType.video) {
  //
  //     /// Prevent Video re-upload if user didn't edit anything on the image
  //     if(request.threadToEdit != null && !request.editedComponents.contains(ThreadComponents.video)) {
  //       _handleThreadSubmission(request);
  //       return;
  //     }
  //
  //     const index = 0;
  //     /// set all uploaded files to null
  //     uploadedFiles[index] = null;
  //
  //     final file = request.files[index];
  //     // File to be uploaded
  //     final xFile = XFile(file.path);
  //
  //     // _sharedCubit.uploadVideo(file: xFile, fileTag: 0);
  //
  //   }
  //
  //   else {
  //     context.showSnackBar("Invalid file selected", appearance: Appearance.primary);
  //   }
  //
  // }

  // _submitThreadIfAllFilesAreUploaded(CreateThreadRequest? request){
  //
  //   final atLeastOneEntryWithNullValue = uploadedFiles.values.firstWhere((element) => element == null, orElse: () => 'completed');
  //
  //   if(atLeastOneEntryWithNullValue == 'completed'){
  //     if(request!.selectedFilesType == RequestType.image) {
  //       request = request.copyWith(
  //           images: (request.selectedFilesType == RequestType.image) ? uploadedFiles.values.map((e) => e!).toList() : null
  //       );
  //       _handleThreadSubmission(request);
  //     }
  //     if(request.selectedFilesType == RequestType.video) {
  //       final mediaId = (request.selectedFilesType == RequestType.video) ? uploadedFiles.values.first : null;
  //       request = request.copyWith(
  //           videoUrl: (request.selectedFilesType == RequestType.video) ? uploadedFiles.values.first : null
  //       );
  //
  //       // before creating thread check the status of of the video url to see if the processing is done
  //       if(mediaId != null) {
  //         // _videoCubit.fetchVideoPreviewData(mediaId: mediaId);
  //       }
  //
  //     }
  //
  //   }
  //
  // }

}