import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/custom_fade_in_page_route.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/file_manager/presentation/pages/gallery_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


bool isContainingAnyLink(String? text) {
  RegExp exp = RegExp(r"(?:(?:(?:ftp|http)[s]*:\/\/|www\.)[^\.]+\.[^ \n]+)");
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

bool isPhoneNumber(String? text) {
  RegExp exp = RegExp(r'[+0]\d+[\d-]+\d');
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

bool isEmail(String? text) {
  RegExp exp = RegExp(r'[^@\s]+@([^@\s]+\.)+[^@\W]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text ?? '');
  return matches.isNotEmpty ? true : false;
}

Color getRandomColor() {
  var list = codeViewTheme.values.toList();

  // generates a new Random object
  final random = Random();

  // generate a random index based on the list length
  // and use it to retrieve the element
  final style = list[random.nextInt(list.length)];
  return style.color ?? kAppBlue;
}

//here goes the function
String? parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String? parsedString = parse(document.body?.text).documentElement?.text;

  return parsedString;
}

Map<String, dynamic>? getFileType({required String path}) {
  String? mimeStr = lookupMimeType(path);
  var fileType = mimeStr?.split('/');
  debugPrint('file type $fileType');
  if (fileType == null) return null;
  if (fileType.isEmpty) return null;
  if (fileType.length != 2) return null;
  final type = fileType.first;
  if (type == "video") {
    return {"type": RequestType.video, "extension": fileType[1]};
  }

  if (type == "image") {
    return {"type": RequestType.image, "extension": fileType[1]};
  }

  return null;
}

/// Use this method to execute code that requires context in init state
onWidgetBindingComplete(
    {required Function() onComplete, int milliseconds = 1000}) {
  WidgetsBinding.instance.addPostFrameCallback(
          (_) => Timer(Duration(milliseconds: milliseconds), onComplete));
}

/// convert figures in 1000s into k
String toCompactFigure(double numberToFormat) {
  final formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ).format(numberToFormat);

  return formattedNumber;
  // print('Formatted Number is: $_formattedNumber');
}

/// Get Initials
String getInitials(String? words) {
  if (words.isNullOrEmpty()) {
    return "";
  }
  return words!.isNotEmpty
      ? words.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';
}

/// Extract urls out of text
List<String> getLinksFromText({required String text}) {
  RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);

  final List<String> links =
  matches.map((match) => text.substring(match.start, match.end)).toList();
  return links;
}

/// Get formatted date
String getTimeAgo(DateTime date) {
  final readableTime = timeago.format(date);
  return readableTime;
}

String getFormattedDateWithIntl(DateTime date, {String format = 'MMM yyyy'}) {
  var formatBuild = DateFormat(format);
  var dateString = formatBuild.format(date);
  return dateString;
}

void copyTextToClipBoard(BuildContext context, String text, {String? toastMessage}) {
  Clipboard.setData(ClipboardData(text: text));
  context.showSnackBar(toastMessage ?? 'Copied!', appearance: Appearance.primary);
}

Future<Object?> pushToProfile(BuildContext context, {required UserModel user}) async {
  if(user.id == anonymousPostUserId) {
    return null;
  }
  final currentUser = AppStorage.currentUserSession;
  return context.push(context.generateRoutePath(subLocation:  user.username == currentUser?.username ? personalProfilePage : publicProfilePage),
      extra: user
  );
}

Future<Object?> pushScreen(
    BuildContext context, Widget classObject,
    {bool replaceAll = false,
      fullscreenDialog = false,
      rootNavigator = false,
      bool fadeIn = false,
      dynamic args = const {}}) {
  if (replaceAll) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .pushAndRemoveUntil(
      fadeIn ?
      CustomFadeInPageRoute(classObject, color: kAppBlack)
      : MaterialPageRoute(
          builder: (context) => classObject,
          settings: RouteSettings(arguments: args)),
          (Route<dynamic> route) => false,
    );
  } else {
    return Navigator.of(context, rootNavigator: rootNavigator).push(
        fadeIn ?
        CustomFadeInPageRoute(classObject, color: kAppBlack)
        : MaterialPageRoute(
            builder: (context) => classObject,
            fullscreenDialog: fullscreenDialog,
            settings: RouteSettings(arguments: args)));
  }
}

String getYoutubeThumbnail({
  required String videoId,
  String quality = ThumbnailQuality.standard,
  bool webp = true,
}) =>
    webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

// Color getRandomColor() {
//   var list = codeViewTheme.values.toList();
//
//   // generates a new Random object
//   final _random = Random();
//
//   // generate a random index based on the list length
//   // and use it to retrieve the element
//   final style = list[_random.nextInt(list.length)];
//   return style.color ?? kAppBlue;
// }

