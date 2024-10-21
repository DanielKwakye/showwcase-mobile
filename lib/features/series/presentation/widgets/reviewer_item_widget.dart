import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_reviewer_model.dart';
import 'package:showwcase_v3/features/series/presentation/widgets/series_user_meta_data_widget.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_profile_icon_widget.dart';

class ReviewerItemWidget extends StatelessWidget {

  final SeriesReviewerModel reviewerModel;
  final SeriesModel seriesModel;

  const ReviewerItemWidget({Key? key,
    required this.reviewerModel, required this.seriesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35 / 2),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(width: 1, color: theme.colorScheme.outline,),

                Expanded(child: SeparatedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10,);
                  },
                  children: [

                    /// header meta data
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: SeriesUserMetaDataWidget(user: reviewerModel.user!, series: seriesModel, showMoreMenu: false, withTime: reviewerModel.createdAt, showUsername: true),
                    ),

                    const SizedBox(height: 10,),

                    /// message here

                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(HtmlUnescape().convert((reviewerModel.message ?? '')), style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize), ),
                    ),

                    const SizedBox(height: 10,),

                    /// stars here
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IgnorePointer(
                        ignoring: true,
                        child: RatingBar.builder(
                          initialRating: (reviewerModel.rating ?? 0).toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemSize: 20,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            // state.rating.value = rating.toInt();
                          },
                        ),
                      ),
                    ),

                  ],
                ))

              ],
            ),
          ),
        ),

        UserProfileIconWidget(
            user: reviewerModel.user!,
            size: 35,
            dimension: '100x'
        ),

      ],
    );

  }


}