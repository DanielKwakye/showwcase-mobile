import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/auth/data/bloc/auth_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_activity_model.dart';

class PersonalStatusPage extends StatefulWidget {

  final UserActivityModel? activity;
  const PersonalStatusPage({Key? key, this.activity}) : super(key: key);

  @override
  StatusPageController createState() => StatusPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _StatusPageView extends WidgetView<PersonalStatusPage, StatusPageController> {

  const _StatusPageView(StatusPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

            return [
              CustomInnerPageSliverAppBar(
                pinned: true,
                actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(onPressed: state.onComplete, child: const Text('Done', style: TextStyle(color: kAppBlue, fontWeight: FontWeight.bold),)),
                )
              ],),
              const SliverToBoxAdapter(child: SizedBox(height: 20,),),
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: state.selectedEmoji,
                    builder: (_, emoji, __) {
                      return CustomTextFieldWidget(
                        focusNode: state.focusNode,
                        controller: state.textEditingController,
                        label: 'Current status',
                        placeHolder: '',
                        prefixIcon: GestureDetector(
                            onTap: () => showEmojis(context, onEmojiSelected: state.onEmojiSelected),
                            child:  Padding(padding: const EdgeInsets.all(15), child: Text(emoji ?? ''),)),
                      );
                    }
                  ),
                ),
              ),
            ];

        }, body:  SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select status", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(6),
                    color: theme.colorScheme.primary,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: state.userActivitiesList.map((activity) => ListTile(
                        onTap: () => state.onItemTapped(activity),
                        minLeadingWidth: 0,
                        leading:  Text(activity.emoji ?? '', style: TextStyle(color: theme.colorScheme.onPrimary),),
                        title: Text(activity.message ?? '', style: TextStyle(color: theme.colorScheme.onPrimary),)
                    )).toList(),
                  ) ,
                ),
              ],
            ),
          ),
        ) ,

        )
    );

  }



}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class StatusPageController extends State<PersonalStatusPage> {

  late AuthCubit authCubit;
  final ValueNotifier<String?> selectedEmoji = ValueNotifier(null);
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();
  final List<UserActivityModel> userActivitiesList = [
    const UserActivityModel(
        emoji: '👩🏽',
        message: 'Busy coding'
    ),
    const UserActivityModel(
        emoji: '🚢',
        message: 'About to ship'
    ),
    const UserActivityModel(
        emoji: '🔍',
        message: 'Open to work'
    ),
    const UserActivityModel(
        emoji: '🕓',
        message: 'Hustling'
    ),
    const UserActivityModel(
        emoji: '🚀',
        message: 'Working Remotely'
    ),
  ];


  @override
  Widget build(BuildContext context) => _StatusPageView(this);

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();


    if(widget.activity != null){
      textEditingController.text = widget.activity?.message ?? '';
      selectedEmoji.value = widget.activity?.emoji;
    }else {
      final user = AppStorage.currentUserSession!;
      selectedEmoji.value = user.activity?.emoji;
      textEditingController.text = user.activity?.message ?? '';
    }

    onWidgetBindingComplete(onComplete: () {
      focusNode.requestFocus();
    });
  }

  void onItemTapped(UserActivityModel activityModel) {
    textEditingController.text = activityModel.message ?? '';
    selectedEmoji.value = activityModel.emoji;
  }

  void onEmojiSelected(Emoji emoji) {
    selectedEmoji.value = emoji.emoji;
  }

  void onComplete() {
    final message = textEditingController.text;
    final emoji = selectedEmoji.value ?? '';
    pop(context, UserActivityModel(message: message, emoji: emoji));
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    textEditingController.dispose();
  }

}