void showAppDatePicker(BuildContext context,
    {String title = "Select date",
      DateTime? firstDate,
      DateTime? lastDate,
      void Function(DateTime)? onDateSelected}) async {
  final theme = Theme.of(context);
  firstDate ??= DateTime(1900, 01);
  lastDate ??= DateTime(9091);
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (ctx, ch) {
      return Theme(
        data: theme.brightness == Brightness.dark
            ? ThemeData.dark()
            : ThemeData.light(),
        child: ch!,
      );
    },
  );

  if (picked != null && onDateSelected != null) {
    onDateSelected(picked);
  }
}

// Handy method to show bottom sheets with ease
Future<void> showCustomBottomSheet(BuildContext context, {required Widget child, bool? showDragHandle}){
  final theme = Theme.of(context);
  return showModalBottomSheet<void>(
    enableDrag: true,
    context: context,
    showDragHandle: showDragHandle,
    backgroundColor: theme.colorScheme.primary,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return Padding(padding: EdgeInsets.only(
        bottom:  MediaQuery.of(ctx).viewInsets.bottom),
        child: child,
      );
    },
  );
}

showEmojis(BuildContext ctx, {Function(Emoji)? onEmojiSelected}) {

  final theme = Theme.of(ctx);
  final child = SizedBox(
    height: MediaQuery.of(ctx).size.height / 2,
    child: EmojiPicker(
      config: Config(
        columns: 7,
        // Issue: https://github.com/flutter/flutter/issues/28894
        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.SMILEYS,
        bgColor: theme.colorScheme.background,
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        recentTabBehavior: RecentTabBehavior.RECENT,
        recentsLimit: 28,
        replaceEmojiOnLimitExceed: false,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        loadingIndicator: const SizedBox.shrink(),
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
        checkPlatformCompatibility: true,
      ),
      onEmojiSelected: (Category? category, Emoji emoji){
        onEmojiSelected?.call(emoji);
        pop(ctx);
      },
    ),
  );
  showCustomBottomSheet(ctx, child: child);
}

void showConfirmDialog(BuildContext context,
    {required VoidCallback onConfirmTapped,
      VoidCallback? onCancelTapped,
      required String title,
      bool showCancelButton = true,
      bool isDismissible = true,
      bool showCloseButton = true,
      String? subtitle,
      Map<String, dynamic> data = const {},
      String? confirmAction,
      String? cancelAction}) {
  showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: theme(context).colorScheme.primary,
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showCloseButton) ...{
                    Align(
                      alignment: Alignment.topRight,
                      child: CloseButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const CustomBorderWidget(),
                  },
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: theme(context).textTheme.titleLarge,
                  ),
                  if (subtitle != null) ...{
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      subtitle,
                      style:
                      TextStyle(color: theme(context).colorScheme.onPrimary),
                    ),
                  },
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomButtonWidget(
                            text: confirmAction ?? "Confirm",
                            expand: true,
                            appearance: Appearance.error,
                            onPressed: () {
                              Navigator.of(context).pop();

                              onConfirmTapped();

                              // switch(action) {
                              //   case DialogAction.deleteThread:
                              //     state._deleteThread(data);
                              //     break;
                              //   case DialogAction.logout:
                              //     state._logout();
                              //     break;
                              //   default:
                              //     break;
                              // }
                            },
                          )),
                      if (showCancelButton) ...[
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: CustomButtonWidget(
                              text: cancelAction ?? "Cancel",
                              expand: true,
                              appearance: Appearance.secondary,
                              onPressed: () {
                                Navigator.of(context).pop();
                                onCancelTapped?.call();
                              },
                            )),
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}




pop<T extends Object?>(BuildContext context, [T? result]) {
  Navigator.of(context).pop(result);
}

RegExpMatch? hashTagging(String word) {
  final exp = RegExp(r"(^|\s)#([a-z\d-]+)", caseSensitive: false);
  final match = exp.firstMatch(word);
  return match;
}

RegExpMatch? cashTagging(String word) {
  final exp = RegExp(r"(^|\s)\$([a-z\d-]+)", caseSensitive: false);
  final match = exp.firstMatch(word);
  return match;
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}


// Future<String?> initUniLinks() async {
//   // Platform messages may fail, so we use a try/catch PlatformException.
//   try {
//     final initialLink = await getInitialLink();
//     return initialLink;
//     // Parse the link and warn the user, if it is not correct,
//     // but keep in mind it could be `null`.
//   } on PlatformException {
//     // Handle exception by warning the user their action did not succeed
//     // return?
//     debugPrint("deepLink Error:");
//     return null;
//   }
// }

