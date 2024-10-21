import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_enums.dart';
import 'package:showwcase_v3/features/search/data/models/top_search_model.dart';

part 'search_state.g.dart';

@CopyWith()
class SearchState extends Equatable {

  final SearchStatus status;
  final String message;
  final TopSearchModel? topSearch;

  const SearchState({
    this.status = SearchStatus.initial,
    this.message = '',
    this.topSearch,
  });

  @override
  List<Object?> get props => [status];

}