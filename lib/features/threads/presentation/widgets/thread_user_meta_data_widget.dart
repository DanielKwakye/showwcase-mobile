import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_post_location_widget.dart';

class ThreadUserMetaDataWidget extends StatelessWidget {
  
  final ThreadModel thread;
  final bool hideDisplayName;
  final bool hideUserName;
  final String pageName;
  const ThreadUserMetaDataWidget({required this.thread, Key? key, this.hideDisplayName = false, this.hideUserName = false, required this.pageName}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      // splashColor: Colors.transparent,
      onTap: () {
        // changeScreenWithConstructor(context, ProfilePage(user: thread.user!)),
        pushToProfile(context, user: thread.user!);
      } ,
      child: SeparatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        separatorBuilder: (_,__){
          return const SizedBox(height: 0,);
        },
        children: [
          if(!hideDisplayName) ... {
            Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [

                Flexible(
                  fit: FlexFit.loose,
                  flex: 2,
                  child: Text( (thread.isAnonymous ?? false) ? "Community Member" : thread.user?.displayName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,style: TextStyle(
                          color: thread.user?.role == "community_lead" ? kAppGold : theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w800,
                          fontSize: defaultFontSize
                      )),
                ),
                const SizedBox(width: 5,),
                if(!(thread.isAnonymous ?? false)) ... {
                  if(thread.user!.badges != null
                      && thread.user!.badges!.isNotEmpty
                  ) ... {
                    if(thread.user!.badges!.contains('founding_creator')
                        || thread.user!.badges!.contains('community_lead')
                    )
                      const Icon(Icons.verified, color: kAppBlue, size: 15,),
                    const SizedBox(width: 5,),
                  },
                }


              //
              // Text(thread.user!.activity?.emoji != null && !thread.user!.activity!.emoji!.contains('?') ? thread.user!.activity!.emoji! : '🔎', style: TextStyle(color: theme.colorScheme.onBackground,
              //     fontSize: defaultFontSize - 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              // ),// emoji
            ],
          ),
          },
          if(!hideUserName) ... {
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text((thread.isAnonymous ?? false) ? "Community Member" : '@${thread.user!.username!}', style:  TextStyle(color: theme.colorScheme.onPrimary,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis
                ),),
                const SizedBox(width: 5,),
                thread.createdAt != null ? CustomDotWidget(color: theme.colorScheme.onPrimary,) : const SizedBox.shrink(),
                const SizedBox(width: 5,),
                Text(thread.createdAt != null ? getTimeAgo(thread.createdAt!) : '', style: TextStyle(color: theme.colorScheme.onPrimary,
                    fontSize: 13),textAlign: TextAlign.right,),
              ],
            ),
          },
          if (thread.community != null && thread.community!.name != null) ...{
            ThreadPostLocationWidget(thread: thread),
          },
        ],
      ),
    );
  }
}
