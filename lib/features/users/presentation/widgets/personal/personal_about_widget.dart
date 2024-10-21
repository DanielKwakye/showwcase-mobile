import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_about_editor_page.dart';

class PersonalAboutWidget extends StatefulWidget {

  const PersonalAboutWidget({Key? key}) : super(key: key);

  @override
  PersonalAboutWidgetController createState() => PersonalAboutWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalAboutWidgetView extends WidgetView<PersonalAboutWidget, PersonalAboutWidgetController> {

  const _PersonalAboutWidgetView(PersonalAboutWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
        selector: (userState) {

          final currentUser = AppStorage.currentUserSession;
          final index = userState.userProfiles.indexWhere((element) => element.username == currentUser?.username);
          if(index < 0){
            return null;
          }
          final userInfo = userState.userProfiles[index].userInfo;
          return userInfo;

        }, builder: (_, userInfo) {

            if(userInfo == null) {
              return const SizedBox.shrink();
            }

            return Column(
            children: [
              Row(
                children: [
                  const Text(
                    'About',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if(userInfo.about != null && userInfo.about != '') ... {
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:  Container(
                        width: 35,
                        height: 35,
                        color: theme.colorScheme.outline,
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 12, color: theme.colorScheme.onBackground,),
                          onPressed: () {
                            pushScreen(context, const PersonalAboutEditorPage());
                          },
                        ),
                      ),
                    ),
                  }

                ],
              ),

              const SizedBox(height: 10,),

              if(userInfo.about == null || userInfo.about == '') ... [

                /// when no about content has been added

                const Text(
                  'Share something about yourself',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    'Use Markdown to share more about who you are with the developer community on Showwcase.',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: theme.colorScheme.onPrimary),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 15,
                ),
                CustomButtonWidget(
                  text: 'Add About',
                  onPressed: () {
                    pushScreen(context, const PersonalAboutEditorPage());
                  },
                  textColor: Colors.white,
                ),
              ] else ... {

                /// when  about content is NOT EMPTY , show the markdown
                CustomMarkdownWidget(
                  markdown: userInfo.about ?? '',
                  onLinkTapped: (link) {
                    context.push(browserPage, extra: link);
                  },
                  onMentionTapped: (mention) {
                    if(mention.startsWith('u/')){
                      mention = mention.substring(2);
                    }
                    final url = "https://www.showwcase.com/${mention.toLowerCase()}";
                    context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: browserPage, fallBackRoutePathData:  url);
                  },
                ),

              }

            ],
          );

        }
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalAboutWidgetController extends State<PersonalAboutWidget> {

  @override
  Widget build(BuildContext context) => _PersonalAboutWidgetView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}