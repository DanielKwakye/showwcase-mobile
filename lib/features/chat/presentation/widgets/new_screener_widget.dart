import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_shimmer.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/screener_item.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';


class NewScreener extends StatefulWidget {
  const NewScreener({Key? key}) : super(key: key);

  @override
  State<NewScreener> createState() => _NewScreenerState();
}

class _NewScreenerState extends State<NewScreener>
    with AutomaticKeepAliveClientMixin<NewScreener> {
  late ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.fetchPendingConnections(replaceFirstPage: true);
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
                ChatStatus.fetchPendingConnectionsInProgress ||
            currentState.status == ChatStatus.fetchPendingConnectionsSuccess ||
            currentState.status == ChatStatus.fetchPendingConnectionsFailed ||
            currentState.status == ChatStatus.acceptPendingConnectionSuccessful ||
            currentState.status == ChatStatus.rejectPendingConnectionSuccessful;
      },
      builder: (context, state) {
        if (state.status == ChatStatus.fetchPendingConnectionsInProgress) {
          return const ChatShimmer();
        }
        if (state.status == ChatStatus.fetchPendingConnectionsSuccess ||
            state.status == ChatStatus.acceptPendingConnectionSuccessful
            || state.status == ChatStatus.rejectPendingConnectionSuccessful ) {
          return state.pendingConnections.isNotEmpty
              ? ListView.separated(
                  itemCount: state.pendingConnections.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (BuildContext context, int index) {
                    return ScreenerItem(
                      incomingConnectionModel: state.pendingConnections[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
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
                        'Once someone messages you to start a new conversation, you’ll see it here',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
        }
        if (state.status == ChatStatus.fetchPendingConnectionsFailed) {
          return CustomNoConnectionWidget(
            title: state.message,
            showRetryButton: true,
            onRetry: () {
              _chatCubit.fetchPendingConnections(replaceFirstPage: true);
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
