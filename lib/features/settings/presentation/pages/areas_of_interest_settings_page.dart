import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/auth/data/models/interest_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

import '../../../auth/data/bloc/auth_enums.dart';

class AreasOfInterestSettingsPage extends StatefulWidget {

  const AreasOfInterestSettingsPage({Key? key}) : super(key: key);

  @override
  AreasOfInterestSettingsPageController createState() => AreasOfInterestSettingsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AreasOfInterestSettingsPageView extends WidgetView<AreasOfInterestSettingsPage, AreasOfInterestSettingsPageController> {

  const _AreasOfInterestSettingsPageView(AreasOfInterestSettingsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
             CustomInnerPageSliverAppBar(pageTitle: "Interests",
              actions: [
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (ctx, authState) {
                    return UnconstrainedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: CustomButtonWidget(
                          text: 'Save',
                          loading: authState.status == AuthStatus.updateInterestsInProgress,
                          expand: false,
                          appearance: Appearance.clean,
                          outlineColor: Colors.transparent,
                          textColor: kAppBlue,
                          onPressed: () => state.authCubit.updateInterests(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ];
        }, body: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select your areas of interest ',
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

                ]
              ,
            ),
          ),
        ),)
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AreasOfInterestSettingsPageController extends State<AreasOfInterestSettingsPage> {

  late AuthCubit authCubit;
  late StreamSubscription<AuthState> authStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _AreasOfInterestSettingsPageView(this);

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    authCubit.fetchInterests();
    authStateStreamSubscription = authCubit.stream.listen((event) {
      if(event.status == AuthStatus.updateInterestsFailed){
        context.showSnackBar('Unable to save interests. Please check your connection');
      }
      if(event.status == AuthStatus.updateInterestsSuccessful){
        // widget.onCompleted?.call();
        context.showSnackBar('Saved');
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    authStateStreamSubscription.cancel();
    super.dispose();
  }

  void handleInterestsCompleted() {
    // send interests to server
    authCubit.updateInterests();
  }

}