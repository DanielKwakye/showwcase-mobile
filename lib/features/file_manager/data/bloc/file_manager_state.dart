import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:tenor/tenor.dart';

part 'file_manager_state.g.dart';

@CopyWith()
class FileManagerState extends Equatable {

  final String message;
  final FileManagerStatus status;
  final List<FileItem> fileItems;
  final List<TenorResult> popularGifs;


  const FileManagerState({
    this.message = '',
    this.status = FileManagerStatus.initial,
    this.fileItems = const [],
    this.popularGifs = const [],
  });

  @override
  List<Object?> get props => [status, fileItems];

}