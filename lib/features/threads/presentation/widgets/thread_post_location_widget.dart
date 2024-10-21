import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

class ThreadPostLocationWidget extends StatelessWidget {

  final ThreadModel thread;
  const ThreadPostLocationWidget({required this.thread, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {

        context.push(context.generateRoutePath(subLocation: communityPreviewPage), extra: thread.community);
        // changeScreenWithConstructor(context,
        //     CommunitiesFeeds(communityModel: CommunityModel.fromJson(thread.community!.toJson())),
        //   rootNavigator: true
        // );
      },
      child: FittedBox(
        child: RichText(
          text: TextSpan(
            text: 'Posted ',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary,fontSize: 12),
            children:  <TextSpan>[
              TextSpan(text: 'in ', style: TextStyle(color: theme.colorScheme.onPrimary),),
              TextSpan(text: thread.community!.name!, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onBackground,fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
