import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/users_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_broadcast_repository.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_repository.dart';

class UsersCubit  extends Cubit<UsersState> {

  final UserRepository userRepository;
  final UserBroadcastRepository userBroadcastRepository;
  UsersCubit({required this.userRepository, required this.userBroadcastRepository}): super(const UsersState());

  /// sub class can use this method to handle infinite user scroll list --------------
  Future<Either<String, List<UserModel>>> fetchUsers({required String path, required int pageKey, UserModel? user}) async {

    try {

      emit(state.copyWith(status: UserStatus.fetchUsersInProgress));
      user = user ??= AppStorage.currentUserSession;

      if(user == null){
        return const Left("User cannot be null");
      }


      final users = [...state.users];

      final either = await userRepository.fetchUserList(path: path);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: UserStatus.fetchUsersFailed, message: l.errorDescription));
        return Left(l.errorDescription);
      }

      // successful
      List<UserModel> r = either.asRight();
      if(pageKey == 0){
        // if its first page request remove all existing threads
        users.clear();
      }

      users.addAll(r);

      emit(state.copyWith(status: UserStatus.fetchUsersSuccessful, users: users));

      return Right(r);

    } catch (e) {

      emit(state.copyWith(status: UserStatus.fetchUsersFailed, message: e.toString()));
      return Left(e.toString());
    }

  }


}