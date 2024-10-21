import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class GetStarted extends StatefulWidget {

  final Function()? onCompleted;
  const GetStarted({Key? key, this.onCompleted}) : super(key: key);

  @override
  GetStartedController createState() => GetStartedController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _GetStartedView extends WidgetView<GetStarted, GetStartedController> {

  const _GetStartedView(GetStartedController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, next) {
        return next.status == AuthStatus.selectGetStartedReasonCompleted;
      },
        builder: (context, authState) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  return
                    CustomButtonWidget(
                        expand: true,
                        fontWeight: FontWeight.w700,
                        loading: authState.status == AuthStatus.markOnboardingAsCompleteInProgress,
                        disabled: authState.getStartedReason == null,
                        onPressed: (){
                          widget.onCompleted?.call();
                        }, text: 'Next',
                  );
                },
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              children: [
                Text(
                  'How would you like to get started?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800,fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    state.selectReason(GetStartedReason.connectWithCommunity);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                    decoration: BoxDecoration(
                      color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(4),
                      border: authState.getStartedReason == GetStartedReason.connectWithCommunity ? Border.all(color: kAppBlue) : null
                    ),
                    child: Column(
                      children: [
                        Center(child: CircleAvatar(
                          backgroundColor: theme.colorScheme.outline,
                          radius: 27,
                          child: SvgPicture.asset(kConnectDevelopers,height: 27, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),),
                        )),
                        const SizedBox(height: 12,),
                        const Center(child: Text('Connect with developers and the community',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),textAlign: TextAlign.center,)),
                        const SizedBox(height: 6,),
                        Text("Explore communities and build your developer network.",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.6)
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    // widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    // widget.onSignUpTypeSelected(true);]
                    state.selectReason(GetStartedReason.lookingForJobs);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                    decoration: BoxDecoration(
                      color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(4),
                      border: authState.getStartedReason == GetStartedReason.lookingForJobs ? Border.all(color: kAppBlue) : null
                    ),
                    child: Column(
                      children: [
                        Center(child: CircleAvatar(
                          backgroundColor:  theme.brightness == Brightness.light ? theme.colorScheme.outline : kAppBlack,
                          radius: 27,
                          child: SvgPicture.asset(kHireDevelopers,height: 27, colorFilter: const ColorFilter.mode(kAppGreen, BlendMode.srcIn),),
                        )),
                        const SizedBox(height: 12,),
                        const Center(child: Text('I’m looking for work',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)),
                        const SizedBox(height: 6,),
                        Text("Set preferences and explore jobs tailored for you.",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.6)
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class GetStartedController extends State<GetStarted> {

  late AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => _GetStartedView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void selectReason(GetStartedReason reason) {
    authCubit.selectGetStartedReason(reason: reason);
  }


}