import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/models/pre_signed_url_response.dart';

part 'file_item.g.dart';

/// There can be multiple files

@CopyWith()
class FileItem extends Equatable {
  final PreSignedUrlResponse? preSignedUrl;
  final int? fileTag; // file tag is used to identify the file
  final File? file; 
  final String? groupId; // feature id used to identify which group of files this result belongs to
  final String? errorMessage; // error message is added if file encouters an error
  final FileItemStatus? status;
  final String? videoMediaId;
  final double? videoProgressValue;
  final dynamic data; // for any extra data

  const FileItem({
    this.preSignedUrl,
    this.fileTag,
    this.file,
    this.groupId,
    this.status,
    this.errorMessage,
    this.videoMediaId,
    this.videoProgressValue,
    this.data
  });

  @override
  List<Object?> get props => [status, errorMessage, preSignedUrl, fileTag, groupId, videoMediaId, videoProgressValue, file];

}