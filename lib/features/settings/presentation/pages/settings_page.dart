import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageController createState() => SettingsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SettingsPageView extends WidgetView<SettingsPage, SettingsPageController> {

  const _SettingsPageView(SettingsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return  [
            const CustomInnerPageSliverAppBar(pageTitle: "Settings", pinned: true,)
          ];
        }, body: SingleChildScrollView(
          child: Column(
            children: [
              /// account -----------
              ListTile(
                onTap: () {
                  context.push(context.generateRoutePath(subLocation: accountSettingsPage));
                },
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset('assets/svg/account.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
                  // ,
                ),
                minLeadingWidth: 23,
                title: const Text("Account"),
              ),

              // /// Areas of interest -----
              ListTile(
                onTap: () {
                  context.push(context.generateRoutePath(subLocation: interestSettingPage));
                },
                leading: SizedBox(
                  width: 23,
                  height: 23,
                  child: SvgPicture.asset('assets/svg/settings.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
                  // ,
                ),
                minLeadingWidth: 0,
                title: const Text("Areas of interest"),
              ),


              /// Job Preferences -----
              ListTile(
                onTap: () {
                  // pushScreen(context, const JobPreferences());
                  context.push(context.generateRoutePath(subLocation: jobPreferencesSettingsPage));
                },
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset('assets/svg/briefcase_outline.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
                  // ,
                ),
                minLeadingWidth: 23,
                title: const Text("Job Preferences"),
              ),

              /// Display and more -----
              ListTile(
                onTap: () {
                  context.push(context.generateRoutePath(subLocation: displaySettingsPage));
                },
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset('assets/svg/display.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
                  // ,
                ),
                minLeadingWidth: 23,
                title: const Text("Display & More"),
              ),

              // /// Privacy -----
              // ListTile(
              //   onTap: () {
              //
              //   },
              //   leading: SizedBox(
              //     width: 20,
              //     height: 20,
              //     child: SvgPicture.asset('assets/svg/account.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
              //     // ,
              //   ),
              //   minLeadingWidth: 23,
              //   title: const Text("Privacy"),
              // ),
              //
              // /// Notifications -----
              // ListTile(
              //   onTap: () {
              //
              //   },
              //   leading: SizedBox(
              //     width: 20,
              //     height: 20,
              //     child: SvgPicture.asset('assets/svg/notification_icon.svg', colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn)),
              //     // ,
              //   ),
              //   minLeadingWidth: 23,
              //   title: const Text("Notifications"),
              // ),
              // const SizedBox.shrink(),
            ],

          ),

        )
          ,)
    );
    
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SettingsPageController extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) => _SettingsPageView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}