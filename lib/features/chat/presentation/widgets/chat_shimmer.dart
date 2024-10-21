
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Shimmer.fromColors(
            baseColor: theme.colorScheme.outline,
            highlightColor: theme.colorScheme.outline.withOpacity(0.3),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.onBackground,
                shape: BoxShape.circle,
              ),
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: theme.colorScheme.outline,
            highlightColor: theme.colorScheme.outline.withOpacity(0.3),
            child: Container(
              height: 20,
              width: 60,
              margin: const EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                  color: theme.colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          subtitle: Shimmer.fromColors(
            baseColor: theme.colorScheme.outline,
            highlightColor: theme.colorScheme.outline.withOpacity(0.3),
            child: Container(
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                  color: theme.colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 5,
        );
      },
    );
  }
}
