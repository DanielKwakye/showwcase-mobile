import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log('bloc observer bloc $bloc onChange $change', name: 'AppBlocObserver');
  }

  @override
  void onClose(BlocBase bloc) {
    log('bloc observer onClose $bloc', name: 'AppBlocObserver');
  }

  @override
  void onCreate(BlocBase bloc) {
    log('bloc observer onCreate $bloc', name: 'AppBlocObserver');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('bloc observer onError $bloc error $error trace $stackTrace', name: 'AppBlocObserver');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log('bloc observer onEvent $bloc event $event', name: 'AppBlocObserver');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('bloc observer onTransition $bloc transition $transition', name: 'AppBlocObserver');
  }
}
