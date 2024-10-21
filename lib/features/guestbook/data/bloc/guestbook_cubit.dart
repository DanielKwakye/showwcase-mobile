import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_state.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_boradcast_event.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';
import 'package:showwcase_v3/features/guestbook/data/repositories/guestbook_broadcast_repository.dart';
import 'package:showwcase_v3/features/guestbook/data/repositories/guestbook_repository.dart';


class GuestbookCubit extends Cubit<GuestbookState> {
  final GuestBookRepository guestBookRepository;



  GuestbookCubit({required this.guestBookRepository,}) : super(const GuestbookState());


  Future<Either<String, List<GuestBookModel>>> fetchGuestBook({required String userName,required int pageKey}) async {
    try {

      final skip = pageKey  > 0 ? state.guestBookMessages.length : pageKey;
      emit(state.copyWith(
        status: GuestBookStatus.fetchGuestbookLoading,
      ));

      final either = await guestBookRepository.fetchProfileGuestbook(limit: defaultPageSize, skip: skip, userName: userName);

      if(either.isLeft()){
        final l = either.asLeft();
        emit(state.copyWith(status: GuestBookStatus.fetchGuestbookError, message: l.errorDescription));
        return Left(l.errorDescription);
      }


      // successful
     List<GuestBookModel> r = either.asRight();
      final List<GuestBookModel> messages = [...state.guestBookMessages];
      if(pageKey == 0){
        // if its first page request remove all existing shows
        messages.clear();
      }

      messages.addAll(r);

      emit(state.copyWith(
        status: GuestBookStatus.fetchGuestBookSuccess,
        guestBookMessages: messages,
      ));

      return Right(r);

    } catch (e) {
      emit(state.copyWith(
          status: GuestBookStatus.fetchGuestbookError,
          message: e.toString()
      ));
      return Left(e.toString());
    }
  }

  void createGuestBook({required String userName,required  String message}) async {


    try {
      emit(state.copyWith(
        status: GuestBookStatus.createGuestbookLoading,
      ));


      final either = await guestBookRepository.createGuestbook(
          userName: userName,message: message);

      either.fold(
              (l) =>
              emit(state.copyWith(
                  status: GuestBookStatus.createGuestbookError,
                  message: l.errorDescription
              )),
              (r) {

            emit(state.copyWith(
              status: GuestBookStatus.createGuestBookSuccess,
            ));
          }
      );
    } catch (e) {
      emit(state.copyWith(
          status: GuestBookStatus.createGuestbookError,
          message: e.toString()
      ));
    }
  }

  void deleteGuestbook({required String userName,required int guestBookId}) async {


    try {
      emit(state.copyWith(
        status: GuestBookStatus.deleteGuestbookLoading,
      ));


      final either = await guestBookRepository.deleteGuestbook(
          userName: userName,guestBookId: guestBookId);

      either.fold(
              (l) =>
              emit(state.copyWith(
                  status: GuestBookStatus.deleteGuestbookError,
                  message: l.errorDescription
              )),
              (r) {

            emit(state.copyWith(
              status: GuestBookStatus.deleteGuestBookSuccess,
            ));
          }
      );
    } catch (e) {
      emit(state.copyWith(
          status: GuestBookStatus.deleteGuestbookError,
          message: e.toString()
      ));
    }
  }

  void editGuestbook({required String userName,required  String message,required int guestBookId}) async {


    try {
      emit(state.copyWith(
        status: GuestBookStatus.editGuestbookLoading,
      ));


      final either = await guestBookRepository.editGuestbook(
          userName: userName,message: message, guestBookId: guestBookId);

      either.fold(
              (l) =>
              emit(state.copyWith(
                  status: GuestBookStatus.editGuestbookError,
                  message: l.errorDescription
              )),
              (r) {

            emit(state.copyWith(
              status: GuestBookStatus.editGuestBookSuccess,
            ));
          }
      );
    } catch (e) {
      emit(state.copyWith(
          status: GuestBookStatus.editGuestbookError,
          message: e.toString()
      ));
    }
  }
}
