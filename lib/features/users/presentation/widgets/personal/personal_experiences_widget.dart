import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_experiences_editor_page.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_experience_widget.dart';

class PersonalExperiencesWidget extends StatelessWidget {
  const PersonalExperiencesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, List<UserExperienceModel>?>(
      selector: (userState) {
        final currentUser = AppStorage.currentUserSession!;
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].experiences;
      },
      builder: (context, experiences) {

        if(experiences == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Row(
              children: [
                const Text(
                  'Experiences',
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
                        pushScreen(context, const PersonalExperiencesEditorPage());
                      },
                    ),
                  ),
                ),

              ],
            ),

            if(experiences.isEmpty) ... {
              Container(
                  decoration:  BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            theme.brightness == Brightness.dark
                                ? 'assets/img/empty_positions.png'
                                : 'assets/img/empty_positions_light.png',
                          ),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Share a timeline of your Positions',
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
                            'Add your professional history so others know you’ve put your skills to good use.',
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
                        text: 'Add Positions',
                        onPressed: () {
                          pushScreen(context, const PersonalExperiencesEditorPage());
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  )),
            }else ... {
              const SizedBox(height: 15,),
              // Text("${experiences.length} experience(s) added"),
              SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10,);
              },
                children: experiences.map((exp) {
                    return UserExperienceWidget(experienceModel: exp, onEditTapped: (experience) {
                      pushScreen(context, PersonalExperiencesEditorPage(userExperienceModel: experience,));
                    },);
                }).toList(),
              )

            }

          ],
        );
      },
    );
  }
}
