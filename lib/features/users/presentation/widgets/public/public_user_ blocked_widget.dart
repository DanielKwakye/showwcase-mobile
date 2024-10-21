import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';

class PublicUserBlockedWidget extends StatelessWidget {
  final String username;
  final Function()? onViewProfileTapped;
  const PublicUserBlockedWidget({super.key, required this.username, this.onViewProfileTapped});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You have blocked @$username",style: TextStyle(color: theme(context).colorScheme.onBackground,fontSize: 16,fontWeight: FontWeight.w800),),
          // const SizedBox(height: 10,),
          // Text("Do you want to view this profile? Viewing this profile wont unblock this user.",style: TextStyle(color: theme(context).colorScheme.onBackground,fontSize: 14,fontWeight: FontWeight.w500),),
          // const SizedBox(height: 10,),
          // CustomButtonWidget(text: 'View Profile',onPressed: () {
          //   onViewProfileTapped?.call();
          // },)
        ],
      ),
    );
  }
}
