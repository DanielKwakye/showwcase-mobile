import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:separated_row/separated_row.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_poll_option_model.dart';

class ThreadPollWidget extends StatefulWidget {

  final ThreadModel thread;
  const ThreadPollWidget({Key? key, required this.thread}) : super(key: key);

  @override
  ThreadPollWidgetController createState() => ThreadPollWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadPollWidgetView extends WidgetView<ThreadPollWidget, ThreadPollWidgetController> {

  const _ThreadPollWidgetView(ThreadPollWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          // border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(0),
          color: theme.colorScheme.surface
      ),
      child: (widget.thread.poll?.vote != null) ? _viewVotesWidget(theme) : _castVoteWidget(theme),
    );

  }


  Widget _castVoteWidget(ThemeData theme){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ///poll title
        // _pollTitle(theme),

        /// poll Options
        _pollOptions(theme),

        /// voters
        _voters(theme),

        /// vote action
        _voteAction(theme)
      ],
    );
  }

  Widget _viewVotesWidget(ThemeData theme){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        ///poll title
        // _pollTitle(theme, paddingTop: 15),
        const SizedBox(height: 10,),

        /// poll option with results
        _pollOptionsWithResults(theme),

        /// voters
        _voters(theme),

      ],
    );
  }


  /// Poll components
  Widget _pollTitle(ThemeData theme, { double paddingTop = 0 }){

    if(widget.thread.poll!.question.isNullOrEmpty()){
      return  SizedBox(height: paddingTop,);
    }

    return  GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.thread.poll!.question!,
            textAlign: TextAlign.start,
            style: TextStyle(color: theme.colorScheme.onBackground, height: 10, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _pollOptionsWithResults(ThemeData theme){

    final sortedList = [...widget.thread.poll!.options!];
    sortedList.sort((a, b) => (b.totalVotes ?? 0).compareTo(a.totalVotes ?? 0));
    int? firstPositionPercentageValue;
    if(sortedList.isNotEmpty){
      firstPositionPercentageValue = (sortedList[0].totalVotes ?? 0);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...widget.thread.poll!.options!.map((option) {

          final percentage = ( (option.totalVotes ?? 0) / (widget.thread.poll?.totalVotes ?? 1)) * 100;

          Color color = kAppBlue;
          if(option.totalVotes == firstPositionPercentageValue){
            color = kAppGreen;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 15),
            child: Row(
              children: [
                /// percentage
                SizedBox(width: 50,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('${percentage.toStringAsFixed(0)} %', style: TextStyle(color: theme.colorScheme.onBackground),)),
                ),
                const SizedBox(width: 5,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(option.option!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                  )),
                            ),
                            if(option.id == widget.thread.poll!.vote!.optionId) ...{
                              const SizedBox(width: 10,),
                              const Icon(Icons.check_circle, color: kAppGreen, size: 15,),
                            },
                          ],
                        ),
                        const SizedBox(height: 10,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearPercentIndicator(
                            // width: double.infinity,
                            // key: ValueKey(widget.thread.id),
                            lineHeight: 10.0,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            percent: percentage / 100,
                            backgroundColor: theme.colorScheme.outline,
                            progressColor: color,
                            // animation: true,
                            // animateFromLastPercent: true,
                            // animationDuration: 1000,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );

         }

        )
      ],
    );
  }

  Widget _pollOptions(ThemeData theme){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ...widget.thread.poll!.options!.map((option) =>
            ValueListenableBuilder<ThreadPollOptionModel?>(
              valueListenable: state.selectedPollOption,
              builder: (BuildContext context, ThreadPollOptionModel? value, Widget? child) {
                debugPrint('value: ${value?.option}, option: ${option.option}');
                return GestureDetector(
                  onTap: () {
                    state.selectedPollOption.value = option;
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0, right: 10, top: 0),
                    child: Row(
                      children: [
                        Radio<ThreadPollOptionModel>(
                          value:  option,
                          groupValue: value,
                          visualDensity: const VisualDensity(vertical: -1),
                          activeColor: kAppBlue,
                          onChanged: (ThreadPollOptionModel? value) {
                            state.selectedPollOption.value = option;
                          },
                        ),
                        Expanded(child: Text(option.option!, style: TextStyle(color: theme.colorScheme.onBackground,)),)
                      ],
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  Widget _voters(ThemeData theme){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: () {
          // if poll is set to be anonymous, then no one can see voters -----
          if((widget.thread.poll?.isPublic ?? true) == false){
            return;
          }
          state._showVotersList(widget.thread);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(widget.thread.poll!.voters != null && widget.thread.poll!.voters!.isNotEmpty) ...{
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ...widget.thread.poll!.voters!.take(3).map((user) {
                    final index = widget.thread.poll!.voters!.indexOf(user);
                    // final left = 8.w/2 ;
                    // return SizedBox.shrink();
                    if(index == 0){
                      return CustomUserAvatarWidget(username: user.username!, size: 35,borderSize: 2, networkImage: user.profilePictureKey,);
                    }
                    return Positioned(
                      left: (15.0 * index),
                      child: CustomUserAvatarWidget(username: user.username!, size: 35,borderSize: 2, networkImage: user.profilePictureKey),
                    );

                  }
                  )
                ],),
              SizedBox(width: widget.thread.poll!.voters!.length == 1 ? 15 : (widget.thread.poll!.voters!.length > 2 ? 35 : 22),),
            },
            Expanded(
              child: FittedBox(
                fit:BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: SeparatedRow(
                  separatorBuilder: (BuildContext context, int index) {
                    return const CustomDotWidget(leftPadding: 10, rightPadding: 10,);
                  },
                  children: [
                    Text('Total votes: ${widget.thread.poll?.totalVotes ?? 0}', style: TextStyle(color: theme.colorScheme.onPrimary, ),),
                    Text('Single Option',  style: TextStyle(color: theme.colorScheme.onPrimary),),
                    Text((widget.thread.poll?.isPublic ?? true) ? 'Public' : 'Anonymous',  style: TextStyle(color: theme.colorScheme.onPrimary),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _voteAction(ThemeData theme){
    return ValueListenableBuilder<ThreadPollOptionModel?>(
        valueListenable: state.selectedPollOption,
        builder: (BuildContext context, ThreadPollOptionModel? value, Widget? child) {
          return Padding(
            padding:  const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child:  CustomButtonWidget(
              text: 'Vote',
              expand: true,
              appearance: value != null ? Appearance.primary : Appearance.clean ,
              outlineColor: theme.brightness == Brightness.light ? theme.colorScheme.onPrimary.withOpacity(0.15) : null,
              textColor: value != null ? null : theme.colorScheme.onPrimary,
              onPressed: value != null ?  () => state._castVote(value) : () {},
            ),
          );
        }
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadPollWidgetController extends State<ThreadPollWidget> {

  late ThreadCubit threadCubit;
  ValueNotifier<ThreadPollOptionModel?> selectedPollOption = ValueNotifier(null);

  @override
  Widget build(BuildContext context) => _ThreadPollWidgetView(this);

  @override
  void initState() {
    super.initState();
    threadCubit = context.read<ThreadCubit>();
  }

  bool get voted  {

    final user = AppStorage.currentUserSession!;
    final vote = widget.thread.poll!.vote;

    return vote?.optionId != null &&
        vote?.optionId != 0 &&
        user.id == vote?.userId;
  }

  int get daysLeft {
    final poll = widget.thread.poll!;
    return poll.endDate == null
        ? 0
        : poll.endDate!.difference(poll.createdAt!).inDays;
  }

  int get highestVotes {
    final poll = widget.thread.poll!;
    poll.options!.sort((a, b) => a.totalVotes!.compareTo(b.totalVotes!));
    return poll.options!.first.totalVotes!;
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _castVote(ThreadPollOptionModel option){
    threadCubit.castVote(thread: widget.thread, pollId: widget.thread.poll?.id, pollOptionId: option.id);
  }

  void _showVotersList(ThreadModel thread) {

    context.push(context.generateRoutePath(subLocation: threadPollVotersPage), extra: thread);
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   isDismissible: true,
    //   backgroundColor:  Colors.transparent,
    //   builder: (c) =>  DraggableScrollableSheet(
    //       initialChildSize: 0.9,
    //       // minChildSize: 0.9,
    //       maxChildSize: 0.90,
    //       builder: (_ , controller) {
    //         return ThreadVotersPage(thread: thread);
    //       }
    //   ),
    //   // bounce: true
    //   // useRootNavigator: true,
    //   // expand: false
    // );

    // if(thread.poll!.voters == null || thread.poll!.voters!.isEmpty){
    //   context.showSnackBar("There are no votes", appearance: Appearance.primary);
    //   return;
    // }
    // changeScreenWithConstructor(context, ThreadPollVoters(
    //     thread: thread,
    //     poll: thread.poll!,
    //     voters: thread.poll!.voters!), rootNavigator: true, fullscreenDialog: true);
  }

}
