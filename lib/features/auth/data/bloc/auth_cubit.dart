import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/auth/data/models/interest_model.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_broadcast_repository.dart';
import 'package:showwcase_v3/features/auth/data/repositories/auth_repository.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';
import 'package:showwcase_v3/features/users/data/repositories/user_broadcast_repository.dart';

/// Every thing Preferences is included in the AuthCubit
///
class AuthCubit extends Cubit<AuthState> {

  final AuthRepository authRepository;
  final AuthBroadcastRepository authBroadcastRepository;
  final UserBroadcastRepository userBroadcastRepository;
  StreamSubscription<UserModel>? userBroadcastRepositoryStreamListener;

  AuthCubit({required this.authRepository,
    required this.authBroadcastRepository,
    required this.userBroadcastRepository,
  }): super(const AuthState()){
    // listen to authCubit changes
    listenForUserUpdates();
  }

  void listenForUserUpdates() async {
    await userBroadcastRepositoryStreamListener?.cancel();
      userBroadcastRepositoryStreamListener = userBroadcastRepository.stream.listen((user) {
        // the user can be any user in the system
        if(user.username == AppStorage.currentUserSession?.username) {
          updateAuthUserData(user, emitToSubscribers: false);
        }

    });
  }

  // Close stream subscriptions when cubit is disposed to avoid any memory leaks
  @override
  Future<void> close() async {
    await userBroadcastRepositoryStreamListener?.cancel();
    return super.close();
  }


  void submitEmailForValidation({required String email, bool resend = false}) async  {

     try {

       emit(state.copyWith(status:
       resend ? AuthStatus.submitEmailForValidationResendInProgress : AuthStatus.submitEmailForValidationInProgress,));

       final either = await authRepository.submitEmailForValidation(email: email);

       either.fold((l)  {

         emit(state.copyWith(
             status: resend ? AuthStatus.submitEmailForValidationResendFailed : AuthStatus.submitEmailForValidationFailed,
             message: l.errorDescription
         ));

       }, (r) {

         emit(state.copyWith(
             status:resend ? AuthStatus.submitEmailForValidationResendSuccessful : AuthStatus.submitEmailForValidationSuccessful,
         ));

       });


     }catch(e) {
       emit(state.copyWith(
           status: resend ? AuthStatus.submitEmailForValidationResendFailed : AuthStatus.submitEmailForValidationFailed,
         message: e.toString()
       ));
     }
  }

  Future<String?> authenticateWithEmail({required String email, required String verificationCode}) async  {

    try {

      emit(state.copyWith(status: AuthStatus.authenticateWithEmailInProgress,));

      final either = await authRepository.authenticateWithEmail(email: email, verificationCode: verificationCode);

      if(either.isLeft()){
        final apiError = either.asLeft();
        emit(state.copyWith(
            status: AuthStatus.authenticateWithEmailFailed,
            message: apiError.errorDescription
        ));
        return null;
      }

      // successful
      final token = either.asRight();
      emit(state.copyWith(status: AuthStatus.authenticateWithEmailSuccessful,));
      return token;

    }catch(e) {
      emit(state.copyWith(status: AuthStatus.authenticateWithEmailFailed, message: e.toString()));
      return null;
    }
  }

  void login({required String token}) async {

    try{

      emit(state.copyWith(status: AuthStatus.loginInProgress,));

      // log the user in
      final either = await authRepository.login(token: token);

      either.fold((l) {
        emit(state.copyWith(status: AuthStatus.loginFailed, message: l.errorDescription));
      }, (r) {

        // voila! Login successful

        // emit to all authStreamSubscriber about a successful login
        // for first signup, the username is null so we don't set the UserProfile
        if(r.username != null) {
          authBroadcastRepository.updateUserProfile(loggedInUser: r);
        }
        

        emit(state.copyWith(
          status: AuthStatus.loginSuccessful,
        ));

      });


    }catch(e) {
      emit(state.copyWith(status: AuthStatus.loginFailed, message: e.toString()));
    }

  }

  void logout() {
    emit(state.copyWith(status: AuthStatus.logoutInProgress));
    authRepository.logout();
    authBroadcastRepository.logout();
    emit(const AuthState(status: AuthStatus.logoutCompleted,));
  }

