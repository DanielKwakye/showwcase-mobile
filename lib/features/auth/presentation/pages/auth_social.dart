import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class AuthSocial extends StatefulWidget {
  final String loginType ;
  const AuthSocial({Key? key, required this.loginType}) : super(key: key);

  @override
  State<AuthSocial> createState() => _AuthWebSviewState();
}

class _AuthWebSviewState extends State<AuthSocial> {

  ValueNotifier<bool> loading = ValueNotifier(false);
  late String token ;
  late String url;
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


  @override
  void initState() {
    super.initState();

    url = '${ApiConfig.baseUrl}/auth/${widget.loginType}';
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

  void _tokenRetrieved(String tokenUrl){
    List<String> urlSplit = tokenUrl.split('=');
    token = urlSplit[1];
    Navigator.pop(context, token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
              bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(2),
                  child: CustomBorderWidget()
              ),
              actions:  [
                UnconstrainedBox(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: theme.colorScheme.primary,
                    ),
                    child: const CloseButton(),
                  ),
                ),
                const SizedBox(width: 15)

              ],

            ),
          extendBodyBehindAppBar: false,
          body: Stack(
            children: [
              SizedBox(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height,
                child: InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                  URLRequest(url: Uri.parse(url)),
                  initialOptions: options,

                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    loading.value = true;
                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    debugPrint("shouldOverrideUrlLoading called: $url");
                    if(url.toString().startsWith('${ApiConfig.websiteUrl}/')){
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;

                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    loading.value = false;
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    debugPrint("onUpdateVisitedHistory called: $url");
                    if(url.toString().startsWith('${ApiConfig.websiteUrl}/')) {
                        //You can do anything
                        _tokenRetrieved(url.toString());
                        // //Prevent that url works
                        // return NavigationDecision.prevent;
                   }

                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint("$consoleMessage");
                  },
                ),
              ),
              ValueListenableBuilder<bool>(valueListenable: loading, builder: (ctx, loading, _) {
                if(loading) {
                  return Container(
                    color: theme.colorScheme.primary,
                    width: mediaQuery.size.width, height: mediaQuery.size.height,
                    child: Center(
                      child: _progressLoader(theme),
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        );
  }

  Widget _progressLoader(ThemeData theme) {
    return SizedBox(width: 70, height: 70,
      child: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff8280F7)),
              backgroundColor: Color(0xffE580F4), //Colors.transparent,,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              kLogoSvg,
              colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
              width: 30,
              height: 30,
            ),
          )
        ],
      ),
    );
  }

}
