import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_cubit.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_enum.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_state.dart';

class TwitterLinkPreviewWidget extends StatefulWidget {

  final String tweetId;
  const TwitterLinkPreviewWidget({
    required this.tweetId,
    Key? key}) : super(key: key);

  @override
  State<TwitterLinkPreviewWidget> createState() => _TwitterLinkPreviewWidgetState();

}

class _TwitterLinkPreviewWidgetState extends State<TwitterLinkPreviewWidget> {

  late SharedCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SharedCubit>();
    cubit.fetchTwitterBlock(tweetId: widget.tweetId);
  }

  @override
  Widget build(BuildContext context) {
    // return const AspectRatio(
    //   aspectRatio: 16 / 9,
    //   child: Center(
    //     child: CircularProgressIndicator(),
    //   )
    // );
    return BlocBuilder<SharedCubit, SharedState>(
      bloc: cubit,
      builder: (context, state) {
        if(state.status == SharedStatus.fetchingTwitterBlockInProgress){
          return const AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: CircularProgressIndicator(),
              ),
          );
        }

        if(state.status == SharedStatus.fetchingTwitterBlockSuccessful){
          // return SocialEmbed(
          //     socialMediaObj: TwitterEmbedData(
          //         embedHtml: state.twitter?.html ?? "",
          //     ),
          // );
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