bool checkIfLinkIsYouTubeLink(String url, {bool trimWhitespaces = true}) {
  if (url.isEmpty) return false;
  String _url;
  if (!url.contains('http') && (url.length == 11)) return false;
  if (trimWhitespaces) {
    _url = url.trim();
  } else {
    _url = url;
  }

  for (final exp in [
    RegExp(
        r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
    RegExp(
        r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
    RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
  ]) {
    final match = exp.firstMatch(_url);
    if (match != null && match.groupCount >= 1) return true;
  }

  return false;
}

/// get profile image
String getProfileImage(String? networkImageParam) {
  if (networkImageParam == null) {
    return '';
  }
  String mainImageUrl = '';
  String imageUrl = '';

  imageUrl = networkImageParam.startsWith("http") ? networkImageParam : "${ApiConfig.profileUrl}/$networkImageParam";
  List<String> stringSplit = imageUrl.split('?');
  if (stringSplit.length == 1) {
    mainImageUrl = stringSplit[0];
  } else {
    mainImageUrl = stringSplit[1].substring(2);
    mainImageUrl = "${ApiConfig.profileUrl}/$mainImageUrl";
    List<String> imageParams = mainImageUrl.split('&');
    mainImageUrl = imageParams[0];
  }

  return mainImageUrl;
}

/// get project image
String getProjectImage(String? networkImageParam) {
  if (networkImageParam == null) {
    return '';
  }
  String mainImageUrl = '';
  String imageUrl = '';

  imageUrl = networkImageParam.startsWith("http") ? networkImageParam : "${ApiConfig.projectUrl}/$networkImageParam";
  List<String> stringSplit = imageUrl.split('?');
  if (stringSplit.length == 1) {
    mainImageUrl = stringSplit[0];
  } else {
    mainImageUrl = stringSplit[1].substring(2);
    mainImageUrl = "${ApiConfig.projectUrl}/$mainImageUrl";
    List<String> imageParams = mainImageUrl.split('&');
    mainImageUrl = imageParams[0];
  }

  return mainImageUrl;
}

/// get profile image
String getCompanyLogo(String? networkImageParam) {
  if (networkImageParam == null) {
    return '';
  }

  String wrongPrefixFound = '';
  const String  wrongPrefix = 'https://showwcase-companies-logos.s3-accelerate.amazonaws.com';
  const String  wrongPrefix2 = 'https://showwcase-companies-logos.s3.amazonaws.com';
  String  correctPrefix = ApiConfig.companyAssetUrl;

  String mainImageUrl = Uri.decodeFull(networkImageParam);

  if(mainImageUrl.startsWith(wrongPrefix)) {
    wrongPrefixFound = wrongPrefix;
  }else if(mainImageUrl.startsWith(wrongPrefix2)){
    wrongPrefixFound = wrongPrefix2;
  }

  if(wrongPrefixFound != ''){
    final subLinked = mainImageUrl.substring(wrongPrefixFound.length);
    mainImageUrl = "$correctPrefix$subLinked";
  }

  return mainImageUrl;
}

String modifyAssetUrl(
    {required String filename, int width = 100, int height = 100,}) {
  String  prefixUrl = 'https://profile-assets.showwcase.com/';
  if (filename.contains('showwcase.com')) {
    return filename ;
  }
  String ext = filename.split('?')[0].split('.').removeLast() ;
  bool isBlob = filename.contains('blob:');
  if ( filename.contains('?')) {
    filename = parseProfileCoverImageURL(filename);
  }

  if (!filename.contains('showwcase.com')) {
    filename = prefixUrl +  Uri.encodeFull(filename);
  }
  if (!['png', 'jpeg', 'jpg', 'webp'].contains(ext.toLowerCase()) || isBlob) {
    return filename;
  }
  filename = Uri.encodeFull(filename);
  return filename;

}

String parseProfileCoverImageURL(String filename) {
  List<String> splitString = filename.split('?');
  String params = splitString[1];
  List<String> urlList = params.split('m=')[1].split('&');
  String modifiedKey = urlList[0];
  return modifiedKey ;
}


// void setAppSystemOverlay({bool useThemeOverlays = true, required ThemeData theme, bool strictlyUseDarkModeOverlays = false, strictlyUseLightModeOverlays = false}) {
//
//   darkThemeOverlay() {
//      setSystemUIOverlays(
//         statusBarColor: Colors.transparent,
//
//         // for android only
//         statusBarBrightness: Brightness.light,
//
//         // IOS
//         statusBarIconBrightness: Brightness.dark,
//
//         // For android //
//         navigationBarColor: kAppBlack,
//
//         // for android only
//         navigationBarIconBrightness: Brightness.light
//     );
//   }
//
//   lightThemeOverlay() {
//     setSystemUIOverlays(
//         statusBarColor: Colors.transparent,
//         // IOS
//         statusBarBrightness: Brightness.light,
//
//         statusBarIconBrightness: Brightness.dark, // for android, dark means icons should be black
//         // For android //
//         navigationBarColor: kAppWhite,
//
//         // for android only
//         navigationBarIconBrightness: Brightness.dark // dark means icons should be black
//     );
//   }
//
//   if(strictlyUseDarkModeOverlays) {
//     darkThemeOverlay();
//   }
//   else if(strictlyUseLightModeOverlays) {
//     darkThemeOverlay();
//   }else{
//     if(theme.brightness == Brightness.dark){
//       darkThemeOverlay();
//     }else{
//       lightThemeOverlay();
//     }
//   }
//
// }

Future<void> enableFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
}

Future<void> disableFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
}

