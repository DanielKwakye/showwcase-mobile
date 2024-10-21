import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserResumePage extends StatefulWidget {

  final UserModel user;
  const UserResumePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserResumePage> createState() => _UserResumePageState();
}

class _UserResumePageState extends State<UserResumePage> {

  late UserProfileCubit userProfileCubit;
  late StreamSubscription<UserProfileState> userProfileStateStreamSubscription;

  @override
  void initState() {
    userProfileCubit = context.read<UserProfileCubit>();
    userProfileStateStreamSubscription = userProfileCubit.stream.listen((event) {
      if (event.status == UserStatus.downloadResumeSuccess) {
        context.showSnackBar('Resume has been saved to your downloads');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    userProfileStateStreamSubscription.cancel();
    super.dispose();
  }

  void downloadResume() async {
    final storagePermissionGranted = await requestPermission(Permission.storage);
    if(storagePermissionGranted){
      userProfileCubit.downloadResume(resumeUrl: widget.user.resumeUrl!, userName: widget.user.displayName!);
      return;
    }

    if(mounted) {
      context.showSnackBar("Storage permission not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: theme.colorScheme.onBackground,
          ),
          elevation: 0.0,
          title: Text(
            '${widget.user.displayName}\'s Resume',
            style: TextStyle(color: theme.colorScheme.onBackground),
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    onTap: () {
                      final FlutterShareMe flutterShareMe = FlutterShareMe();
                      flutterShareMe.shareToSystem(msg: 'Here is a Link to my Resume : ${widget.user.resumeUrl}');
                    },
                    child: const Text("Share"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: downloadResume,
                    child: const Text("Save"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {
                      copyTextToClipBoard(context, widget.user.resumeUrl!);
                    },
                    child: const Text("Copy Resume Url"),
                  ),
                ])
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: true,
          child: SfPdfViewer.network(
            '${widget.user.resumeUrl!}?${DateTime.now()}',
            onHyperlinkClicked:  (PdfHyperlinkClickedDetails details){
              launchUrl(Uri.parse(details.uri), mode: LaunchMode.externalApplication);
            },
          ),
        ));
  }
}
