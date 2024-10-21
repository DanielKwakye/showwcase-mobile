import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_browser_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/shows_action_bar_widget.dart';

import '../../../shared/presentation/widgets/custom_border_widget.dart';

class ShowPreviewBrowserPage extends StatefulWidget {

  final String url;
  final ShowModel show;
  const ShowPreviewBrowserPage({Key? key, required this.url, required this.show}) : super(key: key);

  @override
  ShowBrowserPageController createState() => ShowBrowserPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowBrowserPageView extends WidgetView<ShowPreviewBrowserPage, ShowBrowserPageController> {

  const _ShowBrowserPageView(ShowBrowserPageController state) : super(state);

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
                networkImage: widget.show.user?.profilePictureKey, username: widget.show.user?.username,
                borderSize: 0,
                borderColor: kAppBlack,
                size: 30,
              ),
              const SizedBox(width: 10,),
              Text(widget.show.user?.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium,)

            ],
          ),
          centerTitle: false,

        ),
        bottomNavigationBar: BlocSelector<ShowPreviewBrowserCubit, ShowPreviewState, ShowModel>(
          selector: (state){
            return state.showPreviews.firstWhere((element) => element.id == widget.show.id);
          },
          builder: (context, reactiveShow) {
            return SafeArea(
              bottom: true,
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if(widget.show.title != null) ... {
                      Text(widget.show.title!, style: theme.textTheme.titleMedium?.copyWith(fontSize: defaultFontSize, fontWeight: FontWeight.w700),),
                      const SizedBox(height: 10,),
                    },

                    // ShowsActionBarWidget(showModel: reactiveShow),
                  ],
                ),
              ),
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

class ShowBrowserPageController extends State<ShowPreviewBrowserPage> {


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

  late ShowPreviewBrowserCubit showPreviewBrowserCubit;

  @override
  Widget build(BuildContext context) => _ShowBrowserPageView(this);

  @override
  void initState() {
    super.initState();

    showPreviewBrowserCubit = context.read<ShowPreviewBrowserCubit>();
    showPreviewBrowserCubit.setShowPreview(show: widget.show);

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