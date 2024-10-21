import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_enums.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_state.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_time_zone_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';

class SetWorkPreferencesPage12 extends StatefulWidget {

  final Function(String)? onCompleted;
  const SetWorkPreferencesPage12({Key? key, this.onCompleted}) : super(key: key);

  @override
  SetWorkPreferencesPage12Controller createState() => SetWorkPreferencesPage12Controller();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SetWorkPreferencesPage12View extends WidgetView<SetWorkPreferencesPage12, SetWorkPreferencesPage12Controller> {

  const _SetWorkPreferencesPage12View(SetWorkPreferencesPage12Controller state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: Row(
             children: [

               Expanded(child: CustomButtonWidget(
                 expand: true,
                 fontWeight: FontWeight.w700,
                 appearance: Appearance.secondary,
                 onPressed: (){
                   widget.onCompleted?.call("/$personalProfilePage");
                 }, text: 'Go to profile',
               )),
               const SizedBox(width: 10,),
               Expanded(child: CustomButtonWidget(
                 expand: true,
                 fontWeight: FontWeight.w700,
                 appearance: Appearance.primary,
                 onPressed: (){
                   widget.onCompleted?.call("/$jobsPage");
                 }, text: 'See jobs',
               )),
             ],
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (_, next) {
            return next.status == AuthStatus.updateAuthUserSettingSuccessful
                || next.status == AuthStatus.updateAuthUserSettingFailed;
          },
          builder: (context, authState) {

            final user = AppStorage.currentUserSession!;

            return  ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(height: 15,),
                Text(
                  'Great! We will sort positions that best fit your preferences.',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 16,),
                Text(
                  'You can always update any of these preferences in your Settings.',
                  style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimary,
                      height: 1.4),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xff202021)
                          : const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(5)),
                  child: SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    separatorBuilder: (BuildContext context, int index) {
                      return const CustomBorderWidget(top: 15, bottom: 15,);
                    },
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job Type',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.types ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                  for(String item in (user.settings?.jobPreferences?.types ?? <String>[])) ...{
                                    TextSpan(text: item.capitalize()),

                                    // if its not the last item append a comma (, )
                                    if((user.settings?.jobPreferences?.types ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.types ?? <String>[]).length - 1)...{
                                      const TextSpan(text: ', '),
                                    }
                                  }
                                  // .forEach((element) {
                                  //   TextSpan(text: ''),
                                  // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      ///Role
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.roleType ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(String item in (user.settings?.jobPreferences?.roleType ?? <String>[])) ...{
                                  TextSpan(text: item.capitalize()),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.roleType ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.roleType ?? <String>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timezone',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.timezone ?? <SharedTimeZoneModel>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(SharedTimeZoneModel item in (user.settings?.jobPreferences?.timezone ?? <SharedTimeZoneModel>[])) ...{
                                  TextSpan(text: item.label.capitalize()),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.timezone ?? <SharedTimeZoneModel>[]).indexOf(item) != (user.settings?.jobPreferences?.timezone ?? <SharedTimeZoneModel>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Problems',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.problem ?? '').isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                TextSpan(text: (user.settings?.jobPreferences?.problem ?? '') == 'will_interview' ? 'Finding companies who are interested in me' : '' ),
                                TextSpan(text: (user.settings?.jobPreferences?.problem ?? '') == 'can_join' ? 'Finding companies that I want to join' : ''),
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Are you Junior Engineer?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                if(user.settings?.jobPreferences?.isJunior != null) ...{
                                  TextSpan(text: (user.settings?.jobPreferences?.isJunior ?? false)  ? 'Yes' : 'No' ),
                                }else ... {
                                  const TextSpan(text: 'N/A')
                                }

                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salary Range',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                // TextSpan(text: item.capitalize()),
                                if(user.settings?.jobPreferences?.salaryFrom != null) ...{
                                  TextSpan(text: "${user.settings?.jobPreferences?.salaryFrom ?? ''}K" ),
                                  if(user.settings?.jobPreferences?.salaryTo != null) ... {
                                    const TextSpan(text: ' - '),
                                    TextSpan(text: "${user.settings?.jobPreferences?.salaryTo ?? ''}K" ),
                                  }

                                }else ...{
                                  const TextSpan(text: 'N/A')
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role attributes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.attributes ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(String item in (user.settings?.jobPreferences?.attributes ?? <String>[])) ...{
                                  TextSpan(text: item.capitalize()),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.attributes ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.attributes ?? <String>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Size',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.companySize ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(String item in (user.settings?.jobPreferences?.companySize ?? <String>[])) ...{
                                  TextSpan(text: companySizes.where((element) => element.value == item).firstOrNull?.label ?? ''),
                                  const TextSpan(text: ' '),
                                  TextSpan(text: "(${companySizes.where((element) => element.value == item).firstOrNull?.value})" ),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.companySize ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.companySize ?? <String>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),


                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Industries',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.industries ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(String item in (user.settings?.jobPreferences?.industries ?? <String>[])) ...{
                                  TextSpan(text: item.capitalize()),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.industries ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.industries ?? <String>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),


                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Values',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 5,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: (user.settings?.jobPreferences?.companyValues ?? <String>[]).isEmpty ? 'N/A' : '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ,
                              children: <TextSpan>[
                                for(String item in (user.settings?.jobPreferences?.companyValues ?? <String>[])) ...{
                                  TextSpan(text: item.capitalize()),

                                  // if its not the last item append a comma (, )
                                  if((user.settings?.jobPreferences?.companyValues ?? <String>[]).indexOf(item) != (user.settings?.jobPreferences?.companyValues ?? <String>[]).length - 1)...{
                                    const TextSpan(text: ', '),
                                  }
                                }
                                // .forEach((element) {
                                //   TextSpan(text: ''),
                                // })
                                // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
                              ],
                            ),
                          )
                          // Text(
                          //   '${AppStorage.currentUserSession?.settings?.jobPreferences?.types != null ? AppStorage.currentUserSession?.settings?.jobPreferences?.types!.reduce((value, element) => value + ',' + element) : 'N/A'} ',
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: theme.colorScheme.onPrimary,
                          //       height: 1.4),
                          // )
                        ],
                      ),


                    ],
                  ),
                )
              ],
            );
          },
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SetWorkPreferencesPage12Controller extends State<SetWorkPreferencesPage12> {

  @override
  Widget build(BuildContext context) => _SetWorkPreferencesPage12View(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}