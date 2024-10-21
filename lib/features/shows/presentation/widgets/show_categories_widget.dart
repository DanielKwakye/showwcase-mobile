import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_feeds_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_state.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_category_item_widget.dart';

class ShowCategoriesWidget extends StatelessWidget {
  const ShowCategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border(
              bottom:
              BorderSide(color: theme.colorScheme.outline))),
      child: BlocBuilder<ShowFeedsCubit, ShowsState>(
        buildWhen: (_, next) {
          return next.status == ShowsStatus.fetchShowCategoriesSuccessful
              || next.status == ShowsStatus.selectShowFeedCategoryCompleted;
        },
        builder: (context, showsState) {

          /// Shimmer shown when loading categories ------
          if(showsState.status == ShowsStatus.fetchShowCategoriesInProgress) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<int>.filled(9, 0, growable: false)
                    .map((e) => Shimmer.fromColors(
                  baseColor: theme.colorScheme.outline,
                  highlightColor: theme.colorScheme.outline.withOpacity(0.3),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                )).toList(),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                children: showsState.showCategories.map((category) => ShowCategoryItemWidget(
                  category: category, selected: showsState.selectedShowCategory == category,
                  onCategoryTapped: (category) {
                    context.read<ShowFeedsCubit>().selectShowFeedCategory(category);
                  },
                )).toList(),
              ),
            ),
          );
        },
      ),
    );
    // return ClipRRect(
    //   // child: BackdropFilter(
    //   //   filter: ImageFilter.blur(
    //   //     sigmaX: 5.0,
    //   //     sigmaY: 5.0,
    //   //   ),
    //   //   child: ,
    //   // ),
    // );
  }
}
