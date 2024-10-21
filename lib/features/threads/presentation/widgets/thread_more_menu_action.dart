import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_cubit.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_enums.dart';
import 'package:showwcase_v3/features/threads/data/bloc/thread_state.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';


class ThreadMoreMenuAction extends StatefulWidget {

  final Color? iconColor;
  final ThreadModel thread;
  final double? paddingRight;
  // final Function(FeedActionType)? onActionItemTapped;


  const ThreadMoreMenuAction({
    required this.thread,
    this.iconColor,
    this.paddingRight,
    Key? key}) : super(key: key);

  @override
  MoreMenuActionController createState() => MoreMenuActionController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _MoreMenuActionView extends WidgetView<ThreadMoreMenuAction, MoreMenuActionController> {

  const _MoreMenuActionView(MoreMenuActionController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onPrimary ;

    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
      ),
      child: PopupMenuButton<String>(
        onSelected: (menu) {
          if(menu == "report"){
            _reportThreadUI(context);
            return;
          }
          state._onMoreMenuItemTapped(menu);
        },
        offset: const Offset(0,20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),

        color: theme.colorScheme.background ,
        shadowColor: theme.colorScheme.onPrimary.withOpacity(0.3),
        itemBuilder: (ctx) => [
          _buildPopupMenuItem(context, 'Click to copy', Icons.copy, "copy"),
          const PopupMenuDivider(),
          _buildPopupMenuItem(context, 'Report thread', Icons.flag_outlined, "report"),
          if(
          // true
          widget.thread.user?.id == AppStorage.currentUserSession?.id
          ) ... {
            const PopupMenuDivider(),
            _buildPopupMenuItem(context, 'Edit thread  ', Icons.edit_outlined, "edit"),
          },
          if(widget.thread.user?.id == AppStorage.currentUserSession?.id) ... {
            const PopupMenuDivider(),
            _buildPopupMenuItem(context, 'Delete thread', Icons.delete_outline, "delete"),
          },

        ],
        child: Container(
          height: 20,
          width: 50,
          // color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: widget.paddingRight ?? 0),
          child: Icon(
              Icons.more_horiz,
              color: widget.iconColor ?? iconColor,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(BuildContext context,
      String title, IconData iconData, String value) {
    return PopupMenuItem(
      padding: const EdgeInsets.only(left: 15, right: 10),
      value: value,
      height: 30,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(iconData, color: theme(context).colorScheme.onBackground, size: 16,),
          const SizedBox(width: 8,),
          Text(title, style: TextStyle(color: theme(context).colorScheme.onBackground, fontSize: defaultFontSize - 1),),
        ],
      ),
    );
  }


  void _reportThreadUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: MediaQuery.of(ctx).viewInsets.bottom),
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
                    Text('Why are you reporting this thread?', style: theme(context).textTheme.bodyText2,),
                    const SizedBox(height: 10,),
                    ValueListenableBuilder(valueListenable: state.selectedReport,
                        builder: (ctx, value, _) {
                          return Row(
                            children:  [
                              ChoiceChip(label: Text("Spam", style: TextStyle(color: value == "spam" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),),
                                selected: value == "spam",
                                selectedColor: kAppBlue,
                                onSelected: (v) {
                                  state.reportReason = "Spam";
                                  state.selectedReport.value = "spam";
                                  state.activateReportButton.value = true;
                                  state._reportMessageController.clear();
                                }, ),
                              const SizedBox(width: 10,),
                              ChoiceChip(label: Text("Inappropriate", style: TextStyle(color: value == "inappropriate" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5)),), selected: value == "inappropriate", selectedColor: kAppBlue, onSelected: (v) {
                                state.selectedReport.value = "inappropriate";
                                state.reportReason = "Inappropriate";
                                state.activateReportButton.value = true;
                                state._reportMessageController.clear();
                              },),
                              const SizedBox(width: 10,),
                              ChoiceChip(label: Text("Plagiarism", style: TextStyle(color: value == "plagiarism" ? kAppWhite : theme(context).colorScheme.onBackground.withOpacity(0.5))), selected: value == "plagiarism", selectedColor: kAppBlue, onSelected: (v) {
                                state.selectedReport.value = "plagiarism";
                                state.reportReason = "Plagiarism";
                                state.activateReportButton.value = true;
                                state._reportMessageController.clear();
                              },),
                            ],
                          );
                        }
                    ),
                    const SizedBox(height: 10,),
                    CustomTextFieldWidget(
                      controller: state._reportMessageController,
                      label: "Other reason", placeHolder: "Enter your reason",
                      onChange: (value) => state._onReportReasonChanged(value!),
                    ),
                    const SizedBox(height: 10,),
                    Builder(builder: (ctx) {
                      return ValueListenableBuilder<bool>(valueListenable: state.activateReportButton, builder: (ctx, bool activate, _) {

                        return BlocBuilder<ThreadCubit, ThreadState>(
                          buildWhen: (_, next) {
                            return next.status == ThreadStatus.reportThreadInProgress
                                || next.status == ThreadStatus.reportThreadFailed
                                || next.status == ThreadStatus.reportThreadSuccessful;
                          },
                          builder: (context, threadState) {
                            return CustomButtonWidget(text: "Submit report",
                                appearance: Appearance.clean,
                                textColor: activate ? kAppBlue : null,
                                loading: threadState.status == ThreadStatus.reportThreadInProgress,
                                outlineColor: activate ? kAppBlue : null,
                                backgroundColor: activate ? null : theme(context).colorScheme.outline,
                                onPressed: activate ? () {
                                   state._submitReport(ctx);
                                } : null );
                          },
                        );

                      },);
                    }
                    ),
                    const SizedBox(height: kToolbarHeight,),
                  ],
                ),
              ),
            ),
          );
        });
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class MoreMenuActionController extends State<ThreadMoreMenuAction> {

  // late ThreadsResponse upvoteThread, boostTread, bookmarkThread;
  ValueNotifier<String?> selectedReport = ValueNotifier(null);
  ValueNotifier<bool> activateReportButton = ValueNotifier(false);
  String reportReason = '';
  late ThreadCubit threadCubit;
  late HomeCubit homeCubit;

  late TextEditingController _reportMessageController;



  @override
  void initState() {
    super.initState();
    threadCubit = context.read<ThreadCubit>();
    homeCubit = context.read<HomeCubit>();
    _reportMessageController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) => _MoreMenuActionView(this);


  void _onReportReasonChanged(String value) {
    selectedReport.value = null;
    if(value.isNotEmpty){
      activateReportButton.value = true;
    }else {
      activateReportButton.value = false;
    }
    reportReason = value;
  }

  Future<void> _submitReport(BuildContext ctx) async {

    final String? error = await threadCubit.reportThread(message: reportReason, threadId: widget.thread.id);
    if(mounted) {
      if(error != null) {
        context.showSnackBar(error, appearance: Appearance.error);
        return;
      }

      context.showSnackBar("Thanks for the feedback. The reported thread is now under investigation", appearance: Appearance.success);
      Navigator.of(context).pop();
    }
  }

  void _onMoreMenuItemTapped(String menu){
    if (menu == "copy"){
      final copyUrl = "${ApiConfig.websiteUrl}/thread/${widget.thread.id}";
      copyTextToClipBoard(context, copyUrl);
      AnalyticsService.instance.sendEventThreadPost(threadModel: widget.thread);

    }
    else if(menu == "delete") {
      _showDeleteDialog(
          title: "Are you sure?",
          subTitle: "Are you sure you want to permanently delete this thread? This will permanently delete this Thread and will not be recoverable",
          data: {
            'threadId': widget.thread.id
          }
      );

    }
    else if(menu == "edit") {
      //
      final thread = widget.thread;
      context.push(threadEditorPage, extra: {
        "threadToEdit": thread,
        "community": thread.community,
      });
      // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
      //     builder: (context) => CreateThreadPage<T>(
      //       entryId: widget.entryId,
      //       threadToEdit: _thread,
      //       community :widget.thread.community
      //     ),
      //     fullscreenDialog: true,
      //     settings: const RouteSettings(arguments: {'page_title':'edit_thread'})
      // ));

    }
  }


  @override
  void dispose() {
    super.dispose();
    _reportMessageController.dispose();
  }



  void _showDeleteDialog({ String? title, String? subTitle,
    String confirmActionText = "Confirm", String cancelActionText = "Cancel", Map<String, dynamic>? data})
  {

    data ??= {};

    data.putIfAbsent("title", () => title ?? "Are you sure?");
    data.putIfAbsent("subTitle", () => subTitle);
    data.putIfAbsent("cancelActionText", () => cancelActionText);
    data.putIfAbsent("confirmActionText", () => confirmActionText);


    showConfirmDialog(context, title: data['title'] ?? '',
      subtitle: data['subTitle'],
      cancelAction: data['cancelActionText'],
      confirmAction: data['confirmActionText'],
      onConfirmTapped: () async {
        homeCubit.enablePageLoad();
        final error = await threadCubit.deleteThread(thread: widget.thread);
        homeCubit.dismissPageLoad();
        if(mounted) {
          if(error != null){
            context.showSnackBar(error);
          }else{
            context.showSnackBar("Thread Deleted");
            AnalyticsService.instance.sendEventThreadDelete(threadModel:  widget.thread,pageName: "thread_page");
      }
        }

      },

    );
    // widget.onDeleted!(widget.thread.id!);
    // resetPageState();

  }

}