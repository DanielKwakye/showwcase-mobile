import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:showwcase_v3/features/file_manager/data/models/pre_signed_url_response.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_model.dart';
import 'package:showwcase_v3/features/file_manager/data/repositories/file_manager_repository.dart';
import 'package:tenor/tenor.dart';

class FileManagerCubit extends Cubit<FileManagerState> {

  final FileManagerRepository fileManagerRepository;
  FileManagerCubit({required this.fileManagerRepository}): super(const FileManagerState());

  FileItem setFileItem({

    String? groupId,
    int? fileTag,
    FileItemStatus? status,
    File? file,
    PreSignedUrlResponse? preSignedUrl,
    String? errorMessage,
    String? videoMediaId,
    double? videoProgressValue,
    dynamic data,

  }) {

    emit(state.copyWith(status: FileManagerStatus.setFileItemInProgress));

    final fileItems = [...state.fileItems];
    final fileItemIndex = fileItems.indexWhere((element) => element.fileTag == fileTag && element.groupId == groupId);
    if(fileItemIndex > -1){
      // file already exists. update
      final fileItem = fileItems[fileItemIndex];
      final updatedFileItem = fileItem.copyWith(
          groupId: groupId ?? fileItem.groupId,
          fileTag: fileTag ?? fileItem.fileTag,
          status: status ?? fileItem.status,
          file: file ?? fileItem.file,
          preSignedUrl: preSignedUrl ?? fileItem.preSignedUrl,
          errorMessage: errorMessage ?? fileItem.groupId,
          videoMediaId: videoMediaId ?? fileItem.videoMediaId,
          videoProgressValue: videoProgressValue ?? fileItem.videoProgressValue,
          data: data
      );
      fileItems[fileItemIndex] = updatedFileItem;
      emit(state.copyWith(status: FileManagerStatus.setFileItemCompleted, fileItems: fileItems));
      return updatedFileItem; // return for who ever needs it

    }else {
      // file not available, add.
      final fileItem = FileItem(
          groupId: groupId,
          fileTag: fileTag,
          status: status,
          file: file,
          preSignedUrl: preSignedUrl,
          errorMessage: errorMessage,
          videoMediaId: videoMediaId,
          data: data
      );
      fileItems.add(fileItem);
      emit(state.copyWith(status: FileManagerStatus.setFileItemCompleted, fileItems: fileItems));
      return fileItem; // return for who ever needs it
    }

  }

  void clearFilesGroup({required String groupId}){
    emit(state.copyWith(status: FileManagerStatus.clearFilesGroupInProgress));
    final items = [...state.fileItems];
    items.removeWhere((element) => element.groupId == groupId);
    emit(state.copyWith(status: FileManagerStatus.clearFilesGroupCompleted,
      fileItems: items
    ));
  }

  void clearFileItem({required String groupId, required int fileTag}){
    emit(state.copyWith(status: FileManagerStatus.clearFileItemInProgress));
    final items = [...state.fileItems];
    items.removeWhere((element) => element.groupId == groupId && element.fileTag == fileTag);
    emit(state.copyWith(status: FileManagerStatus.clearFileItemCompleted,
        fileItems: items
    ));
  }

