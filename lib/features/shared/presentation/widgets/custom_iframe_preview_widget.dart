import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/utils/theme.dart';

class CustomIframePreviewWidget extends StatefulWidget {

  final String url;
  const CustomIframePreviewWidget({
    required this.url,
    Key? key}) : super(key: key);

  @override
  IframPreviewWidgetController createState() => IframPreviewWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _IframPreviewWidgetView extends WidgetView<CustomIframePreviewWidget, IframPreviewWidgetController> {

  const _IframPreviewWidgetView(IframPreviewWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [

          WebViewWidget(
            key: ValueKey(url),
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
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class IframPreviewWidgetController extends State<CustomIframePreviewWidget> {

  late  String html;
  ValueNotifier<bool> loading = ValueNotifier(false);
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) => _IframPreviewWidgetView(this);

  @override
  void initState() {
    super.initState();
    html =  """
  <html><body style='position: absolute; width:100%, height: 100%'><iframe src="${widget.url}"></iframe></body></html>
  """;

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
            _webViewController.runJavaScript("javascript:document.body.style.marginTop=\"25%\"; void 0");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(error.description);
            if(error.errorCode == -1009){
              // context.showSnackBar('The Internet connection appears to be offline.', appearance:  Appearance.error);
              // pop(context);
            }
          },


        ),
      )
      ..loadRequest(Uri.parse(Uri.dataFromString(html, mimeType: 'text/html').toString()));

  }


  @override
  void dispose() {
    super.dispose();
  }

}