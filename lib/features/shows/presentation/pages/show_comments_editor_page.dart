import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_markdown/quill_markdown.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/bloc/shows_enums.dart';
import 'package:showwcase_v3/features/shows/data/models/show_comment_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_comment_item_widget.dart';
import 'package:showwcase_v3/features/shows/presentation/widgets/show_item_widget.dart';

class ShowCommentsEditorPage extends StatefulWidget {

  final ShowModel showModel;
  final ShowCommentModel? parentComment;
  final ShowCommentModel? commentToEdit;
  const ShowCommentsEditorPage({Key? key, required this.showModel, this.commentToEdit, this.parentComment}) : super(key: key);

  @override
  ShowCommentsEditorPageController createState() => ShowCommentsEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ShowCommentsEditorPageView extends WidgetView<ShowCommentsEditorPage, ShowCommentsEditorPageController> {

  const _ShowCommentsEditorPageView(ShowCommentsEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1),child: CustomBorderWidget(),),
        title: Text('Discussion', style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize) ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () => state.handleSubmit(), child: Text('Submit', style: theme.textTheme.bodyMedium?.copyWith(color: kAppBlue, fontWeight: FontWeight.w700),)),
          const SizedBox(width: 15,)
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: Column(
          children: [
            if(widget.parentComment != null) ... {
              Padding(
                padding: const EdgeInsets.only(left: showSymmetricPadding, right: showSymmetricPadding, top: 10, bottom: 10),
                child: ShowCommentItemWidget(comment: widget.parentComment!, show: widget.showModel, hideActionBar: true, hideMoreMenu: true, hideReplies: true, ),
              ),
            }else  ... {
              Padding(
                padding: const EdgeInsets.only(left: showSymmetricPadding, right: showSymmetricPadding, top: 10),
                child: ShowItemWidget(showModel: widget.showModel, showActionBar: false, onTap: () {},pageName: showCommentsPage),
              ),
            },
            const CustomBorderWidget(),
            Expanded(child: SafeArea(
                top: false,
                bottom: true,
                child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: quill.QuillEditor(
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                  configurations: QuillEditorConfigurations(
                    controller: state.controller,
                    scrollable: true,
                    autoFocus: true,
                    readOnly: false,
                    expands: false,
                    padding: EdgeInsets.zero,
                    placeholder: "Write something nice",
                  ),
                )
            ))),
            BlocBuilder<ShowPreviewCubit, ShowPreviewState>(
              builder: (context, showPreviewState) {
                if(showPreviewState.status == ShowsStatus.createShowCommentInProgress
                    || showPreviewState.status == ShowsStatus.updateCommentInProgress) {
                  return const CustomLinearLoadingIndicatorWidget();
                }
                return const SizedBox.shrink();
              },
            ),
            ValueListenableBuilder<bool>(valueListenable: state.toolBarExpanded, builder: (_, toolBarExpanded, __) {
              return Column(
                children: [
                  const CustomBorderWidget(),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: quill.QuillToolbar.simple(
                          configurations: quill.QuillSimpleToolbarConfigurations(
                            controller: state.controller,
                              multiRowsDisplay: toolBarExpanded,
                              showDividers: true,
                              showFontFamily: toolBarExpanded,
                              showFontSize: toolBarExpanded,
                              showBoldButton: true,
                              showItalicButton: true,
                              showSmallButton: false,
                              showUnderLineButton: true,
                              showStrikeThrough: toolBarExpanded,
                              showInlineCode: true,
                              showColorButton: false,
                              showBackgroundColorButton: false,
                              showClearFormat: toolBarExpanded,
                              showAlignmentButtons: toolBarExpanded,
                              showLeftAlignment: toolBarExpanded,
                              showCenterAlignment: toolBarExpanded,
                              showRightAlignment: toolBarExpanded,
                              showJustifyAlignment: toolBarExpanded,
                              showHeaderStyle: true,
                              showListNumbers: toolBarExpanded,
                              showListBullets: toolBarExpanded,
                              showListCheck: toolBarExpanded,
                              showCodeBlock: true,
                              showQuote: true,
                              showIndent: true,
                              showLink: toolBarExpanded,
                              showUndo: toolBarExpanded,
                              showRedo: toolBarExpanded,
                              showDirection: toolBarExpanded,
                              showSearchButton: false,
                              showSubscript: toolBarExpanded,
                              showSuperscript: toolBarExpanded,
                              color: theme.colorScheme.background,
                              buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                                base: quill.QuillToolbarBaseButtonOptions(
                                  iconTheme: quill.QuillIconTheme(
                                    iconButtonSelectedStyle: ButtonStyle(
                                      backgroundColor: MaterialStateColor.resolveWith((states) => kAppBlue),
                                      foregroundColor: MaterialStateColor.resolveWith((states) => kAppWhite),
                                    ),
                                    iconButtonUnselectedStyle: ButtonStyle(
                                      backgroundColor: MaterialStateColor.resolveWith((states) => theme.colorScheme.background,),
                                      foregroundColor: MaterialStateColor.resolveWith((states) => theme.colorScheme.onBackground),
                                    ),
                                    // iconUnselectedFillColor: theme.colorScheme.background,
                                    // iconSelectedFillColor: kAppBlue,
                                    // iconUnselectedColor: theme.colorScheme.onBackground,
                                    // iconSelectedColor: kAppWhite
                                  ),
                                ),
                              ),
                              dialogTheme: const quill.QuillDialogTheme().copyWith(
                                dialogBackgroundColor: theme.colorScheme.background,
                                inputTextStyle: theme.textTheme.bodyMedium,
                                buttonStyle: ButtonStyle(
                                    textStyle: MaterialStateProperty.resolveWith((states) => theme.textTheme.bodyMedium)
                                ),
                                labelTextStyle: theme.textTheme.bodyMedium,
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                          ),
                          // iconTheme: quill.QuillIconTheme(
                          //     iconUnselectedFillColor: theme.colorScheme.background,
                          //     iconSelectedFillColor: kAppBlue,
                          //     iconUnselectedColor: theme.colorScheme.onBackground,
                          //     iconSelectedColor: kAppWhite
                          // ),


                        ),),
                        Container(
                          width: 1,
                          color: theme.colorScheme.outline,
                          margin: const EdgeInsets.only(left: 0),
                        ),
                        IconButton(onPressed: (){
                          state.toolBarExpanded.value = !state.toolBarExpanded.value;
                        }, icon: Icon(toolBarExpanded ?Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 24, color: kAppBlue,))
                      ],
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ShowCommentsEditorPageController extends State<ShowCommentsEditorPage> {

  late FocusNode focusNode;
  late ShowPreviewCubit showPreviewCubit;
  final quill.QuillController controller = quill.QuillController.basic();
  final ValueNotifier<bool> toolBarExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _ShowCommentsEditorPageView(this);

  @override
  void initState() {
    super.initState();
    showPreviewCubit = context.read<ShowPreviewCubit>();
    focusNode = FocusNode();

    if(widget.commentToEdit?.message != null) {
      final aboutQuill = markdownToQuill(widget.commentToEdit?.message ?? '');
      if(aboutQuill != null) {
       controller.document = quill.Document.fromJson(jsonDecode(aboutQuill));
      }

    }

    onWidgetBindingComplete(onComplete: () {
      focusNode.requestFocus();
    });

  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void handleSubmit() async {

    if(controller.document.isEmpty()){
      context.showSnackBar('Comment cannot be empty');
      return;
    }

    final delta = controller.document.toDelta().toJson();
    final markdown = quillToMarkdown(json.encode(delta));

    if(widget.commentToEdit?.message == null) {

      await showPreviewCubit.createShowComment(message: markdown ?? '', show: widget.showModel, parentComment: widget.parentComment);
      if(mounted) {
        pop(context);
      }

    } else {

      await showPreviewCubit.updateComment(show: widget.showModel, comment: widget.commentToEdit!.copyWith(
        message: markdown
      ), parentComment: widget.parentComment);

      if(mounted) {
        pop(context);
      }

    }

  }



}