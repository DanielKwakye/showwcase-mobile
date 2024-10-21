import 'package:dartz/dartz.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/features/refferals/data/models/invites_model.dart';


class InvitesRepository  {

  final NetworkProvider networkProvider ;

  InvitesRepository({required this.networkProvider});

  Future<Either<ApiError, InviteResponse>> sendInvites({required List<String> emails}) async{
    try {
      var response = await networkProvider.call(
          path: ApiConfig.referral,
          method: RequestMethod.post,body: {'emails': emails});
      if (response!.statusCode == 200) {
        final invitesResponse = InviteResponse.fromJson(response.data);
        return Right(invitesResponse);
      } else {
        return Left(ApiError(errorDescription: response.data['error'] ?? '' ));

      }
    }  catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }
}