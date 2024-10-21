import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/features/auth/data/models/interest_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';

class AuthRepository {

  final NetworkProvider _networkProvider;
  AuthRepository(this._networkProvider);

  Future<UserModel?> getCurrentUserSession() async {
    //  check if user has accessToken and authUserDetails is set
    UserModel? user  = AppStorage.currentUserSession;

    // return user session if any
    if(user != null) {
      return user;
    }

    // attempt to retrieve user details from pref
    final json = await AppStorage.getFromPref(key: "authUserDetails");

    // if there's no authUserDetails
    if(json == null) {
      return null;
    }

    user = UserModel.fromJson(json);
    AppStorage.currentUserSession = user;

    return user;

  }

  /// This is the first step of email login ----
  /// The user will receive a verification code if this method is called
  Future<Either<ApiError, void>> submitEmailForValidation({required String email}) async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.loginWithEmail, method: RequestMethod.post,body: { "email": email});
      if(response!.statusCode == 200){
        return const Right(null);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  /// This is the second step of email login ----
  /// login with email and verificationCode
  Future<Either<ApiError, String>> authenticateWithEmail({required String email, required String verificationCode}) async {

    try{
      var response = await _networkProvider.call(path: ApiConfig.loginWithEmail, method: RequestMethod.post,
          body: {
            'email': email,
            'password': verificationCode
          }
      );
      if(response!.statusCode == 200){
        return Right(response.data['token'] as String);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }

    }catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, UserModel>> login({required String token}) async {


    try{

      // save token to local storage
      await _saveToken(token: token);

      var response = await _networkProvider.call(path: ApiConfig.authDetails, method: RequestMethod.get);

      if(response!.statusCode == 200){

        final UserModel userModel = UserModel.fromJson(response.data);
        // automatically save user to local storage after retrieving
        await AppStorage.saveToPref(key: "authUserDetails", jsonValue: userModel.toJson());

        // set authenticated user session
        AppStorage.currentUserSession = userModel;

        // User is authenticated
        return Right(userModel);

      }else{
        return Left(ApiError(errorDescription: response.data['message']));
      }

    } catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<bool> _saveToken({required String token}) async {
    AppStorage.setAuthTokenVal(token);
    return true;
  }

  /// Log user out
  void logout() {
    // remove accessToken
    AppStorage.removeAuthTokenVal();

    // remove authUserDetails
    AppStorage.remove(key: "authUserDetails");

    // remove user from session
    AppStorage.currentUserSession = null;

    OneSignal.logout();

  }

  Future<Either<ApiError, void>> updateAuthUserDataLocally({required UserModel updatedUserModel}) async {

    try{

        // automatically save user to local storage after retrieving
        await AppStorage.saveToPref(key: "authUserDetails", jsonValue: updatedUserModel.toJson());

        // set authenticated user session
        AppStorage.currentUserSession = updatedUserModel;

        // User is authenticated
        return const Right(null);


    } catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }




  Future<Either<ApiError, bool>> checkIfUsernameExists({required String username}) async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.checkUsernameOrEmail("username=$username"), method: RequestMethod.get);
      if(response!.statusCode == 200){
        final available = response.data['available'] as bool;
        return Right(available);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, bool>> checkIfEmailExists({required String email}) async{

    try{
      final response = await _networkProvider.call(path: ApiConfig.checkUsernameOrEmail("email=$email"), method: RequestMethod.get);
      if(response!.statusCode == 200){
        final available = response.data['available'] as bool;
        return Right(available);
      }else{
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> updateAuthUserData({required UserModel userModel}) async{

    try{
      var response = await _networkProvider.call(path: ApiConfig.updateProfile, method: RequestMethod.put, body: userModel.toJson());
      if(response!.statusCode == 200){

        // save the details locally
        return updateAuthUserDataLocally(updatedUserModel: userModel);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  Future<Either<ApiError, List<InterestModel>>> fetchInterests()async {
    try {

      final response = await _networkProvider.call(path: ApiConfig.interests, method:  RequestMethod.get);
      if (response!.statusCode == 200) {

        final currentUser = AppStorage.currentUserSession;
        final currentUserInterests = currentUser?.interests ?? [];
        final result = List<InterestModel>.from(response.data.map((x) {
          final selected = currentUserInterests.contains(x);
          return InterestModel(name: x, selected: selected);
        }));
        return Right(result);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, void>> updateUserInterests({required List<String> interests}) async{
    try{
      var response = await _networkProvider.call(path: ApiConfig.updateInterests, method: RequestMethod.put,
          body: {'interests': interests}
      );
      if(response!.statusCode == 200){
        return const Right(null);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, void>> deleteProfile() async {
    try {
      await  Future.delayed(const Duration(seconds: 2));
      final path = ApiConfig.updateProfile;
      var response = await _networkProvider.call(path: path, method: RequestMethod.delete,);
      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


  Future<Either<ApiError, void>> updateOnboardingReason({required UserSettingsModel settings}) async {

    try{
      var response = await _networkProvider.call(path: ApiConfig.updateProfileSettings, method: RequestMethod.post,
          body: settings.toJson()
      );
      if(response!.statusCode == 200){
        return const Right(null);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioException catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> markOnboardingAsComplete() async {

    try{
      var response = await _networkProvider.call(path: ApiConfig.updateProfile, method: RequestMethod.put,
          body: {
            "onboarded": true
          }
      );
      if(response!.statusCode == 200){
        return const Right(null);
      }else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    }on DioError catch(e){
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<Either<ApiError, void>> updateAuthUserSetting(UserSettingsModel? setting) async {
    try {

      String url = ApiConfig.updateProfileSettings;

      final bodyAsJson = setting?.toJson();

      final response = await _networkProvider.call(path: url,
          method: RequestMethod.post,
          body: bodyAsJson
      );

      if (response!.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ApiError(errorDescription: response.data['error']));
      }
    } catch (e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }


}