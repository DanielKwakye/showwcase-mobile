import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_animated_column_widget.dart';

/// loading indicator with some sort of animation
class CustomPageLoadingIndicatorWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool loading;
  final Widget child;
  final String? message;
  final double opacity;
  final Color? assetColor;
  final int animationDuration;

  const CustomPageLoadingIndicatorWidget({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.loading = false,
    this.message,
    this.opacity = 0.8,
    this.assetColor,
    this.animationDuration = 300

  }) : super(key: key);

  @override
  State<CustomPageLoadingIndicatorWidget> createState() => _CustomPageLoadingIndicatorWidgetState();
}

class _CustomPageLoadingIndicatorWidgetState extends State<CustomPageLoadingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  var _overlayVisible = false;
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: widget.animationDuration));
  late final Animation<double> _animation =
      Tween(begin: 0.0, end: 1.0).animate(_controller);

  @override
  void initState() {
    super.initState();
    onWidgetBindingComplete(onComplete: (){
      _animation.addStatusListener((status) {
        status == AnimationStatus.forward
            ? setState(() => _overlayVisible = true)
            : null;
        status == AnimationStatus.dismissed
            ? setState(() => _overlayVisible = false)
            : null;
      });
      if (widget.loading) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(CustomPageLoadingIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.loading && widget.loading) {
      _controller.forward();
    }

    if (oldWidget.loading && !widget.loading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        /// underlying UI
        Positioned.fill(child: widget.child),

        /// loading indicator semi-opaque background
        if (_overlayVisible) ...{
          FadeTransition(
            opacity: _animation,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Opacity(
                    opacity: widget.opacity,
                    child: ModalBarrier(
                      dismissible: false,
                      color: widget.backgroundColor ?? theme.colorScheme.primary,
                    ),
                  ),
                ),

                /// loading indicator
                Positioned.fill(child: Center(child: _indicator(theme),)),
              ],
            ),
          ),
        },
      ],
    );
  }

  Widget _indicator(ThemeData theme) => CustomAnimatedColumnWidget(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CircularProgressIndicator(
                    backgroundColor: widget.foregroundColor ?? const Color(0xffE580F4), //Colors.transparent,,
                    color: const Color(0xff8280F7), //const Color(0xff8280F7),

                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    kLogoSvg,
                    color: widget.assetColor ?? theme.colorScheme.onBackground,
                    width: 30,
                    height: 30,
                  ),
                )
              ],
            ),
          ),
          if (!widget.message.isNullOrEmpty()) ...{
            Text(widget.message!, style: TextStyle(color: theme.colorScheme.onBackground),)

          }
        ],
      );
}
