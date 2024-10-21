import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_credentials_editor_page.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_credentials_widget.dart';


class PersonalCredentialsWidget extends StatelessWidget {
  const PersonalCredentialsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<UserProfileCubit, UserProfileState, List<UserCertificationModel>?>(
      selector: (userState) {
        final currentUser = AppStorage.currentUserSession!;
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].certifications;
      },
      builder: (context, certifications) {

        if(certifications == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Row(
              children: [
                const Text(
                  'Credentials',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:  Container(
                    width: 35,
                    height: 35,
                    color: theme.colorScheme.outline,
                    child: IconButton(
                      icon: Icon(Icons.add, size: 16, color: theme.colorScheme.onBackground,),
                      onPressed: () {
                        pushScreen(context, const PersonalCredentialsEditorPage());
                      },
                    ),
                  ),
                ),

              ],
            ),
            if(certifications.isEmpty) ... {

              /// Empty Credentials ----

              Container(
                  decoration:  BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            theme.brightness == Brightness.dark ? 'assets/img/empty_credentials.png' : 'assets/img/empty_credentials_light.png',
                          ),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Share a timeline of your Credentials',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                            'Completed a course on Coursera? Graduated from University? Certified by Google? Get those in to show off your hard work.',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: theme.colorScheme.onPrimary),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomButtonWidget(
                        text: 'Add Credentials',
                        onPressed: () {
                          pushScreen(context, const PersonalCredentialsEditorPage());
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  )),

            }else ... {

              const SizedBox(height: 15,),

              /// Filled Credentials ----
              // Text("${certifications.length} credentials added")
              SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10,);
              },
                children: certifications.map((cert) {
                  return UserCredentialWidget(userCertificationModel: cert, onEditTapped: (certification) {
                    pushScreen(context, PersonalCredentialsEditorPage(userCertificationModel: certification,));
                  },);
                }).toList(),
              )

            },

          ],
        );
      },
    );
  }
}
