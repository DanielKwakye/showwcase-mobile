import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_browser_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_browser_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_preview_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';
import 'package:showwcase_v3/features/threads/presentation/widgets/thread_feed_action_bar_widget.dart';

import '../../../shared/presentation/widgets/custom_border_widget.dart';

class ThreadPreviewBrowserPage extends StatefulWidget {

  final String url;
  final ShowModel showModel;
  const ThreadPreviewBrowserPage({Key? key, required this.url, required this.showModel}) : super(key: key);

  @override
  ThreadBrowserPageController createState() => ThreadBrowserPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ThreadBrowserPageView extends WidgetView<ThreadPreviewBrowserPage, ThreadBrowserPageController> {

  const _ThreadBrowserPageView(ThreadBrowserPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () {
        // this prevents swipe back to pop
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: CustomBorderWidget()
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomUserAvatarWidget(
                networkImage: widget.showModel.user?.profilePictureKey, username: widget.showModel.user?.username,
                borderSize: 0,
                borderColor: kAppBlack,
                size: 30,
              ),
              const SizedBox(width: 10,),
              Text(widget.showModel.user?.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium,)

            ],
          ),
          centerTitle: false,

        ),
        bottomNavigationBar: BlocSelector<ThreadPreviewBrowserCubit, ThreadPreviewState, ThreadModel>(
          selector: (state) {
            return state.threadPreviews.firstWhere((element) => element.id == widget.showModel.id);
          },
          builder: (context, reactiveThread) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
              child: ThreadFeedActionBarWidget(thread: reactiveThread),
            );
          },
        ),
        body: Stack(
          children: [
            SizedBox(
              width: mediaQuery.size.width,
              height: mediaQuery.size.height,
              child: InAppWebView(
                key: state.webViewKey,
                initialUrlRequest:
                URLRequest(url: Uri.parse(widget.url)),
                initialOptions: state.options,

                pullToRefreshController: state.pullToRefreshController,
                onWebViewCreated: (controller) {
                  state.webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  state.loading.value = true;
                },
                androidOnPermissionRequest: (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onLoadStop: (controller, url) async {
                  state.pullToRefreshController.endRefreshing();
                  state.loading.value = false;
                },
                onLoadError: (controller, url, code, message) {
                  state.pullToRefreshController.endRefreshing();
                },
                onConsoleMessage: (controller, consoleMessage) {
                  debugPrint("$consoleMessage");
                },
              ),
            ),
            ValueListenableBuilder<bool>(valueListenable: state.loading, builder: (ctx, loading, _) {
              if(loading) {
                return const Center(
                  child: CustomAdaptiveCircularIndicator(),
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ThreadBrowserPageController extends State<ThreadPreviewBrowserPage> {


  ValueNotifier<bool> loading = ValueNotifier(false);
  // here we checked the url state if it loaded or start Load or abort Load
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  late PullToRefreshController pullToRefreshController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: 'random',
        javaScriptEnabled: true,
        useOnLoadResource: true,
        cacheEnabled: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late ShowPreviewBrowserCubit showPreviewCubit;

  @override
  Widget build(BuildContext context) => _ThreadBrowserPageView(this);

  @override
  void initState() {
    super.initState();

    showPreviewCubit = context.read<ShowPreviewBrowserCubit>();
    // showPreviewCubit.setShowPreview(thread: widget.showModel);

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );


  }


  @override
  void dispose() {
    super.dispose();
  }

}