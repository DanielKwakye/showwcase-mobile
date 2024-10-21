import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class CustomButtonWidget extends StatelessWidget {

  final String text;
  final Function()? onPressed;
  final Appearance? appearance;
  final bool expand;
  final Widget? icon;
  final bool loading;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? outlineColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool disabled;
  final FontWeight? fontWeight;
  // final

  const CustomButtonWidget({
    required this.text,
    Key? key, this.onPressed,
    this.appearance = Appearance.primary,
    this.expand = false,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.textColor,
    this.backgroundColor,
    this.outlineColor,
    this.borderRadius,
    this.padding,
    this.fontWeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return SizedBox(
        width: expand ? width(context) : null,
        child: ElevatedButton.icon(
          icon: loading ? const SizedBox.shrink() : (icon ?? const SizedBox.shrink()),
          onPressed: loading ? null : (disabled ? null : (onPressed ?? (){})),
          label: Padding( padding: EdgeInsets.symmetric(horizontal: 0, vertical: expand ? 14 : 0),
          child: loading ?
              // Loading State
          // CupertinoActivityIndicator(color: appearance == Appearance.clean ? theme.colorScheme.onBackground : kAppWhite,)
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppWhite, strokeWidth: 2,),)
              // Normal state
          : Text(text,
            textAlign: TextAlign.center,

            style: TextStyle(color:  textColor ?? ((onPressed == null || disabled) ? theme.colorScheme.onPrimary :
            appearance == Appearance.clean ? theme.colorScheme.onBackground :
            appearance == Appearance.secondary ? (theme.brightness == Brightness.light ? kAppBlack : kAppWhite) : kAppWhite
            ), fontWeight: fontWeight ?? FontWeight.w700),
          ),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) => 0),
          minimumSize:  MaterialStateProperty.resolveWith<Size?>((states) => padding != null ? Size.zero : null), // Set this
          padding: MaterialStateProperty.resolveWith<EdgeInsets?>((states) => padding), // and this
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( borderRadius != null ? borderRadius! : expand? 8 : 5),
                  side: BorderSide(color: outlineColor ?? theme.colorScheme.outline, width: outlineColor != null ? 1 : 0)
              )
          ),
          backgroundColor: backgroundColor != null ?
              MaterialStateProperty.resolveWith<Color>((states) => backgroundColor!)
              : MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                // appearance when button is pressed
                switch (appearance){
                  case Appearance.primary:
                    return kAppFaintBlack;
                  case Appearance.secondary:
                    return kAppBlue;
                  case Appearance.clean:
                    return kAppBlue;
                  default:
                    return kAppFaintBlack;
                }

              }

              // background color

              if(onPressed == null || disabled){
                return theme.colorScheme.outline;
              }

              switch (appearance){
                case Appearance.primary:
                  return kAppBlue;
                case Appearance.secondary:
                  return theme.brightness == Brightness.dark ? kAppFaintBlack : kAppLightGray;
                case Appearance.error:
                  return kAppRed;
                case Appearance.success:
                  return kAppGreen;
                case Appearance.clean:
                  return Colors.transparent;
                default:
                  return kAppBlue;
              }

            },
            ),
          ),
        ),
      );
  }
}
