import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_cubit.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class ShowsUserMetaDataWidget extends StatefulWidget {

  final UserModel user;
  final DateTime? withTime;
  final bool showUsername;
  final ShowModel show;
  final bool showMoreMenu;

  const ShowsUserMetaDataWidget({required this.user,
    this.showUsername = false,
    this.withTime,
    this.showMoreMenu = true,
    Key? key, required this.show}) : super(key: key);

  @override
  State<ShowsUserMetaDataWidget> createState() => _ShowsUserMetaDataWidgetState();
}

class _ShowsUserMetaDataWidgetState extends State<ShowsUserMetaDataWidget> {

  late ShowsCubit showCubit;
  late TextEditingController _reportMessageController;
  // late ThreadsResponse upvoteThread, boostTread, bookmarkThread;
  ValueNotifier<String?> selectedReport = ValueNotifier(null);
  ValueNotifier<bool> activateReportButton = ValueNotifier(false);

  String reportReason = '';

  @override
  void initState() {
    super.initState();
    showCubit = context.read<ShowsCubit>();
    _reportMessageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const spacing =  SizedBox(width: 5,);
    return GestureDetector(
      // splashColor: Colors.transparent,
      onTap: () {
        // changeScreenWithConstructor(context, ProfilePage(user: widget.user));
        pushToProfile(context, user: widget.user);
      },
      child: Column(
        // crossAxisAlignment: WMainAxisAlignment.start,
        //crossAxisAlignment: WrapCrossAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("${widget.user.displayName ?? ''} ",
                      style: TextStyle(
                          color:  theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  if(widget.user.badges != null
                      && widget.user.badges!.isNotEmpty
                  ) ... {
                    if(widget.user.badges!.contains('founding_creator')
                        || widget.user.badges!.contains('community_lead')
                    )
                      const Icon(Icons.verified, color: kAppBlue, size: 15,),
                    const SizedBox(width: 5,),
                  },
                 // Text(widget.user.activity?.emoji != null && widget.user.activity!.emoji!.contains('?') ? widget.user.activity!.emoji! : '🔎', style: TextStyle(color: theme.colorScheme.onBackground),),// emoji
                ],
              ),
              if(widget.showMoreMenu) ... {
                PopupMenuButton<String>(

                  padding: const EdgeInsets.only(right: 0.0,bottom: 0),
                  onSelected: (menu) {
                    if(menu == "report"){
                      _reportThreadUI(context);
                      return;
                    }
                    _onMoreMenuItemTapped(menu);
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  itemBuilder: (ctx) => [
                    _buildPopupMenuItem(context, 'Click to copy', Icons.copy, "copy"),
                    const PopupMenuDivider(),
                    _buildPopupMenuItem(context, 'Report show', Icons.flag_outlined, "report"),
                  ],
                  child: Container(
                    height: 24,
                    width: 24,
                    alignment: Alignment.centerRight,
                    child: Icon(
                        Icons.more_horiz,
                        color:theme.colorScheme.onPrimary.withOpacity(0.7)
                    ),
                  ),
                )
              }

            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if(widget.showUsername && widget.user.username != null) ... {
                Text('@${widget.user.username!}', style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.normal)),
              },
              if(widget.withTime != null) ... [
                spacing,
                const CustomDotWidget(),
                spacing,
                Text(getTimeAgo(widget.withTime!), style: TextStyle(color: theme.colorScheme.onPrimary),),
              ],
            ],
          )

        ]

      ),
    );
  }

  void _onMoreMenuItemTapped(String menu){
     if (menu == "copy"){
      final copyUrl = "${ApiConfig.websiteUrl}/show/${widget.show.id}/${widget.show.slug}";
      copyTextToClipBoard(context, copyUrl);
      AnalyticsService.instance.sendEventShowCopyLink(showModel: widget.show,pageName: '',);
      // AnalyticsManager.showCopyLink(pageTitle: 'shows', pageName: 'copy_show',pageId: widget.show.id!);
    }
  }

  void _reportThreadUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        builder: (ctx) {
          return Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(alignment: Alignment.topRight, child: CloseButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),),
                  const CustomBorderWidget(),
                  const SizedBox(height: 20,),
                  Text('Why are you reporting this show?', style: theme(context).textTheme.bodyText2,),
                  const SizedBox(height: 10,),
                  ValueListenableBuilder(valueListenable: selectedReport,
                      builder: (ctx, value, _) {
                        return Row(
                          children:  [
                            ChoiceChip(label: Text("Spam", style: TextStyle(color: value == "spam" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),),
                              selected: value == "spam",
                              selectedColor: kAppBlue,
                              onSelected: (v) {
                                reportReason = "Spam";
                                selectedReport.value = "spam";
                                activateReportButton.value = true;
                                _reportMessageController.clear();
                              }, ),
                            const SizedBox(width: 10,),
                            ChoiceChip(label: Text("Inappropriate", style: TextStyle(color: value == "inappropriate" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),), selected: value == "inappropriate", selectedColor: kAppBlue, onSelected: (v) {
                              selectedReport.value = "inappropriate";
                              reportReason = "Inappropriate";
                              activateReportButton.value = true;
                              _reportMessageController.clear();
                            },),
                            const SizedBox(width: 10,),
                            ChoiceChip(label: Text("Plagiarism", style: TextStyle(color: value == "plagiarism" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5))), selected: value == "plagiarism", selectedColor: kAppBlue, onSelected: (v) {
                              selectedReport.value = "plagiarism";
                              reportReason = "Plagiarism";
                              activateReportButton.value = true;
                              _reportMessageController.clear();
                            },),
                          ],
                        );
                      }
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldWidget(
                    controller: _reportMessageController,
                    label: "Other reason", placeHolder: "Enter your reason",
                    onChange: (value) => _onReportReasonChanged(value!),
                  ),
                  const SizedBox(height: 10,),
                  Builder(builder: (ctx) {
                    return ValueListenableBuilder<bool>(valueListenable: activateReportButton, builder: (ctx, bool activate, _) {

                      return CustomButtonWidget(text: "Submit report",
                          appearance: Appearance.clean,
                          textColor: activate ? kAppBlue : null,
                          outlineColor: activate ? kAppBlue : null,
                          backgroundColor: activate ? null : theme(context).colorScheme.outline,
                          onPressed: activate ? () {
                            _submitReport(ctx);
                          } : null );

                    },);
                  }
                  ),
                  const SizedBox(height: kToolbarHeight,),
                ],
              ),
            ),
          );
        });
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String title, IconData iconData, String value) {
    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      value: value,
      height: 30,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 12,),
          Icon(iconData, color: theme(context).colorScheme.onBackground, size: 16,),
          // const SizedBox(width: 15,),
          const SizedBox(width: 8,),
          Text(title, style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: defaultFontSize - 1),),
          const SizedBox(width: 8,),
        ],
      ),
    );
  }

  void _submitReport(BuildContext ctx) {
    showCubit.reportShow(message: reportReason, projectId: widget.show.id!);
    Navigator.of(context).pop();
  }

  void _onReportReasonChanged(String value) {
    selectedReport.value = null;
    if(value.isNotEmpty){
      activateReportButton.value = true;
    }else {
      activateReportButton.value = false;
    }
    reportReason = value;
  }
}
