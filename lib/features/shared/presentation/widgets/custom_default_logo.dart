import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gradient_border_widget.dart';

class CustomDefaultLogoWidget extends StatelessWidget {

  final bool setGradientBorder;
  final double size;

  const CustomDefaultLogoWidget({this.size = 70, this.setGradientBorder = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _icon = SvgPicture.asset(kLogoSvg, color: Theme.of(context).colorScheme.onBackground,);

    return SizedBox(
      width: size,
      height: size,
      child: setGradientBorder ?
      CustomGradientBorderWidget(
          padding: 20,
          gradient: kAppLinearGradient, child: _icon ) : _icon,
    );
  }


}
