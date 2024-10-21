import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/walkthrough/presentation/widgets/walthrough_widget.dart';

final  pages = [
  {
    'title': 'Your Front Page to the Tech Community',
    'subTitle': 'Showwcase your blogs, work history, and top repositories from Github. Let this be your front page to the world.',
    'image': kWalkThroughImage1
  },
  {
    'title': 'Hang out & Connect like a True Developer',
    'subTitle': "Drop into the network and start a Thread with code, video, images, polls, and more. Stay updated on what's happening in the tech world.",
    'image': kWalkThroughImage2
  },
  {
    'title': 'Build your Developer Community',
    'subTitle': 'Get any community going with moderation tools and custom roles. Become a creator and get access to private communities, paid memberships, and more powerful features.',
    'image': kWalkThroughImage3
  },

  {
    'title': 'Great Companies from Around the World',
    'subTitle': 'Get in front of Startups and companies that are looking to augment their internal teams with you.',
    'image': kWalkThroughImage4
  },

  {
    'title': 'Share Your Work and Recent Updates',
    'subTitle': 'As developers we’re always launching new products, writing blogs, joining a podcast, or working on a new project.',
    'image': kWalkThroughImage5
  },


];

class WalkThroughPage extends StatefulWidget {

  const WalkThroughPage({Key? key}) : super(key: key);

  @override
  WalkThroughPageController createState() => WalkThroughPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _WalkThroughPageView extends WidgetView<WalkThroughPage, WalkThroughPageController> {

  const _WalkThroughPageView(WalkThroughPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
          body: Stack(
            children: [
              PageView(
                onPageChanged: state._onPageChanged,
                children: [
                  ...pages.map((e) => WalkThroughWidget(page: e))
                ],
              ),

              IgnorePointer(
                ignoring: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // padding: EdgeInsets.only(top: 10.h),
                    height: media.size.height / 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.01),
                          theme.colorScheme.primary.withOpacity(0.4),
                          theme.colorScheme.primary.withOpacity(0.7),
                          theme.colorScheme.primary.withOpacity(1.0),
                          theme.colorScheme.primary.withOpacity(1.0),
                          theme.colorScheme.primary
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // duration: 500,
                    // animationType: AnimationType.slideUp,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: CustomButtonWidget(
                          appearance: Appearance.primary, text: "Login", expand: true,
                          onPressed: state._onLoginTapped,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: CustomButtonWidget(
                          appearance: Appearance.secondary, text: "Signup",
                          expand: true,
                          onPressed: state._onSignUpTapped,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...pages.map((e) => _dot(context, pages.indexOf(e))),
                        ],
                      ),
                      const SizedBox(height: 10,),

                    ],
                  ),
                ),
              )
            ],
          )
        );
  }

  Widget _dot(BuildContext context, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kMaxBorderRadius),
        color: state.currentIndex == index ? Theme.of(context).colorScheme.onBackground : kAppGray,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 20,

    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class WalkThroughPageController extends State<WalkThroughPage> {

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onPageChanged(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => _WalkThroughPageView(this);


  /// When user taps on login
  void _onLoginTapped(){
    context.push(logInPage);
  }

  /// when user taps on sign up
  void _onSignUpTapped(){
    context.push(signupPage);
  }
}