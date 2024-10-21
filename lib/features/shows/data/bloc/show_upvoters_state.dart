import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

part 'show_upvoters_state.g.dart';

@CopyWith()
class ShowUpVotersState extends Equatable {

  final ShowsStatus status;
  final String message;
  final List<UserModel> voters;
  const ShowUpVotersState({
    this.status = ShowsStatus.initial,
    this.message = '',
    this.voters = const []
  });

  @override
  List<Object?> get props => [status];


}