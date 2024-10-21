import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/auth/data/models/interest_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class InterestsSetupPage extends StatefulWidget {

  final Function()? onCompleted;
  const InterestsSetupPage({Key? key, this.onCompleted}) : super(key: key);

  @override
  InterestsSetupPageController createState() => InterestsSetupPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _InterestsSetupPageView extends WidgetView<InterestsSetupPage, InterestsSetupPageController> {

  const _InterestsSetupPageView(InterestsSetupPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
              child: CustomButtonWidget(
                expand: true,
                loading: authState.status == AuthStatus.updateInterestsInProgress,
                disabled: authState.interests.where((element) => element.selected).length < 5,
                onPressed: state.handleInterestsCompleted, text: 'Next',
              ),
            );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Choose at least 5 interests to get started. ',
                  style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimary,
                      height: 1.4),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (_, next) {
                    return
                      next.status == AuthStatus.fetchInterestsSuccessful ||
                      next.status == AuthStatus.selectInterestCompleted;
                  },
                  builder: (context, authState) {
                    if(authState.status == AuthStatus.fetchInterestsInProgress){
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2),
                        ),
                      );
                    }
                    if(authState.status == AuthStatus.fetchInterestsSuccessful || authState.status == AuthStatus.selectInterestCompleted){
                      if(authState.interests.isEmpty){
                        return const SizedBox.shrink();
                      }
                      return  Wrap(
                        runSpacing: 10,
                        spacing: 15,
                        children: authState.interests.map((InterestModel interest) {
                          return GestureDetector(
                            onTap: (){
                              state.authCubit.toggleInterest(interest: interest);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: interest.selected ? kAppBlue :(theme.brightness == Brightness.dark
                                    ? const Color(0xff202021)
                                    : const Color(0xffF7F7F7)),
                                borderRadius: BorderRadius.circular(30),

                              ),
                              child: Text(interest.name,style:  TextStyle(fontWeight: FontWeight.w600,color: interest.selected ? Colors.white : theme.colorScheme.onBackground),),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )

              ],
            ),
          ),
        ],
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class InterestsSetupPageController extends State<InterestsSetupPage> {

  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;
  @override
  Widget build(BuildContext context) => _InterestsSetupPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    authCubit.fetchInterests();
    authStateStreamSubscription = authCubit.stream.listen((event) {
        if(event.status == AuthStatus.updateInterestsFailed){
          context.showSnackBar('Unable to save interests. Please check your connection');
        }
        if(event.status == AuthStatus.updateInterestsSuccessful){
          widget.onCompleted?.call();
        }
    });

  }

  @override
  void dispose() {
    super.dispose();
    authStateStreamSubscription.cancel();
  }

  void handleInterestsCompleted() {
    // send interests to server
    authCubit.updateInterests();
  }

}