import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/theme.dart';
import '../../../../core/utils/widget_view.dart';

class BrowserPage extends StatefulWidget {

  final String url;
  const BrowserPage({
    required this.url,
    Key? key
  }) : super(key: key);

  @override
  BrowserPageController createState() => BrowserPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _BrowserPageView extends WidgetView<BrowserPage, BrowserPageController> {

  const _BrowserPageView(BrowserPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () {
        // this prevents swipe back to pop
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: theme.colorScheme.background,
          title: Text("", style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 14),),
          bottom: const PreferredSize(
              preferredSize:   Size.fromHeight(2),
              child: CustomBorderWidget()
          ),
        ),
        body: Stack(
          children: [

            WebViewWidget(
              key: ValueKey(widget.url),
              controller: state._webViewController,
            ),

            ValueListenableBuilder<bool>(
                valueListenable: state.loading,
                builder: (ctx, val, ch) {
                  return val ? ch!: const SizedBox.shrink();
                },
                child:  const Center(
                  child: CircularProgressIndicator(
                    color: kAppBlue,strokeWidth: 2,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }


}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class BrowserPageController extends State<BrowserPage> {

  ValueNotifier<bool> loading = ValueNotifier(false);

  late String token ;
  // here we checked the url state if it loaded or start Load or abort Load
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) => _BrowserPageView(this);

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setUserAgent("random")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
             loading.value = true;
          },
          onPageFinished: (String url) {
              loading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(error.description);
            if(error.errorCode == -1009){
              context.showSnackBar('The Internet connection appears to be offline.', appearance:  Appearance.error);
              context.pop();
            }
          },

        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }



}