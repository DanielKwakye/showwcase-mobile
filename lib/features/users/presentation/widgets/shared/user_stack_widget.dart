import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

class UserStackWidget extends StatelessWidget {
  final Function(UserStackModel)? onTap;
  final Function(UserStackModel)? onDeleteTapped;
  final UserStackModel userStackModel;

  const UserStackWidget({Key? key, required this.userStackModel, this.onTap, this.onDeleteTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String? iconUrl = userStackModel.icon;
    if (iconUrl != null) {
      iconUrl = "${ApiConfig.stackIconsUrl}/$iconUrl";
    }
    return GestureDetector(
      onTap: () => onTap?.call(userStackModel),
      behavior: HitTestBehavior.opaque,
      child: Row(
         children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: iconUrl != null
                  ? ClipRRect(
                  borderRadius:
                  BorderRadius.circular(5),
                  child: CustomNetworkImageWidget(
                    imageUrl: iconUrl,
                  )
              ) : Image.asset(kTechStackPlaceHolderIcon),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Text(
              userStackModel.name ?? "",
              style: TextStyle(
                  color:
                  theme.colorScheme.onBackground),
            )),
            if(onDeleteTapped != null) ... {
             GestureDetector(
               behavior: HitTestBehavior.opaque,
               onTap: (){
                 onDeleteTapped?.call(userStackModel);
               },
               child:  const SizedBox(
                 width: 40,
                 height: 40,
                 child: Align(
                   alignment: Alignment.centerRight,
                   child: Icon(Icons.delete_sweep, size: 20,),
                 ),
               ),
             )
           }
         ],
      ),
    );
    // return ListTile(
    //     // onTap: () {
    //     //   state.removeStack(e);
    //     // },
    //     onTap: () => onTap?.call(userStackModel),
    //     visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
    //     // dense: true,
    //     minLeadingWidth: 20,
    //     leading: Container(
    //       width: 20,
    //       height: 20,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //       ),
    //       padding: const EdgeInsets.all(0),
    //       child: iconUrl != null
    //           ? ClipRRect(
    //           borderRadius:
    //           BorderRadius.circular(5),
    //           child: CustomNetworkImageWidget(
    //             imageUrl: iconUrl ?? '',
    //           )
    //       )
    //           : Image.asset(kTechStackPlaceHolderIcon),
    //     ),
    //     title: Text(
    //       userStackModel.name ?? "",
    //       style: TextStyle(
    //           color:
    //           theme.colorScheme.onBackground),
    //     ),
    //     trailing: onDeleteTapped != null ? GestureDetector(
    //       onTap: (){
    //         onDeleteTapped?.call(userStackModel);
    //       },
    //       child:  Container(
    //         color: Colors.red,
    //         width: 40,
    //         height: 40,
    //         child: Align(
    //             alignment: Alignment.centerRight,
    //             child: Icon(Icons.delete_sweep, size: 20,),
    //         ),
    //       ),
    //     ) : null,
    // );
  }
}
