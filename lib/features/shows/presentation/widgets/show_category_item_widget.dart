import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shows/data/models/show_category_model.dart';

class ShowCategoryItemWidget extends StatelessWidget {

  final ShowCategoryModel category;
  final bool selected;
  final Function(ShowCategoryModel)? onCategoryTapped;
  const ShowCategoryItemWidget({Key? key, required this.category,
    this.selected = false,
    this.onCategoryTapped
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        onCategoryTapped?.call(category);
      },
      // splashColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
            color: selected ? (theme.brightness == Brightness.dark ? kAppWhite : kAppBlack) : theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(100),

        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Align(
          alignment: Alignment.center,
          child: Text(category.name ?? "", style: TextStyle(color:
          selected ? (theme.brightness == Brightness.dark ? kAppBlack : kAppWhite): theme.colorScheme.onBackground.withOpacity(0.4),
              fontWeight: FontWeight.w600),),
        ),
      ),
    );
  }
}
