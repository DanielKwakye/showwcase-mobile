import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/file_manager/data/models/pre_signed_url_request.dart';
import 'package:showwcase_v3/features/file_manager/data/models/pre_signed_url_response.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_model.dart';
import 'package:tenor/tenor.dart';
import 'package:tus_client/tus_client.dart';
// import 'package:tus_client/tus_client.dart';

class FileManagerRepository {

  final NetworkProvider _networkProvider;

  FileManagerRepository(this._networkProvider);



  /// UPLOAD IMAGES(S) FEATURE ----
  Future<Either<ApiError, PreSignedUrlResponse>> uploadImage({required String bucketName, required File file}) async{

    try{
      /// get file name from file
      String fileName = (file.path.split('/').last);

      /// get file content type

      final preSignedRequest = PreSignedUrlRequest(
        contentType: lookupMimeType(file.path),
        bucketName: bucketName,
        key: Uri.encodeComponent('${DateTime.now().millisecondsSinceEpoch}-$fileName')
      );

      final req = preSignedRequest.toJson();

      final presignedUrlPath = ApiConfig.preSignedUrl;

      ///get presigned url from aws
      var response = await _networkProvider.call(path: presignedUrlPath, method: RequestMethod.post,body: req);

      if(response!.statusCode == 200){
        /// request is successful and you now have the presigned url and you are building a request body with the data from aws
        final preSignedUrlResponse = PreSignedUrlResponse.fromJson(response.data);

        if(preSignedUrlResponse.preSignedUrlFields == null){
          return Left(ApiError(errorDescription: "Upload failed"));
        }

        Map<String,dynamic> uploadData = preSignedUrlResponse.preSignedUrlFields!.toJson();

        uploadData.addAll({"file": await MultipartFile.fromFile(file.path)});

        FormData formData = FormData.fromMap(uploadData);

        /// make a request to the presgined url and with the image you intend to upload . this request doesn't return any data when successfull
        var uploadResponse = await _networkProvider.upload(path: preSignedUrlResponse.url ?? '',body: formData);
        if(uploadResponse!.statusCode == 204){
          return Right(preSignedUrlResponse);

        }else{
          return Left(ApiError(errorDescription: 'Failed to Upload'));
        }

      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  /// UPLOAD VIDEO  ----
  Future<void> uploadVideo({required XFile file, String? userId,
      required Function({required String url, required String mediaId}) onComplete,
       required Function({required double progress}) onProgress, required Function({required String message}) onError})
  async {

    try{

      // Create a client
      final fileType = getFileType(path: file.path);

      if(fileType == null) {
        onError.call(message: "Unable to determine file type");
        return;
      }

      final path = ApiConfig.videoPreSignedUrl;
      final id = userId ?? AppStorage.currentUserSession?.id?.toString() ?? '';

      // final response = await cloudflare.streamAPI.createTusDirectStreamUpload(
      //   size: await file.length(),
      //   maxDurationSeconds: videoPlayerController.value.duration.inSeconds,
      //   name: 'tus-video-direct-upload',
      // );
      // final dataUploadDraft = response.body;
      // debugPrint(dataUploadDraft?.id);
      // debugPrint(dataUploadDraft?.uploadURL);
      //
      // if(dataUploadDraft == null) {
      //   onError.call(message: "Unable to upload video");
      //   return;
      // }
      //
      // final tusAPI = await cloudflare.streamAPI.tusDirectStreamUpload(
      //     file: File(file.path),
      //     path: path,
      //     chunkSize: 52428800,
      //     dataUploadDraft: dataUploadDraft
      // );
      // tusAPI.startUpload(
      //     onProgress: (count, total) {
      //       final progress = count/total;
      //       debugPrint("videoUpload: Progress: $progress");
      //       onProgress.call(progress: progress);
      //     },
      //     onComplete: (cloudflareStreamVideo) {
      //           debugPrint('tus stream video completed');
      //           debugPrint('cloudflareStreamVideo?.id -> ${cloudflareStreamVideo?.id}');
      //           debugPrint('cloudflareStreamVideo?.status -> ${cloudflareStreamVideo?.status}');
      //           debugPrint('cloudflareStreamVideo?.meta -> ${cloudflareStreamVideo?.meta}');
      //           debugPrint('cloudflareStreamVideo?.isReady -> ${cloudflareStreamVideo?.isReady}');
      //
      //           final streamVideo = cloudflareStreamVideo;
      //
      //           //   final uploadUrl = client.uploadUrl.toString();
      //           // // Prints the uploaded file URL
      //           // debugPrint("videoUpload: url: $uploadUrl");
      //           //
      //           // const uploadBaseUrl = 'https://upload.videodelivery.net/tus/';
      //           // const lengthOfUploadBaseUrl = uploadBaseUrl.length;
      //           // final endpoint = uploadUrl.substring(lengthOfUploadBaseUrl);
      //           // final list = endpoint.split('?');
      //           // if(list.length != 2) {
      //           //   onError.call(message: 'Media id not found');
      //           //   return;
      //           // }
      //           //
      //           // final mediaId = list.first;
      //           // debugPrint("videoUpload: mediaId: $mediaId");
      //
      //           // onComplete.call(url: uploadUrl, mediaId: mediaId);
      //     },
      //     onTimeout: () {
      //       debugPrint('tus request timeout');
      //     }
      // );
      // await Future.delayed(const Duration(seconds: 2), () {
      //   debugPrint('Upload paused');
      //   tusAPI.pauseUpload();
      // });
      // await Future.delayed(const Duration(seconds: 4), () {
      //   debugPrint('Upload resumed');
      //   tusAPI.resumeUpload();
      // });

      final client = TusClient(
        Uri.parse(path),
        file,
        maxChunkSize: 10 * 1024 * 1024,
        metadata: {
          "filename": file.name,
          "filetype": fileType['extension'] as String,
          "userId": id,
        },
        store: TusMemoryStore(),
      );

      // Starts the upload
      final res = await client.upload(

        onComplete: () {
          debugPrint("Complete!");

          final uploadUrl = client.uploadUrl.toString();
          // Prints the uploaded file URL
          debugPrint("videoUpload: url: $uploadUrl");

          const uploadBaseUrl = 'https://upload.videodelivery.net/tus/';
          const lengthOfUploadBaseUrl = uploadBaseUrl.length;
          final endpoint = uploadUrl.substring(lengthOfUploadBaseUrl);
          final list = endpoint.split('?');
          if(list.length != 2) {
            onError.call(message: 'Media id not found');
            return;
          }

          final mediaId = list.first;
          debugPrint("videoUpload: mediaId: $mediaId");

          onComplete.call(url: uploadUrl, mediaId: mediaId);
          // https://upload.videodelivery.net/tus/c2844d525ad9768a6067e528dece9f36?tusv2=true

        },
        onProgress: (progress) {
          debugPrint("videoUpload: Progress: $progress");
          onProgress.call(progress: progress);
        },

      );

      debugPrint("videoUpload: res: $res");


    }catch(e) {
      debugPrint("videoUpload: error: $e");
      onError.call(message: e.toString());
    }
  }

  Future<Either<ApiError, VideoModel>> fetchVideoStatusData({required String mediaId}) async {
    try{
      final path = ApiConfig.fetchVideoDetails(mediaId: mediaId);
      var response = await _networkProvider.call(
          path: path,
          method: RequestMethod.get);

      if (response!.statusCode == 200) {
        final videoResponse = VideoModel.fromJson(response.data);
        return Right(videoResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }

    } on DioException catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  /// GIFS FEATURE ----
  Tenor tenor = Tenor(apiKey: 'TAZHXLBYKZQE');

  Future<Either<ApiError, List<TenorResult>>> fetchTrendingGifs({required int limit})async {
    try{
      // fetch trending Gif
      TenorResponse? res = await tenor.requestTrendingGIF(limit: limit, contentFilter: ContentFilter.low);
      return Right(res!.results);

    }catch(e){
      debugPrint(e.toString());
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, List<TenorResult>>> searchGif({required String keyword, required int limit}) async{
    try{
      // fetch trending Gif
      TenorResponse? res = await tenor.searchGIF(keyword,limit: limit, contentFilter: ContentFilter.low);
      return Right(res!.results);

    }catch(e){
      debugPrint(e.toString());
      return Left(ApiError(errorDescription: e.toString()));
    }

  }



}