  Future<bool?> checkIfUsernameExists({required String username}) async {

    try{

      emit(state.copyWith(status: AuthStatus.checkIfUsernameExistsInProgress));

      final either = await authRepository.checkIfUsernameExists(username: username);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: AuthStatus.checkIfUsernameExistsFailed, message: l.errorDescription));
        return null;
      }

      // then we got a result
      emit(state.copyWith(status: AuthStatus.checkIfUsernameExistsSuccessful, ));
      final r = either.asRight();
      return r;


    }catch(e) {
      emit(state.copyWith(status: AuthStatus.checkIfUsernameExistsFailed, message: e.toString()));
      return null;
    }

  }

  Future<bool?> checkIfEmailExists({required String email}) async {

    try{

      emit(state.copyWith(status: AuthStatus.checkIfEmailExistsInProgress));

      final either = await authRepository.checkIfEmailExists(email: email);
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: AuthStatus.checkIfEmailExistsFailed, message: l.errorDescription));
        return null;
      }

      // then we got a result
      emit(state.copyWith(status: AuthStatus.checkIfEmailExistsSuccessful, ));
      final r = either.asRight();
      return r;


    }catch(e) {
      emit(state.copyWith(status: AuthStatus.checkIfEmailExistsFailed, message: e.toString()));
      return null;
    }
  }

  // Defaults to : update auth user locally and on the server
  Future<void> updateAuthUserData(UserModel updatedUser, {bool localOnly = false, emitToSubscribers = true, bool optimistic = false}) async {

    final currentUserExistingState = AppStorage.currentUserSession?.copyWith();


    Future<void> optimisticUpdate() async {
      emit(state.copyWith(status: AuthStatus.optimisticUpdateAuthUserDataInProgress));
      await authRepository.updateAuthUserDataLocally(updatedUserModel: updatedUser);
      emit(state.copyWith(status: AuthStatus.optimisticUpdateAuthUserDataSuccessful,));
    }

    optimisticUpdateReverse() async {
      emit(state.copyWith(status: AuthStatus.optimisticUpdateAuthUserDataInProgress));
      await authRepository.updateAuthUserDataLocally(updatedUserModel: currentUserExistingState!);
      emit(state.copyWith(status: AuthStatus.optimisticUpdateAuthUserDataFailed,));
    }

    try{

      if(optimistic) { await optimisticUpdate();}

      emit(state.copyWith(status: AuthStatus.updateAuthUserDataInProgress));

      if(localOnly) {
        await authRepository.updateAuthUserDataLocally(updatedUserModel: updatedUser);
        emit(state.copyWith(status: AuthStatus.updateAuthUserDataSuccessfulOnLocal,));
        return;
      }

      // update user details on the server
      final either = await authRepository.updateAuthUserData(userModel: updatedUser);
      if(either.isLeft()){

        if(optimistic) {optimisticUpdateReverse();}

        final l = either.asLeft();
        emit(state.copyWith(status: AuthStatus.updateAuthUserDataFailed, message: l.errorDescription));
        return;
      }

      // successful
      // update subscribers
      if(emitToSubscribers) {
        authBroadcastRepository.updateUserProfile(loggedInUser: updatedUser);
      }
      emit(state.copyWith(status: AuthStatus.updateAuthUserDataSuccessful,));


    }catch(e) {
      if(optimistic) {optimisticUpdateReverse();}
      emit(state.copyWith(status: AuthStatus.updateAuthUserDataFailed, message: e.toString()));
    }

  }



  void selectGetStartedReason({required GetStartedReason reason}) {
    try{
      emit(state.copyWith(status: AuthStatus.selectGetStartedReasonInProgress));

      final currentUser = AppStorage.currentUserSession!;
      // send reason to server. No need to wait for response
      String reasonAsString = reason == GetStartedReason.connectWithCommunity ? "connect" : "work";
      final settings = (currentUser.settings ?? const UserSettingsModel()).copyWith(
          onboardingReason: reasonAsString
      );

      final updatedCurrentUser = currentUser.copyWith(
          settings: settings,
          onboarded: reason == GetStartedReason.connectWithCommunity ? false : true
      );

      // updated user details
      updateAuthUserData(updatedCurrentUser);
      debugPrint("customLog: onboarded: -> ${updatedCurrentUser.onboarded} :: onboardedReason -> ${updatedCurrentUser.settings?.onboardingReason}");

      authRepository.updateOnboardingReason(settings: settings);

      emit(state.copyWith(
          status: AuthStatus.selectGetStartedReasonCompleted,
          getStartedReason: reason
      ));
    }catch(e) {
      debugPrint(e.toString());
    }
  }

  void fetchInterests() async {

    try{

      emit(state.copyWith(status: AuthStatus.fetchInterestsInProgress,));

      final either = await authRepository.fetchInterests();

      either.fold((l) => emit(state.copyWith(
          status: AuthStatus.fetchInterestsFailed,
          message: l.errorDescription
      )), (r) {

        final interests = [...state.interests];

        for (var element in r) {
          final index = interests.indexWhere((e) => e.name == element.name);
          // only add if the interest does not exists locally. so that the state is kept
          if(index < 0) {

            interests.add(element);
          }
        }

        emit(state.copyWith(
            status: AuthStatus.fetchInterestsSuccessful,
            interests: interests
        ));

      });

    }catch(e){
      emit(state.copyWith(
        status: AuthStatus.fetchInterestsFailed,
        message: e.toString()
      ));
    }

  }

  void toggleInterest({required InterestModel interest}) {

    emit(state.copyWith(status: AuthStatus.selectInterestInProgress));

    final interests = [...state.interests];
    final index = interests.indexWhere((element) => element.name == interest.name);
    if(index < 0) {
      emit(state.copyWith(status: AuthStatus.selectInterestCompleted));
      return;
    }

    final selectedInterest = interests[index];
    interests[index] = selectedInterest.copyWith(
      selected:  !selectedInterest.selected
    );

    emit(state.copyWith(status: AuthStatus.selectInterestCompleted,
        interests: interests
    ));
  }

  void updateInterests() async{

    try{
      emit(state.copyWith(status: AuthStatus.updateInterestsInProgress));

      final either = await authRepository.updateUserInterests(interests: state.interests.where((element) => element.selected).map((e) => e.name).toList());

      either.fold(
              (l) => emit(state.copyWith(status: AuthStatus.updateInterestsFailed, message: l.errorDescription)),
              (r) {
                final updatedUser = AppStorage.currentUserSession?.copyWith(
                    interests: state.interests.where((element) => element.selected).map((e) => e.name).toList()
                );
                if(updatedUser != null){
                  updateAuthUserData(updatedUser, localOnly: true);
                }

                emit(state.copyWith(status: AuthStatus.updateInterestsSuccessful,));
              }
      );

    }catch(e){
      emit(state.copyWith(status: AuthStatus.updateInterestsFailed, message: e.toString()));
    }
  }

  void markOnboardingAsComplete({required UserModel updatedUser, bool caContinueOnboarding = false}) async{

    try{

      emit(state.copyWith(status: AuthStatus.markOnboardingAsCompleteInProgress));

      final either = await authRepository.markOnboardingAsComplete();
      either.fold(
              (l) => emit(state.copyWith(status: AuthStatus.markOnboardingAsCompleteFailed, message: l.errorDescription)),
              (r) async {
                  await updateAuthUserData(updatedUser, localOnly: true);

                  if(caContinueOnboarding) {
                    emit(state.copyWith(
                        status: AuthStatus.markOnboardingAsCompleteSuccessfulWithOptionToContinue,
                    ));
                    return;
                  }

                  emit(state.copyWith(
                    status: AuthStatus.markOnboardingAsCompleteSuccessful,
                  ));
              }
      );

    }catch(e){
      emit(state.copyWith(status: AuthStatus.markOnboardingAsCompleteFailed, message: e.toString()));
    }
  }



  // this method is here because its related to only authenticated user ---------
  /// JobPreferences is in the AuthCubit only

  void updateAuthUserSetting(UserSettingsModel? settings) async {

    final user = AppStorage.currentUserSession!;
    final existingSettings = user.settings;
    optimisticUpdate({bool reverse = false, String? reason }){
      AppStorage.currentUserSession = user.copyWith(settings: reverse ? existingSettings : settings);
      emit(state.copyWith(
         status: reverse ? AuthStatus.updateAuthUserSettingFailed : AuthStatus.updateAuthUserSettingSuccessful,
        message: reason
      ));
    }

    try {

      emit(state.copyWith(status: AuthStatus.updateAuthUserSettingInProgress));

      // first update
      optimisticUpdate();

      final either = await authRepository.updateAuthUserSetting(settings);

      either.fold((l) {
        optimisticUpdate(reverse: true, reason: l.errorDescription);
      }, (r) {

        // do nothing cus we've already run optimistic update

      });

    }catch(e) {
      optimisticUpdate(reverse: true, reason: e.toString());
    }

  }


  Future<String?> deleteProfile() async {
    try {

      emit(state.copyWith(status: AuthStatus.deleteAccountLoading,));

      final either = await authRepository.deleteProfile();
      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(message: l.errorDescription, status: AuthStatus.deleteAccountError));
        return l.errorDescription;
      }

      // successful
      emit(state.copyWith(status: AuthStatus.deleteAccountSuccessful,));
      return null;

    } catch (e) {
      emit(state.copyWith(message: e.toString(), status: AuthStatus.deleteAccountError));
      return e.toString();
    }
  }


}