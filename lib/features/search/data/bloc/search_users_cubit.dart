import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/users/data/bloc/users_cubit.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class SearchUsersCubit extends UsersCubit {

  SearchUsersCubit({required super.userRepository, required super.userBroadcastRepository});

  Future<Either<String, List<UserModel>>> fetchUsersSearch(
      {required int pageKey, required String searchWord}) {

    // we request for the default page size on the first call and subsequently we skip by the length of shows available
    final skip = pageKey  > 0 ? pageKey * defaultPageSize : pageKey; //
    final path =  ApiConfig.search(limit: defaultPageSize, skip: skip, type: 'users', text: searchWord);
    return super.fetchUsers(pageKey: pageKey, path: path);

  }
}