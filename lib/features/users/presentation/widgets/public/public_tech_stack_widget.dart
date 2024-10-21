import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';

class PublicTechStackWidget extends StatelessWidget {

  final UserModel userModel;
  const PublicTechStackWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, List<UserTechStackModel>?>(
      selector: (userState) {

        final userProfiles = userState.userProfiles;
        final index = userProfiles.indexWhere((element) => element.username == userModel.username);
        if(index < 0){
          return null;
        }
        return userProfiles[index].techStacks;
      },
      builder: (context, techStacks) {

        if(techStacks == null || techStacks.isEmpty) {
          return const SizedBox.shrink();
        }

        final categorisedTechStacks = context.read<UserProfileCubit>().getCategorisedTechStacks(techStacks);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              const Text(
                'Tech Stack',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
               const SizedBox(height: 15,),

               ListView.separated(
                 separatorBuilder: (_, index){
                   return const SizedBox(height: 20,);
                 },
                 padding: EdgeInsets.zero,
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: categorisedTechStacks.length,
                 itemBuilder: (context, index) {
                   String category = categorisedTechStacks.keys.elementAt(index);
                   List<UserTechStackModel?> techStackList = categorisedTechStacks.values.elementAt(index);

                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       // category title-----------------------
                       SeparatedRow(
                         mainAxisSize: MainAxisSize.min,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 5,);
                          },
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.w600),
                            ),
                            if(category.toLowerCase().contains("featured")) ... {
                              const Icon(Icons.star, size: 15, color: kAppBlue,)
                            }
                          ],
                       ),

                       const SizedBox(
                         height: 15,
                       ),

                       // Category list here -------------------------------------
                       ListView.separated(
                         separatorBuilder: (_,__) {
                           return const SizedBox(height: 15,);
                         },
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         padding: EdgeInsets.zero,
                         itemCount: techStackList.length,
                         itemBuilder: (context, index) {
                           UserTechStackModel? techStackItem = techStackList[index];
                           if(techStackItem == null){
                             return const SizedBox.shrink();
                           }
                           return Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   ClipRRect(
                                       borderRadius:BorderRadius.circular(5),
                                       child: SizedBox(
                                         width: 20,
                                         height: 20,
                                         child: techStackItem.stack?.icon != null ? CustomNetworkImageWidget(
                                           imageUrl: '${ApiConfig.stackIconsUrl}/${techStackItem.stack?.icon}',
                                         ) : Image.asset(kTechStackPlaceHolderIcon),
                                       )
                                   ),
                                   const SizedBox(width: 19,),
                                   Text(
                                     techStackItem.stack?.name ?? "",
                                     style: TextStyle(
                                         color: theme.colorScheme.onBackground,
                                         fontSize: 13),
                                   ),
                                 ],
                               ),
                               if(techStackItem.experience != null) ... {
                                 Text(context.read<UserProfileCubit>().getTechExperienceNameFromValue(techStackItem),
                                   style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w600),
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                 )
                               }


                             ],
                           );
                         },
                       ),

                     ],
                   );
                 },
               ),
             const SizedBox(
               height: 40,
             ),
             const CustomBorderWidget(top: 0, bottom: 0,)

           ],
        );
      },
    );
  }
}
