import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_about_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_credentials_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_experiences_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_professionalism_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/personal/personal_tech_stack_widget.dart';

class CompleteProfilePage extends StatefulWidget {

  final Function()? onCompleted;
  const CompleteProfilePage({Key? key, this.onCompleted}) : super(key: key);

  @override
  CompleteProfilePageController createState() => CompleteProfilePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CompleteProfilePageView extends WidgetView<CompleteProfilePage, CompleteProfilePageController> {

  const _CompleteProfilePageView(CompleteProfilePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return  Scaffold(
      bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: CustomButtonWidget(
              fontWeight: FontWeight.w700,
              expand: true,
              onPressed: () {
                widget.onCompleted?.call();
              }, text: 'Next',
            ),
          );
        },
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              'Your Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const CustomBorderWidget(),
          Container(
            padding: const EdgeInsets.all(15.0),
            width: width(context),
            // decoration: BoxDecoration(
            //   color: theme.brightness == Brightness.dark
            //       ? const Color(0xff202021)
            //       : const Color(0xffF7F7F7),
            //   borderRadius: BorderRadius.circular(4),
            // ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.push("/$editProfilePage");
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (_, next){
                  return next.status == AuthStatus.updateAuthUserDataSuccessful;
                },
                builder: (ctx, authState) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomUserAvatarWidget(
                          size: 50,
                          borderSize: 0,
                          borderColor: theme.brightness == Brightness.dark ? kAppBlack : kAppWhite,
                          backgroundColor: theme.colorScheme.background,
                          username: AppStorage.currentUserSession!.displayName,
                          networkImage: getProfileImage(AppStorage.currentUserSession!.profilePictureKey)
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStorage.currentUserSession!.displayName ?? (AppStorage.currentUserSession!.username ?? ""),
                                        style: TextStyle(
                                            color: theme.colorScheme.onBackground,
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        AppStorage.currentUserSession!.activity!.emoji ??  ' ',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ]
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "@${AppStorage.currentUserSession!.username}",
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: theme.colorScheme.onPrimary,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          AppStorage.currentUserSession!.location ?? ' ',
                                          style: TextStyle(
                                              color: theme.colorScheme.onPrimary,
                                              fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              AppStorage.currentUserSession!.headline ?? ' ',
                              style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:  Container(
                          width: 35,
                          height: 35,
                          color: theme.colorScheme.outline,
                          child: Icon(Icons.edit, size: 12, color: theme.colorScheme.onBackground,),
                        ),
                      )
                    ],
                  );
                }
              ),
            ),
          ),
          const CustomBorderWidget(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const PersonalProfessionalismWidget(),
          ),
          const CustomBorderWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const PersonalAboutWidget(),
          ),
          const CustomBorderWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const PersonalTechStackWidget(),
          ),
          const CustomBorderWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const PersonalExperiencesWidget(),
          ),
          const CustomBorderWidget(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const PersonalCredentialsWidget(),
          ),

        ],
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CompleteProfilePageController extends State<CompleteProfilePage> {

  late AuthCubit authCubit;

  @override
  Widget build(BuildContext context) => _CompleteProfilePageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }


  @override
  void dispose() {
    super.dispose();
  }

}