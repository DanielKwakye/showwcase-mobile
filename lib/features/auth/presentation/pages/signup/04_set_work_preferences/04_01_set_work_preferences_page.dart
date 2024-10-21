import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class SetWorkPreferencesPage01 extends StatefulWidget {

  final Function(String?)? onCompleted;
  const SetWorkPreferencesPage01({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage01Controller createState() => SetWorkPreferencesPage01Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage01View extends WidgetView<SetWorkPreferencesPage01, SetWorkPreferencesPage01Controller> {

  const _SetWorkPreferencesPage01View(SetWorkPreferencesPage01Controller state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<String?>(valueListenable: state.workPreferenceOption, builder: (_, option, __) {
        if(option == null || option == 'skip'){
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: CustomButtonWidget(
            expand: true,
            fontWeight: FontWeight.w700,
            onPressed: (){
              widget.onCompleted?.call(null);
            }, text: 'Next',
          ),
        );
      }),
      body: ValueListenableBuilder<String?>(builder: (_, option, __){
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          children: [
            GestureDetector(
              onTap: (){
                state.selectOption("set_to_find_jobs");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                decoration: BoxDecoration(
                    color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(4),
                    border: option == 'set_to_find_jobs' ? Border.all(color: kAppBlue) : null
                ),
                child: Column(
                  children: [
                    const Center(child: Text('Set work preferences',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),textAlign: TextAlign.center,)),
                    const SizedBox(height: 6,),
                    Text("This is to find jobs suited to you",
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
                state.selectOption("skip");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                decoration: BoxDecoration(
                    color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(4),
                    border: option == 'skip' ? Border.all(color: kAppBlue) : null
                ),
                child: Column(
                  children: [
                    const Center(child: Text("Skip for now",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)),
                    const SizedBox(height: 6,),
                    Text("You can always set this up later",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: theme.colorScheme.onPrimary,height: 1.6)
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            if(option == "skip") ... {
              Row(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      widget.onCompleted?.call("/$jobsPage");
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                        decoration: BoxDecoration(
                          color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: CircleAvatar(
                              backgroundColor:  theme.brightness == Brightness.light ? theme.colorScheme.outline : kAppBlack,
                              radius: 27,
                              child: SvgPicture.asset(kWorkIconSvg,height: 27, colorFilter: const ColorFilter.mode(kAppGreen, BlendMode.srcIn),),
                            )),
                            const SizedBox(height: 12,),
                            const Center(child: Text("See Jobs",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,), maxLines: 1,)),
                          ],
                        )
                    ),
                  )),
                  const SizedBox(width: 10,),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      widget.onCompleted?.call("/$personalProfilePage");
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                        decoration: BoxDecoration(
                          color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: CircleAvatar(
                              backgroundColor:  theme.brightness == Brightness.light ? theme.colorScheme.outline : kAppBlack,
                              radius: 27,
                              child: SvgPicture.asset(kUserIconSvg,height: 27, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),),
                            )),
                            const SizedBox(height: 12,),
                            const Center(child: Text("See Profile",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700), maxLines: 1,)),
                          ],
                        )
                    ),
                  )),
                ],
              )
            }
          ],
        );

      }, valueListenable: state.workPreferenceOption,),
    );


  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SetWorkPreferencesPage01Controller extends State<SetWorkPreferencesPage01> {

  final ValueNotifier<String?> workPreferenceOption = ValueNotifier(null);

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage01View(this);

  @override
  void initState() {
    super.initState();
  }

  void selectOption(String option){
    workPreferenceOption.value = option;
  }


  @override
  void dispose() {
    super.dispose();
  }

}