  /// Image upload section ----
  /// image upload return left means there was an error uploading file. So it returns only the fileTag
  /// Right mean success. FiletItems contains PreSignedUrlResponse, fileTag and the url generated from upload
  Future<Either<int?, FileItem>> uploadImage({required File file, required String bucketName, required int fileTag, required String groupId, dynamic data}) async {

    // add file to file items list -------
    final fileItem = setFileItem(
      groupId: groupId,
      fileTag: fileTag,
      status: FileItemStatus.inProgress,
      file: file,

    );

    try {

      /// use bucketName like this bucketTypes[BucketName.otherData];
      emit(state.copyWith(status: FileManagerStatus.uploadImageInProgress,));

      final either = await fileManagerRepository.uploadImage(bucketName: bucketName, file: file);

      if(either.isLeft()){
        final l = either.asLeft();
        setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.failed, errorMessage: l.errorDescription);
        emit(state.copyWith(status: FileManagerStatus.uploadImageFailed, message: l.errorDescription,));
        return Left(fileTag);
      }

      // successful upload
      final r = either.asRight();
      final item = setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.successful, preSignedUrl: r);
      emit(state.copyWith(status: FileManagerStatus.uploadImageSuccessful));
      return Right(item);


    } catch (e) {
      setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.failed, errorMessage: e.toString());
      emit(state.copyWith(status: FileManagerStatus.uploadImageFailed, message: e.toString()));
      return Left(fileTag);

    }
  }

  /// Video upload section ----
  void uploadVideo({required XFile file, required int fileTag, required String groupId}) async {

    // add file to file items list -------
    final fileItem = setFileItem(
      groupId: groupId,
      fileTag: fileTag,
      status: FileItemStatus.inProgress,
      file: File(file.path),
    );

    try {
      // /// use bucketName like this bucketTypes[BucketName.otherData];

      await fileManagerRepository.uploadVideo(file: file,

          onComplete: ({required String url, required String mediaId}) {

            setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.successful, videoMediaId: mediaId);
            emit(state.copyWith(status: FileManagerStatus.uploadVideoSuccessful));
            // emit(UploadFileSuccessful(mediaId: mediaId, fileTag: fileTag));

          },
          onProgress: ({required double progress}) {

            setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.inProgress, videoProgressValue: progress);
            emit(state.copyWith(status: FileManagerStatus.uploadVideoInProgress,));

          },
          onError: ({required String message}) {

            setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.failed, errorMessage: message);
            emit(state.copyWith(status: FileManagerStatus.uploadVideoFailed, message: message,));

          });
    } catch (e) {
      setFileItem(groupId: fileItem.groupId, fileTag: fileItem.fileTag, status: FileItemStatus.failed, errorMessage: e.toString());
      emit(state.copyWith(status: FileManagerStatus.uploadVideoFailed, message: e.toString(),));
    }
  }

  // this method only fetches the video url from mediaId and returns VideoModel(which contains video url) to the caller instantly,
  // returned data is NOT kept in state
  Future<Either<String, VideoModel>> fetchVideoFromMediaId({required String mediaId}) async {

    try{

      debugPrint("mediaId: $mediaId");

      final either = await fileManagerRepository.fetchVideoStatusData(mediaId: mediaId);

      if(either.isLeft()){
        final l = either.asLeft();
        return Left(l.errorDescription);
      }

      // success
      final r = either.asRight();
      return Right(r);


    }catch(e){
      return Left(e.toString());
    }
  }


  /// Gif Feature -----
  Future<Either<String, List<TenorResult>>> fetchTrendingGifs({required int limit}) async {

    try{

      emit(state.copyWith(status: FileManagerStatus.fetchTrendingGifsInProgress));
      final either = await fileManagerRepository.fetchTrendingGifs(limit: limit);


      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: FileManagerStatus.fetchTrendingGifsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }


      // successful
      final r = either.asRight();
      emit(state.copyWith(status: FileManagerStatus.fetchTrendingGifsSuccessful, popularGifs: r ));
      return Right(r);

    }catch(e){
      emit(state.copyWith(status: FileManagerStatus.fetchTrendingGifsFailed));
      return Left(e.toString());
    }
  }


  Future<Either<String, List<TenorResult>>> searchGifs({required int limit,required String keyword})async{
    try{
      emit(state.copyWith(status: FileManagerStatus.searchGifsInProgress));
      final either = await fileManagerRepository.searchGif(limit: limit, keyword: keyword);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: FileManagerStatus.searchGifsFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      final r = either.asRight();
      emit(state.copyWith(status: FileManagerStatus.searchGifsSuccessful ));
      return Right(r);

    }catch(e){
      emit(state.copyWith(status: FileManagerStatus.searchGifsFailed));
      return Left(e.toString());
    }
  }


}