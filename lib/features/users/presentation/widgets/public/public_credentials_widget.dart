import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_credentials_widget.dart';


class PublicCredentialsWidget extends StatelessWidget {

  final UserModel userModel;
  const PublicCredentialsWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<UserProfileCubit, UserProfileState, List<UserCertificationModel>?>(
      selector: (userState) {
        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == userModel.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].certifications;
      },
      builder: (context, certifications) {

        if(certifications == null || certifications.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credentials',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

              const SizedBox(height: 15,),

              /// Filled Credentials ----
              SeparatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10,);
              },
                children: certifications.map((cert) {
                  return UserCredentialWidget(userCertificationModel: cert,
                    showEditButton: false
                  );
                }).toList(),
              )



          ],
        );
      },
    );
  }
}
