import 'package:another_flushbar/flushbar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/theme.dart';



/// extensions on any [String]
///
///

extension RegExpExtension on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    var result = <String>[];
    for (var match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0] ?? '');
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}



extension StringExtension on String? {

  List<String> splitWithDelim(RegExp pattern) =>
      pattern.allMatchesWithSep(this!);

  String lastChars({int n = 1}) => this!.substring(this!.length - n);

  String capitalize() {
    assert(this != null);

    return this!
        .split(' ')
        .map(
            (str) {
          if(str.length > 1) {
            return str[0].toUpperCase() + str.substring(1);
          } else {
            return str;
          }

        })
        .join(' ');
  }

  bool isNullOrEmpty() => this == null || this!.isEmpty;


}

/// context extensions

extension ContextExtension on BuildContext {
  /// shows a [SnackBar]
  void showSnackBar(String message, {Color? background, Color? foreground, Appearance? appearance, BuildContext? context, Function()? onTap}) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      try{

        await Flushbar(
          titleColor: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          message: message,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          // forwardAnimationCurve: Curves.elasticOut,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: kAppBlue.withOpacity(0.9),
          isDismissible: true,
          onTap: (flashBar) {
            onTap?.call();
          },
          borderColor: kAppBlue,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.info_outline,
            color: kAppWhite,
          ),
        ).show(context ?? this);

      }catch(e){
        debugPrint("snackBar error: $e");
      }
    });
    // var messenger = ScaffoldMessenger.of(this);
    // messenger
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(
    //     SnackBar(
    //       duration: const Duration(milliseconds: 9000), // delay
    //       content: Text(
    //         message,
    //         style: Theme.of(this).textTheme.bodyText2?.copyWith(
    //           color: appearance == null ? foreground ?? Theme.of(this).colorScheme.primary
    //               : kAppWhite,
    //         ),
    //       ),
    //       backgroundColor: kAppBlue,
    //       behavior: SnackBarBehavior.floating,
    //       action: SnackBarAction(
    //         label: 'Dismiss',
    //         textColor: appearance == null ? (foreground ?? Theme.of(this).colorScheme.primary) : kAppWhite,
    //         onPressed: () => messenger.hideCurrentSnackBar(),
    //       ),
    //     ),
    //   );
  }


  String getFullRoutePath() {
    final fullRoutePath = GoRouter.of(this).location;
    debugPrint("full path: $fullRoutePath");
    return fullRoutePath;
  }

  String getParentRoutePath(){
    final fullPath = getFullRoutePath();
    // remove the first slash
    final relativePath = fullPath.substring(1);
    final routeSections = relativePath.split('/');
    String parentPath = "/";
    if(routeSections.isNotEmpty){
      if(["chat", "notifications", "shows"].contains(routeSections[0])){
        parentPath = "/${routeSections[0]}/";
      }
    }
    debugPrint("parent path: $parentPath");
    return parentPath;
  }

  String generateRoutePath({required subLocation}){
    final parentPath = getParentRoutePath();
    final generatedPath = "$parentPath$subLocation";
    return generatedPath;
  }

}

extension Round on double {
  int get roundUpAbs => isNegative ? floor() : ceil();
}

extension DateTimeExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}


extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}
