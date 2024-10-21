import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_code_highlighter_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_code_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';

import '../../../../core/utils/theme.dart';

class ThreadCodePreviewPage extends StatefulWidget {

  final String code;
  final String? codeLanguage;
  final String tag;
  final ThreadModel thread;
  const ThreadCodePreviewPage({Key? key,
    required this.thread,
    required this.code,
    this.codeLanguage,
    required this.tag,
  }) : super(key: key);


  @override
  ThreadCodePreviewPageController createState() => ThreadCodePreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadCodePreviewPageView extends WidgetView<ThreadCodePreviewPage, ThreadCodePreviewPageController> {

  const _ThreadCodePreviewPageView(ThreadCodePreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: (codeTheme['root'] as TextStyle).backgroundColor,
      // bottomNavigationBar: SafeArea(
      //   child: DecoratedBox(
      //     decoration: BoxDecoration(
      //       color: kAppBlack.withOpacity(0.8),
      //     ),
      //     child: BlocSelector<ThreadPreviewCodeCubit, ThreadPreviewState, ThreadModel>(
      //       selector: (state) {
      //         return state.threadPreviews.firstWhere((element) => element.id == widget.thread.id);
      //       },
      //       builder: (context, reactiveThread) {
      //         return Padding(
      //             padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      //             child: ThreadFeedActionBarWidget(
      //               thread: reactiveThread, iconColor: kAppWhite, separatorColor: kAppFaintBlack,
      //
      //             ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: (codeTheme['root'] as TextStyle).backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Text((widget.codeLanguage ?? defaultCodeLanguage).capitalize(), style:  theme.textTheme.titleSmall?.copyWith(color: kAppWhite),),
            IconButton(onPressed: () => copyTextToClipBoard(context, widget.code), icon: SvgPicture.asset(kCopyIconSvg, colorFilter: ColorFilter.mode(kAppWhite.withOpacity(0.5), BlendMode.srcIn),))
          ],
        ),
        iconTheme: const IconThemeData(color: kAppWhite),
        actions: const [
          CloseButton()
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: CustomBorderWidget(color: Color(0xff2C2C2C),)
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Hero(
              tag: "code-${widget.tag}",
              child: SingleChildScrollView(
                  child: CustomCodeHighlighterWidget(code: widget.code, language: widget.codeLanguage ?? ""))),
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadCodePreviewPageController extends State<ThreadCodePreviewPage> {

  late ThreadPreviewCodeCubit threadPreviewCodeCubit;
  late Brightness originalThemeBrightness;

  @override
  Widget build(BuildContext context) => _ThreadCodePreviewPageView(this);

  @override
  void initState() {
    super.initState();
    threadPreviewCodeCubit = context.read<ThreadPreviewCodeCubit>();
    threadPreviewCodeCubit.setThreadPreview(thread: widget.thread);
    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });

    setSystemUIOverlays(Brightness.dark);
  }


  @override
  void dispose() {
    setSystemUIOverlays(originalThemeBrightness);
    super.dispose();
  }

}
