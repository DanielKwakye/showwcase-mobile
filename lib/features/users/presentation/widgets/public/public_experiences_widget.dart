import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_experience_widget.dart';

class PublicExperiencesWidget extends StatelessWidget {

  final UserModel userModel;
  const PublicExperiencesWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, List<UserExperienceModel>?>(
      selector: (userState) {
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == userModel.username);
        if(index < 0){
          return null;
        }
        final experiences = userProfiles[index].experiences;
        return experiences;
      },
      builder: (context, experiences) {

        if(experiences == null || experiences.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experiences',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
              const SizedBox(height: 15,),
              // Text("${experiences.length} experience(s) added"),
              SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10,);
              },
                children: experiences.map((exp) {
                    return UserExperienceWidget(experienceModel: exp,
                    showEditButton: false,);
                }).toList(),
              ),
            const SizedBox(
              height: 20,
            ),
            const CustomBorderWidget(top: 0, bottom: 0,)



          ],
        );
      },
    );
  }
}
