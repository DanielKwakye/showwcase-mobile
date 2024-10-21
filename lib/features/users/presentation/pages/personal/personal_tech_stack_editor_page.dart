import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_stack_widget.dart';

class PersonalTechStackEditorPage extends StatefulWidget {

  final bool returnResultsOnly; // by setting returnResultsOnly to true, selected tech stacks will only be returned to the caller of this page and not added to userState
  final Function(UserStackModel)? onTechStackSelected; // if onTechStackSelected is not null , every selected UserTechStackModel will be passed through this function

  const PersonalTechStackEditorPage({
    Key? key,
    this.returnResultsOnly = false,
    this.onTechStackSelected}) : super(key: key);

  @override
  PersonalTechStackEditorPageController createState() => PersonalTechStackEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalTechStackEditorPageView extends WidgetView<PersonalTechStackEditorPage, PersonalTechStackEditorPageController> {

  const _PersonalTechStackEditorPageView(PersonalTechStackEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: NestedScrollView(headerSliverBuilder: (ctx, scrolled) {
          return  [
            const CustomInnerPageSliverAppBar(
              pinned: true,
              pageTitle: 'Tech Stacks',
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<bool>(
                  valueListenable: state.showCancelSearchButton,
                  builder: (_, showCancelSearchButton, __) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFieldWidget(
                              prefixIcon: Icon(Icons.search, color: theme.colorScheme.onPrimary.withOpacity(0.5), size: 20,),
                              controller: state.searchTextEditingController,
                              focusNode: state.searchFocusNode,
                              label: 'Search skills and technologies',
                              placeHolder: 'Search here ...',
                              onChange: state.onSearch,
                              suffix: showCancelSearchButton ? IconButton(icon: const Icon(Icons.close, color: kAppRed, size: 20,), onPressed: () {
                                state.searchTextEditingController.clear();
                                state.onSearch('');
                              },) : null),
                            BlocBuilder<UserProfileCubit, UserProfileState>(
                              builder: (context, userState) {
                                if(userState.status == UserStatus.searchUserTechStacksInProgress){
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: LinearProgressIndicator(color: kAppBlue, minHeight: 1,),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          const SizedBox(height: 5,),
                        ],
                      ),
                    );
                  }
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<List<UserStackModel>>(valueListenable: state.filteredTechStacks, builder: (_, techStacks, __){
                if(techStacks.isEmpty){
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(6),
                      color: theme.colorScheme.primary,
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    itemCount: techStacks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserStackWidget(userStackModel: techStacks[index], onTap: state.onAddStack,);
                    }, separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20,);
                  },
                  ),
                );

              }),
            )
          ];
        }, body: widget.returnResultsOnly ? const SizedBox.shrink() :
        BlocSelector<UserProfileCubit, UserProfileState, List<UserTechStackModel>?>(
          selector: (userState) {
            final currentUser = AppStorage.currentUserSession!;
            final userProfiles = userState.userProfiles;
            final index = userProfiles.indexWhere((element) => element.username == currentUser.username);
            if(index < 0){
              return null;
            }
            return userProfiles[index].techStacks;
          },
          builder: (context, techStacks) {
            if(techStacks == null || techStacks.isEmpty) {
              return const SizedBox.shrink();
            }
            final categorisedTechStacks = state.userCubit.getCategorisedTechStacks(techStacks);
            return ListView.separated(
              separatorBuilder: (_, __){
                return const SizedBox(height: 20,);
              },
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shrinkWrap: true,
              itemCount: categorisedTechStacks.length,
              itemBuilder: (context, index) {
                String category = categorisedTechStacks.keys.elementAt(index);
                List<UserTechStackModel?> techStackList = categorisedTechStacks.values.elementAt(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // category title-----------------------
                    Text(
                      category,
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Category list here -------------------------------------
                    SeparatedColumn(
                      separatorBuilder: (_,__) {
                        return const SizedBox(height: 8,);
                      },
                      children: techStackList.map((item) {
                        final i = techStackList.indexOf(item);
                        UserTechStackModel? techStackItem = techStackList[i];
                        if(techStackItem == null){
                          return const SizedBox.shrink();
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: theme.colorScheme.outline.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 8, right: 8),
                                    child: ClipRRect(
                                        borderRadius:BorderRadius.circular(5),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: techStackItem.stack?.icon != null ? CustomNetworkImageWidget(
                                            imageUrl: '${ApiConfig.stackIconsUrl}/${techStackItem.stack?.icon}',
                                          ) : Image.asset(kTechStackPlaceHolderIcon),
                                        )
                                    ),
                                  ),
                                  Text(
                                    techStackItem.stack?.name ?? "",
                                    style: TextStyle(
                                        color: theme.colorScheme.onBackground,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Expanded(child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: TextButton(onPressed: (){
                                      showExperiencesModal(context, techStackItem, onItemSelected: (int experience){
                                        state.onSetExperience(techStackItem.stack, experience);
                                      });
                                    }, child: Text(techStackItem.experience == null ? 'Select Experiences' : state.userCubit.getTechExperienceNameFromValue(techStackItem),
                                      style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),),
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: GestureDetector(onTap: () {
                                      state.onMarkStackAsFeatured(techStackItem.stack, !(techStackItem.isFeatured ?? false));
                                    }, behavior: HitTestBehavior.opaque, child: Icon(Icons.star,size: 18,color: techStackItem.isFeatured ?? false? kAppBlue : theme.colorScheme.onPrimary.withOpacity(0.5)),),
                                  ),

                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: GestureDetector(onTap: () {

                                      state.onRemoveStack(techStackItem.stack);

                                    }, behavior: HitTestBehavior.opaque, child: Icon(Icons.delete,size: 16,color: theme.colorScheme.onPrimary.withOpacity(0.5)),),
                                  ),

                                ],
                              ))
                              // const Spacer(),

                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );

          },
        )
        ),
      ),
    );

  }

  void showExperiencesModal(BuildContext ctx, UserTechStackModel model, {Function(int)? onItemSelected }) {
    final theme = Theme.of(ctx);
    final ch = Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: ListTile(
              title: Text('Select Experience', style: TextStyle(fontWeight: FontWeight.w600),),
            ),
          ),
          const CustomBorderWidget(),
          ...techStackExperiences.map((e) {
            final value = e['value'] as int;
            bool selected = value == model.experience;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: ListTile(
                    title: Text(e['title'] as String),
                    subtitle: Text(e['desc'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: theme.colorScheme.onPrimary),),
                    onTap: () {
                      onItemSelected?.call(value);
                      pop(ctx);
                    },
                    trailing: selected ? const Icon(Icons.check, color: kAppBlue, size: 18,) : null,
                    minVerticalPadding: 8,
                  ),
                ),
                const CustomBorderWidget()
              ],
            );
          })
        ]);
    showCustomBottomSheet(ctx, child: ch);
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalTechStackEditorPageController extends State<PersonalTechStackEditorPage> {

  final ValueNotifier<bool> showCancelSearchButton = ValueNotifier(false);
  final TextEditingController searchTextEditingController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late ValueNotifier<List<UserStackModel>> filteredTechStacks;
  late UserProfileCubit userCubit;

  @override
  Widget build(BuildContext context) => _PersonalTechStackEditorPageView(this);

  @override
  void initState() {
    super.initState();
    filteredTechStacks = ValueNotifier(const []);
    userCubit = context.read<UserProfileCubit>();
  }


  void onSearch(String? searchText) {

    EasyDebounce.debounce(
        'tech-stack-search-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          debugPrint('searchText: $searchText');

          if(searchText.isNullOrEmpty()) {
            filteredTechStacks.value = const [];
            showCancelSearchButton.value = false;
            return;
          }


          // final filtered = worldLanguages.where((element) => (element['name'] as String).trim().toLowerCase().contains(searchText!.toLowerCase())).toList();
          // filteredLanguages.value = filtered;
          showCancelSearchButton.value = true;
          final stacks = await userCubit.searchUserTechStacks(keyword: searchText!);
          if(stacks == null){
            return;
          }

          filteredTechStacks.value = stacks;

        }
    );
  }


  void onAddStack(UserStackModel? stackModel) {
    onSearch(''); // clear dropdown list
    searchTextEditingController.clear();
    searchFocusNode.unfocus();

    if(stackModel != null){
      widget.onTechStackSelected?.call(stackModel);
    }

    if(widget.returnResultsOnly){
      pop(context);
      return;
    }
    final user  = AppStorage.currentUserSession!;
    userCubit.addTechStack(userModel: user, techStackModel: UserTechStackModel(
        stackId: stackModel?.id,
        stack: stackModel
    ));
  }

  void onRemoveStack(UserStackModel? stackModel) {
    final user  = AppStorage.currentUserSession!;
    userCubit.removeTechStack(userModel: user, techStackModel: UserTechStackModel(
        stackId: stackModel?.id,
        stack: stackModel
    ));
  }

  void onMarkStackAsFeatured(UserStackModel? stackModel, bool? isFeatured) {
    final user  = AppStorage.currentUserSession!;
    userCubit.markTechStackAsFeatured(userModel: user, techStackModel: UserTechStackModel(
        stackId: stackModel?.id,
        stack: stackModel,
        isFeatured: isFeatured
    ));
  }

  void onSetExperience(UserStackModel? stackModel, int experience) {
    final user  = AppStorage.currentUserSession!;
    userCubit.updateTechStackExperience(
        userModel: user, techStackModel: UserTechStackModel(
        stackId: stackModel?.id,
        stack: stackModel,
        experience: experience
    ));
  }

  @override
  void dispose() {
    super.dispose();
    searchTextEditingController.dispose();
    searchFocusNode.dispose();
  }

}