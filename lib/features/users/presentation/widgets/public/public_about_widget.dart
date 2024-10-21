import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class PublicAboutWidget extends StatefulWidget {

  final UserModel userModel;
  const PublicAboutWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  PublicAboutWidgetController createState() => PublicAboutWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PublicAboutWidgetView extends WidgetView<PublicAboutWidget, PublicAboutWidgetController> {

  const _PublicAboutWidgetView(PublicAboutWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
        selector: (userState) {

          final index = userState.userProfiles.indexWhere((element) => element.username == widget.userModel.username);
          if(index < 0){
            return null;
          }
          final userInfo = userState.userProfiles[index].userInfo;
          return userInfo;

        }, builder: (_, userInfo) {

            if(userInfo == null || userInfo.about.isNullOrEmpty()) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10,),

              if(userInfo.about == null || userInfo.about == '') ... [

                /// when no about content has been added

                const SizedBox.shrink()

              ] else ... {

                /// when  about content is NOT EMPTY , show the markdown
                CustomMarkdownWidget(
                  markdown: userInfo.about ?? '',
                  onLinkTapped: (link) {
                    context.read<HomeCubit>().redirectLinkToPage(url: link, fallBackRoutePath: threadBrowserPage, fallBackRoutePathData:  {
                      "url": link,
                    });
                  },
                  onMentionTapped: (mention) {
                    if(mention.startsWith('u/')){
                      mention = mention.substring(2);
                    }
                    final url = "https://www.showwcase.com/${mention.toLowerCase()}";
                    context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: browserPage, fallBackRoutePathData:  url);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomBorderWidget(top: 0, bottom: 0,)
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

class PublicAboutWidgetController extends State<PublicAboutWidget> {

  @override
  Widget build(BuildContext context) => _PublicAboutWidgetView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}