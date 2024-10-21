import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_shimmer.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/screener_item.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';


class RejectedScreener extends StatefulWidget {
  const RejectedScreener({Key? key}) : super(key: key);

  @override
  State<RejectedScreener> createState() => _RejectedScreenerState();
}

class _RejectedScreenerState extends State<RejectedScreener> with AutomaticKeepAliveClientMixin<RejectedScreener>{
  late ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.fetchRejectedConnections(replaceFirstPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: _chatCubit,
      buildWhen: (previousState, currentState) {
        return currentState.status ==
            ChatStatus.fetchRejectedConnectionsInProgress ||
            currentState.status == ChatStatus.fetchRejectedConnectionsSuccess ||
            currentState.status == ChatStatus.fetchRejectedConnectionsFailed ||
            currentState.status == ChatStatus.acceptPendingConnectionSuccessful ||
            currentState.status == ChatStatus.rejectPendingConnectionSuccessful;
      },
      builder: (context, state) {
        if (state.status == ChatStatus.fetchRejectedConnectionsInProgress) {
          return const ChatShimmer();
        }
        if (state.status == ChatStatus.fetchRejectedConnectionsSuccess ||
            state.status == ChatStatus.acceptPendingConnectionSuccessful
            || state.status == ChatStatus.rejectPendingConnectionSuccessful) {
          return state.rejectedConnections.isNotEmpty
              ? ListView.separated(
            itemCount: state.rejectedConnections.length,
              padding: const EdgeInsets.all(15),
            itemBuilder: (BuildContext context, int index) {
              return ScreenerItem(incomingConnectionModel: state.rejectedConnections[index], showRejectButton: false,);
            },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 20,
                );
              }
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Messages to Display',
                style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'All your rejected messages will be shown here',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }
        if (state.status == ChatStatus.fetchRejectedConnectionsFailed) {
          return CustomNoConnectionWidget(
            title: state.message,
            showRetryButton: true,
            onRetry: () {
              _chatCubit.fetchRejectedConnections(replaceFirstPage: true);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
