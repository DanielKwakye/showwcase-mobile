import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class PageNotFound extends StatelessWidget with LaunchExternalAppMixin {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(onPressed: (){
          context.go("/");
        }, color: theme.colorScheme.onBackground,),
      ),
      body: Center(
        child: Container(
          // width: media.size.width,
          // height: media.size.height,
          color: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Page Not Found", style: theme.textTheme.titleLarge,),
                const SizedBox(height: 20,),
                 Text("Sorry!. The page you're looking for cannot be found.  Kindly report to the Showwcase Team",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onBackground),),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                       children: [
                         Expanded(child: CustomButtonWidget(text: "Go home", onPressed: () {
                           context.go("/");
                         },expand: true,),),
                         const SizedBox(width: 10,),
                         Expanded(child: CustomButtonWidget(text: "Report", onPressed: () {
                           openEmail("developers@showwcase.com");
                         }, expand: true, appearance: Appearance.secondary,))

                       ],
                    ),
                  )

              ],
            ),
          ),
        ),
        // child: CustomErrorWidget(
        //   message: "Sorry!. The page you're looking for cannot be found. This is a technical problem. Kindly report to the Showwcase Team",
        //   onRefreshTapped: () {
        //   context.go(home);
        // },),
      ),
    );
  }
}
