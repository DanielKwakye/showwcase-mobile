import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_category_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

part 'shows_state.g.dart';

@CopyWith()
class ShowsState extends Equatable {
  final String message;
  final ShowsStatus status;
  final dynamic data; // you can keep all temporal data here
  final ShowCategoryModel selectedShowCategory;
  final List<ShowCategoryModel> showCategories;
  final List<ShowModel>  shows;

  const ShowsState({
    this.status = ShowsStatus.initial,
    this.message = '',
    this.showCategories = const  [ ShowCategoryModel(name: "All Shows") ],
    this.shows = const [],
    this.selectedShowCategory = const ShowCategoryModel(name: "All Shows"),
    this.data
  });

  @override
  List<Object?> get props => [status, selectedShowCategory];

}