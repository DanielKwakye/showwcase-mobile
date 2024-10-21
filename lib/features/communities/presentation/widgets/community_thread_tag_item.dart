import 'package:flutter/material.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';

class CommunityCategoryItemWidget extends StatelessWidget {

  final CommunityThreadTagsModel communityTag;
  final bool selected;
  final Function(CommunityThreadTagsModel)? onCategoryTapped;
  const CommunityCategoryItemWidget({Key? key, required this.communityTag,
    this.selected = false,
    this.onCategoryTapped
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tagColor  = Color(int.parse('0xff${(communityTag.color ?? '#A16D4F').substring(1)}'));

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        onCategoryTapped?.call(communityTag);
      },
      // splashColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
            color: selected  ? tagColor : tagColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          // border: Border.all(color: selected ? tagColor : Colors.transparent, width: 1)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Align(
          alignment: Alignment.center,
          child: Text(communityTag.name ?? "", style: TextStyle(color:
          selected ? Colors.white : tagColor,
              fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
