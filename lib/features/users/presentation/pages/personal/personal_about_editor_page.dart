import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:quill_markdown/quill_markdown.dart';
import 'package:quill_markdown/quill_markdown.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
// import 'package:delta_markdown/delta_markdown.dart';


class PersonalAboutEditorPage extends StatefulWidget {

  const PersonalAboutEditorPage({Key? key}) : super(key: key);

  @override
  PersonalAboutEditorPageController createState() => PersonalAboutEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalAboutEditorPageView extends WidgetView<PersonalAboutEditorPage, PersonalAboutEditorPageController> {

  const _PersonalAboutEditorPageView(PersonalAboutEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocSelector<UserProfileCubit, UserProfileState, UserModel?>(
      selector: (userState) {
        final currentUser = AppStorage.currentUserSession!;
        final userProfiles = [...userState.userProfiles];
        final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
        if(index < 0){
          return null;
        }
        final userInfo = userProfiles[index].userInfo;
        return userInfo;
      },
      builder: (context, userInfo) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
            bottom: const PreferredSize(preferredSize: Size.fromHeight(1),child: CustomBorderWidget(),),
            actions: [
              TextButton(onPressed: () => state.onSave(userInfo), child: Text('Save', style: theme.textTheme.bodyMedium?.copyWith(color: kAppBlue, fontWeight: FontWeight.w700),)),
              const SizedBox(width: 15,)
            ],
          ),
          body: SafeArea(
            top: false,bottom: true,
            child: SizedBox(
              height: double.maxFinite,
              child: Column(
                 children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: quill.QuillEditor.basic(

                        configurations: quill.QuillEditorConfigurations(
                          controller: state.controller,
                          readOnly: false, // true for view only mode
                        ),

                      ),
                    )),
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

                                      ))
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
          ),
        );
      },
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalAboutEditorPageController extends State<PersonalAboutEditorPage> {

  late AuthCubit authCubit;
  late UserProfileCubit userCubit;
  final quill.QuillController controller = quill.QuillController.basic();
  final ValueNotifier<bool> toolBarExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => _PersonalAboutEditorPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    userCubit = context.read<UserProfileCubit>();
    final currentUser = AppStorage.currentUserSession!;
    final aboutMarkdown = currentUser.about ?? '';
    if(aboutMarkdown.isNotEmpty) {
      final aboutQuill = markdownToQuill(aboutMarkdown);
      if(aboutQuill != null) {
       controller.document = quill.Document.fromJson(jsonDecode(aboutQuill));
      }

    }

  }

  void onSave(UserModel? user) {

    if(user == null){return;}

   final delta = controller.document.toDelta().toJson();
    // final markdown = deltaToMarkdown(delta.toString());
    final markdown = quillToMarkdown(json.encode(delta));
    debugPrint("customLog: delta -> $markdown");
    // save the order on the server

    userCubit.setUserInfo(userInfo: user.copyWith(
        about: markdown
    ));
    // save to server
    authCubit.updateAuthUserData(user.copyWith(about: markdown), emitToSubscribers: false);
    pop(context);

  }


  @override
  void dispose() {
    super.dispose();
   // controller.dispose();
  }
}