String formatHumanReadable(int numberToFormat){
  var formattedNumber = NumberFormat.compactCurrency(decimalDigits: 2, symbol: '',).format(numberToFormat);
  return formattedNumber.endsWith('.00')  ? formattedNumber.replaceAll('.00','')  : formattedNumber ;
}

bool checksEqual(String first, String second) {
  return (first.toLowerCase().trim() == second.toLowerCase().trim());
}

bool checksNotEqual(String first, String second) {
  return (first.toLowerCase().trim() != second.toLowerCase().trim());
}

String profileCoverImageUrl({required String? profileCoverImageKey}) {
  String mainImageUrl = '';
  if (profileCoverImageKey == null) {
    return mainImageUrl;
  }
  List<String> stringSplit = profileCoverImageKey.split('?');
  if (stringSplit.length == 1) {
    mainImageUrl = getProfileImage(stringSplit[0]);
  } else {
    mainImageUrl = stringSplit[1].substring(2);
    mainImageUrl = getProfileImage(mainImageUrl);
    List<String> imageParams = mainImageUrl.split('&');
    mainImageUrl = imageParams[0];
  }
  return mainImageUrl;
}

Future<List<File>?> pickFilesFromGallery(BuildContext context, {bool multiple = false, RequestType requestType = RequestType.image}) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

  if(context.mounted) {

    if (ps.isAuth) {
      // Granted.
      // final file = await context.router.push(GalleryPageRoute()) as File?;
      final dataReturned = await pushScreen(context, GalleryPage(multiple: multiple, requestType: requestType,));
      if(dataReturned == null) return null; // User probably tapped on the back button

      // multiple files
      if(dataReturned is List<File>?) {

        // these are all expected to be images
        final filesReturned = (dataReturned as List<File>);
        return filesReturned;

      }
      else {
        // if its video it can only return single video at a time
        // single file (can be video / image)
        File fileReturned = dataReturned as File;
        return [fileReturned];
      }


    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
      if (ps == PermissionState.limited) {
        PhotoManager.openSetting();
        context.showSnackBar('Permission denied', appearance: Appearance.error);
      }

      return null;

    }
  }

  return null;


}

Future<File?> cropImage(String filePath,{ CropStyle? cropStyle }) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
      cropStyle: cropStyle ?? CropStyle.circle,
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

  if (croppedImage != null) {
    final croppedImageAsFile = File(croppedImage.path);
    // profileImageChanged.value = croppedImageAsFile;
    // upload image to server
    return croppedImageAsFile;
  }

  return null;
}

List<String> generateYearList(int startYear, int endYear) {
  List<String> years = [];

  for (int year = startYear; year <= endYear; year++) {
    years.add(year.toString());
  }

  return years;
}

DateTime convertYearMonthToDate({required String year, required String month}){
  return DateFormat.LLLL()
      .add_y()
      .parse('$month $year');
}

Future<File> getFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}


String camelCaseToSnakeCase({required String camelCase}) {
  final exp = RegExp('(?<=[a-z])[A-Z]');
  String result = camelCase.replaceAllMapped(exp, (m) => '_${m.group(0)}').toLowerCase();
  return result;
}

Future<File?> networkImageToFile(String networkUrl) async {
  try {
    final filename = networkUrl.split('/').last;
    Directory dir = await getTemporaryDirectory();
    String pathName = path.join(dir.path, filename);

    final response = await http.get(Uri.parse(networkUrl));

    if (response.statusCode != 200) {
      return null;
    }

    final _theFile = File(pathName);

    _theFile.writeAsBytesSync(response.bodyBytes);

    return _theFile;
  } catch (e) {
    debugPrint("networkImageToFile exception:  $e");
    return null;
  }
}

List<UserModel> removeDuplicates(List<UserModel> users) {

  List<UserModel> uniqueUsers = users.fold<List<UserModel>>([], (list, user) {
    if (!list.any((existingUser) => existingUser.id == user.id)) {
      list.add(user);
    }
    return list;
  });

  return uniqueUsers;
}

// target 'OneSignalNotificationServiceExtension' do
// use_frameworks!
// pod 'OneSignalXCFramework', '>= 5.0.0', '< 6.0'
// end