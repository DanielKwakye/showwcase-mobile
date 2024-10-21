import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_preview_state.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_review_stats_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

import '../../../../core/utils/widget_view.dart';

class SeriesRatingStatsWidget extends StatefulWidget {

  final SeriesModel series;
  final SeriesReviewStatsModel stats;
  const SeriesRatingStatsWidget({
    required this.series,
    required this.stats,
    Key? key}) : super(key: key);

  @override
  SeriesRatingWidgetController createState() => SeriesRatingWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SeriesRatingWidgetView extends WidgetView<SeriesRatingStatsWidget, SeriesRatingWidgetController> {

  const _SeriesRatingWidgetView(SeriesRatingWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = (widget.stats.total != null && widget.stats.total! != 0) ? widget.stats.total! : 1;
    return Column(
      children: <Widget>[

        /// Rating section ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text((widget.stats.average ?? 0.0).toDouble().toStringAsFixed(1), style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 50),),
                  IgnorePointer(
                    ignoring: true,
                    child: RatingBar.builder(
                      initialRating: (widget.stats.average ?? 0).toDouble(),
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
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  if(widget.stats.total != null && widget.stats.total! > 0) ... {
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text('Based on ${widget.stats.total} review${widget.stats.total == 1? '' : 's'}', style: TextStyle(color: theme.colorScheme.onBackground),),
                    ),
                  } else ... {
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text('No reviews', style: TextStyle(color: theme.colorScheme.onBackground),),
                    ),
                  }
                ],
              ),
              const SizedBox(width: 20,),
              Expanded(
                  child: Column(

                    children: <Widget>[
                      /// progress bar 5
                      Row(
                        children: [
                          Text('5', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          const SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearPercentIndicator(
                              // width: double.infinity,
                              // key: ValueKey(widget.thread.id),
                              lineHeight: 10.0,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              percent: ((widget.stats.the5 ?? 0) / total ) ,
                              backgroundColor: theme.colorScheme.outline,
                              progressColor: Colors.amber,
                              // animation: true,
                              // animateFromLastPercent: true,
                              // animationDuration: 1000,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      /// progress bar 4
                      Row(
                        children: [
                          Text('4', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          const SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearPercentIndicator(
                              // width: double.infinity,
                              // key: ValueKey(widget.thread.id),
                              lineHeight: 10.0,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              percent: ((widget.stats.the4 ?? 0) / total),
                              backgroundColor: theme.colorScheme.outline,
                              progressColor: Colors.amber,
                              // animation: true,
                              // animateFromLastPercent: true,
                              // animationDuration: 1000,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      /// progress bar 3
                      Row(
                        children: [
                          Text('3', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          const SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearPercentIndicator(
                              // width: double.infinity,
                              // key: ValueKey(widget.thread.id),
                              lineHeight: 10.0,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              percent: ((widget.stats.the3 ?? 0) / total),
                              backgroundColor: theme.colorScheme.outline,
                              progressColor: Colors.amber,
                              // animation: true,
                              // animateFromLastPercent: true,
                              // animationDuration: 1000,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      /// progress bar 2
                      Row(
                        children: [
                          Text('2', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          const SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearPercentIndicator(
                              // width: double.infinity,
                              // key: ValueKey(widget.thread.id),
                              lineHeight: 10.0,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              percent: ((widget.stats.the2 ?? 0) / total),
                              backgroundColor: theme.colorScheme.outline,
                              progressColor: Colors.amber,
                              // animation: true,
                              // animateFromLastPercent: true,
                              // animationDuration: 1000,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      /// progress bar 1
                      Row(
                        children: [
                          Text('1', style: TextStyle(color: theme.colorScheme.onPrimary),),
                          const SizedBox(width: 20,),
                          Expanded(child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearPercentIndicator(
                              // width: double.infinity,
                              // key: ValueKey(widget.thread.id),
                              lineHeight: 10.0,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              percent: ((widget.stats.the1 ?? 0) / total),
                              backgroundColor: theme.colorScheme.outline,
                              progressColor: Colors.amber,
                              // animation: true,
                              // animateFromLastPercent: true,
                              // animationDuration: 1000,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10,),

                    ],
                  )
              )

          ],
        ),

        const SizedBox(height: 10,),

        /// Button to create review
        CustomButtonWidget(text: 'Write a review',
          onPressed: () {
              state._messageController.text = '';
              _rateSeriesUI(context);
          },
          icon: const Icon(Icons.edit, color: kAppWhite,),
          expand: true,
          borderRadius: 4,
        ),

      ],
    );
  }

  void _rateSeriesUI(BuildContext context) async {
    final theme = Theme.of(context);

   await showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.primary,
        context: context,
        builder: (ctx) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(alignment: Alignment.topRight, child: CloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),),
                    const CustomBorderWidget(),
                    const SizedBox(height: 20,),
                    Text('Your rating', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 10,),

                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemSize: 30,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        state.rating.value = rating.toInt();
                      },
                    ),


                    const SizedBox(height: 20,),
                    CustomTextFieldWidget(
                      controller: state._messageController,
                      label: "Leave a review", placeHolder: "",
                      maxLines: null,
                      // onChange: (value) => state._onReportReasonChanged(value!),
                    ),
                    const SizedBox(height: 10,),
                    Builder(builder: (ctx) {
                      return ValueListenableBuilder<int>(valueListenable: state.rating, builder: (ctx, int rating, _) {
                        bool activate = rating >= 1;
                        return BlocBuilder<SeriesPreviewCubit, SeriesPreviewState>(
                        builder: (context, seriesState) {
                          return CustomButtonWidget(text: "Submit review",
                            appearance: Appearance.clean,
                            loading: seriesState.status == SeriesStatus.seriesRatingCreating,
                            textColor: activate ? kAppBlue : null,
                            outlineColor: activate ? kAppBlue : null,
                            backgroundColor: activate ? null : theme.colorScheme.outline,
                            onPressed: activate ? () async{
                            await state._submitReview(ctx);
                            if(state.mounted) {
                              pop(context);
                            }
                          } : null );
                          },
                        );

                      },);
                    }
                    ),
                    const SizedBox(height: kToolbarHeight,),
                  ],
                ),
              ),
            ),
          );
        });

   state.rating.value = 0;

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SeriesRatingWidgetController extends State<SeriesRatingStatsWidget> {

  late TextEditingController _messageController;
  late SeriesPreviewCubit seriesPreviewCubit;
  late StreamSubscription<SeriesPreviewState> seriesPreviewStateStreamSubscription;
  ValueNotifier<int> rating = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    seriesPreviewCubit = context.read<SeriesPreviewCubit>();
    seriesPreviewStateStreamSubscription = seriesPreviewCubit.stream.listen((event) {
      if(event.status == SeriesStatus.seriesRatingCreatingSuccessful) {
        context.showSnackBar("Thanks for leaving a review");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) => _SeriesRatingWidgetView(this);


   Future<void> _submitReview(BuildContext ctx) {
    final message = _messageController.text;
    return seriesPreviewCubit.createReview(series: widget.series, message: message, rating: rating.value);
  }

}