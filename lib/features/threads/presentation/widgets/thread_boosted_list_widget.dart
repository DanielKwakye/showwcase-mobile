import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadBoostedListWidget extends StatelessWidget {
  final ThreadModel thread;
  const ThreadBoostedListWidget({required this.thread, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container();
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if(thread.boostedBy != null && thread.boostedBy!.isNotEmpty) ...{
          Row(
            children: [
              SvgPicture.asset(kBoostOutlineIconSvg, colorFilter: const ColorFilter.mode(kAppGreen, BlendMode.srcIn),),
              const SizedBox(width: 10,),
              Expanded(child: RichText(
                text: TextSpan(
                  text: '',
                  style:  theme.textTheme.bodyMedium?.copyWith(color: kAppGreen, fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    if(thread.boostedBy!.length == 1)...{
                      TextSpan(text: "${thread.boostedBy![0].displayName}", style: const TextStyle(color: kAppGreen)),
                    }else ... {
                      TextSpan(text: "${thread.boostedBy![0].displayName} and ${thread.boostedBy!.length - 1} ${ (thread.boostedBy!.length - 1) > 1 ?'others' : 'other person'}", style: const TextStyle(color: kAppGreen)),
                    },

                    // ...thread.boostedBy!.map((user) {
                    //   final index = thread.boostedBy!.indexOf(user);
                    //   String concatenation = '';
                    //
                    //   if(index == 1){
                    //     if(thread.boostedBy!.length == 2){
                    //       concatenation = ' and ';
                    //     }else {
                    //       concatenation = ', ';
                    //     }
                    //
                    //   }else if(index > 1) {
                    //     if(index == thread.boostedBy!.length - 1){
                    //       concatenation = ' and ${thread.boostedBy!.length} others ';
                    //     }else{
                    //       concatenation = ', ';
                    //     }
                    //   }
                    //   return TextSpan(text: "$concatenation${user.displayName}", style: const TextStyle(color: kAppGreen));
                    // }),
                    const TextSpan(text: ' boosted this', style: TextStyle(color: kAppGreen)),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(height: 5,)
        },
      ],
    );
  }
}
