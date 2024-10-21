import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/presentation/pages/search_company_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dropdown.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_enums.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tech_stack_model.dart';
import 'package:showwcase_v3/features/users/presentation/pages/personal/personal_tech_stack_editor_page.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/user_stack_widget.dart';

import '../../../../../core/utils/theme.dart';
import '../../../data/models/user_stack_model.dart';

class PersonalExperiencesEditorPage extends StatefulWidget {

  final UserExperienceModel? userExperienceModel;
  const PersonalExperiencesEditorPage({Key? key, this.userExperienceModel}) : super(key: key);

  @override
  PersonalExperiencesEditorPageController createState() => PersonalExperiencesEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalExperiencesEditorPageView extends WidgetView<PersonalExperiencesEditorPage, PersonalExperiencesEditorPageController> {

  const _PersonalExperiencesEditorPageView(PersonalExperiencesEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const CustomInnerPageSliverAppBar(
              pinned: true,
              pageTitle: 'Experience',
            )
          ];
        }, body: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFieldWidget(
                      label: 'Title *',
                      placeHolder: 'eg. Frontend Engineer',
                      validator: state.isRequired,
                      controller: state.titleTextEditingController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFieldWidget(
                      label: 'Company *',
                      placeHolder: 'Company Name',
                      readOnly: true,
                      validator: state.isRequired,
                      onTap: state.handleSetCompanyTapped,
                      controller: state.companyTextEditingController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Start date *',
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /// Start Month and year
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: state.startMonth,
                          builder: (BuildContext context, String? value, Widget? child) {
                            return Flexible(
                              flex: 1,
                              child: CustomDropdownWidget(
                                items: monthsList,
                                hintText: 'Select Month',
                                showChooseOneOption: false,
                                value: value ?? monthsList.first,
                                onChanged: (String? value) {
                                  if(value == null){
                                    return;
                                  }
                                  state.startMonth.value = value;
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ValueListenableBuilder<String>(valueListenable: state.endYear, builder: (_, endYear, __){
                          return ValueListenableBuilder<String>(
                            valueListenable: state.startYear,
                            builder:
                                (BuildContext context, String? value, Widget? child) {
                              return Flexible(
                                flex: 1,
                                child: CustomDropdownWidget(
                                  items: generateYearList(DateTime.now().year - 50, DateTime.now().year),
                                  hintText: 'Select Year',
                                  showChooseOneOption: false,
                                  value: value ?? DateTime.now().year.toString(),
                                  onChanged: (String? value) {
                                    if(value == null){
                                      return;
                                    }
                                    state.startYear.value = value;
                                  },
                                ),
                              );
                            },
                          );
                        })
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    /// End month and year
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End date *',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder<bool>(valueListenable: state.current, builder: (_, endDateIsPresent, __){
                              return Switch.adaptive(
                                value: endDateIsPresent,
                                onChanged: (bool value) {
                                  state.current.value = value;
                                },
                                activeColor: kAppBlue,
                              );
                            }),
                            Text(
                              'Current',
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    ValueListenableBuilder<bool>(valueListenable: state.current, builder: (_, endDateIsPresent, __){
                      if(endDateIsPresent){
                        return const SizedBox.shrink();
                      }
                      return Row(
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: state.endMonth,
                            builder: (BuildContext context, String? value, Widget? child) {
                              return Flexible(
                                flex: 1,
                                child: CustomDropdownWidget(
                                  items: monthsList,
                                  hintText: 'Select Month',
                                  showChooseOneOption: false,
                                  value: value ?? monthsList.first,
                                  onChanged: (String? value) {
                                    if(value == null){
                                      return;
                                    }
                                    state.endMonth.value = value;
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ValueListenableBuilder(valueListenable: state.startYear, builder: (_, startYear, __) {
                            return ValueListenableBuilder(
                              valueListenable: state.endYear,
                              builder:
                                  (BuildContext context, String? value, Widget? child) {
                                return Flexible(
                                  flex: 1,
                                  child: CustomDropdownWidget(
                                    items: generateYearList(DateTime(int.parse(startYear)).year, DateTime.now().year),
                                    hintText: 'Select Year',
                                    showChooseOneOption: false,
                                    value: value ?? DateTime.now().year.toString(),
                                    onChanged: (String? value) {
                                      if(value == null){
                                        return;
                                      }
                                      state.endYear.value = value;
                                    },
                                  ),
                                );
                              },
                            );
                          })
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    /// description
                    CustomTextFieldWidget(
                      label: 'Description',
                      placeHolder: 'Description',
                      controller: state.descriptionTextEditingController,
                      inputType: TextInputType.multiline,
                      maxLines: 7,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    CustomTextFieldWidget(
                      label: 'Tech Stack',
                      placeHolder: 'Search for Stacks',
                      readOnly: true,
                      onTap: () => pushScreen(context, PersonalTechStackEditorPage(returnResultsOnly: true, onTechStackSelected: state.addStack,)),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    ValueListenableBuilder<List<UserStackModel>>(valueListenable: state.userStacks, builder: (_, userStacks, __) {
                      return SeparatedColumn(
                        separatorBuilder: (_, __) => const SizedBox(height: 10,),
                        children: userStacks.map((userStack) {
                          return UserStackWidget(userStackModel: userStack, onDeleteTapped: state.removeStack,);
                        }).toList(),
                      );
                    }),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        if(widget.userExperienceModel != null) ... {
                          Expanded(child:  BlocBuilder<UserProfileCubit, UserProfileState>(
                              builder: (ctx, userState) {
                                return CustomButtonWidget(
                                  expand: true,
                                  loading: userState.status == UserStatus.deleteExperienceInProgress,
                                  appearance: Appearance.error,
                                  text: 'Delete', onPressed: () => state.deleteExperience() ,);
                              }
                          ),),
                          const SizedBox(width: 10,),
                        },
                        Expanded(child:  BlocBuilder<UserProfileCubit, UserProfileState>(
                            builder: (ctx, userState) {
                              return CustomButtonWidget(
                                loading: userState.status == UserStatus.addExperienceInProgress
                                    || userState.status == UserStatus.updateExperienceInProgress,
                                expand: true,
                                text: 'Save', onPressed: (){
                                state.handSubmit(ctx);
                              },);
                            }
                        ),),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        )
        )
    );

  }



}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalExperiencesEditorPageController extends State<PersonalExperiencesEditorPage> with FormMixin {

  final TextEditingController titleTextEditingController = TextEditingController();
  final TextEditingController descriptionTextEditingController = TextEditingController();
  final TextEditingController companyTextEditingController = TextEditingController();
  CompanyModel? selectedCompany;


  final ValueNotifier<bool> current = ValueNotifier(false);
  late ValueNotifier<String> startMonth;
  late ValueNotifier<String> startYear;
  late ValueNotifier<String> endMonth;
  late ValueNotifier<String> endYear;

  final ValueNotifier<List<UserStackModel>> userStacks = ValueNotifier([]);
  late UserProfileCubit userCubit;
  late StreamSubscription<UserProfileState> userStateStreamSubscription;


  @override
  Widget build(BuildContext context) => _PersonalExperiencesEditorPageView(this);

  @override
  void initState() {
    super.initState();

    resetDates();
    userCubit = context.read<UserProfileCubit>();
    userStateStreamSubscription = userCubit.stream.listen((event) {
        if(mounted){
          if(event.status == UserStatus.addExperienceFailed || event.status == UserStatus.updateExperienceFailed || event.status == UserStatus.deleteExperienceFailed){
            context.showSnackBar(event.message);
          }

          if(event.status == UserStatus.addExperienceSuccessful){
            context.showSnackBar("New experience added");
            clearForm();
            pop(context);
          }

          if(event.status == UserStatus.updateExperienceSuccessful){
            context.showSnackBar("Experience updated");
            clearForm();
            pop(context);
          }

          if(event.status == UserStatus.deleteExperienceSuccessful){
            context.showSnackBar("Experience deleted");
            pop(context);
          }

        }
    });

    initializeFields();

  }

  void resetDates() {
    final now = DateTime.now();
    startMonth = ValueNotifier(monthsList[now.month - 1]);
    startYear = ValueNotifier((now.year - 5).toString());
    endMonth = ValueNotifier(monthsList[now.month - 1]);
    endYear = ValueNotifier(now.year.toString());
  }

  void initializeFields(){
    if(widget.userExperienceModel != null) {
      titleTextEditingController.text = widget.userExperienceModel?.title ?? '';
      if(widget.userExperienceModel?.companyId != null) {
        selectedCompany = CompanyModel(
            id: widget.userExperienceModel?.companyId,
            name: widget.userExperienceModel?.companyName,
            logo: widget.userExperienceModel?.companyLogo
        );
        companyTextEditingController.text = widget.userExperienceModel?.companyName ?? '';
      }
      if(widget.userExperienceModel?.startDate != null){
        startMonth.value = monthsList[widget.userExperienceModel!.startDate!.month - 1];
        startYear.value = widget.userExperienceModel!.startDate!.year.toString();
      }
      if(widget.userExperienceModel?.endDate != null){
        endMonth.value = monthsList[widget.userExperienceModel!.endDate!.month - 1];
        endYear.value = widget.userExperienceModel!.endDate!.year.toString();
      }
      current.value = widget.userExperienceModel?.current ?? false;
      descriptionTextEditingController.text = widget.userExperienceModel?.description ?? '';
      userStacks.value = (widget.userExperienceModel?.stacks ?? []).where((element) => element.stack != null).map((e) => e.stack!).toList();

    }
  }

  void handleSetCompanyTapped() async {
    final CompanyModel? company = await pushScreen(context, const SearchCompaniesPage()) as CompanyModel?;
    if(company == null) {
      return;
    }
    selectedCompany = company;
    companyTextEditingController.text = company.name ?? '';
  }

  void handSubmit(BuildContext ctx){
    if(!validateAndSaveOnSubmit(ctx)){
      return;
    }

    final startDateAsDateTime = convertYearMonthToDate(year: startYear.value, month: startMonth.value);
    final endDateAsDateTime = convertYearMonthToDate(year: endYear.value, month: endMonth.value);

    final user = AppStorage.currentUserSession!;

    /// Update  experience
    if(widget.userExperienceModel != null){

      userCubit.updateExperience(user, widget.userExperienceModel!,
          title: titleTextEditingController.text.trim(),
          company: selectedCompany,
          startDate: startDateAsDateTime,
          endDate: current.value ? null : endDateAsDateTime,
          current: current.value,
          description: descriptionTextEditingController.text.trim(),
      );
      return;
    }

    /// Add new  experience
    userCubit.addExperience(user,
       title: titleTextEditingController.text.trim(),
       company: selectedCompany,
       startDate: startDateAsDateTime,
       endDate: current.value ? null : endDateAsDateTime,
       current: current.value,
       description: descriptionTextEditingController.text.trim(),
       stacks: userStacks.value
    );


  }

  /// Delete experience
  void deleteExperience() {
    if(widget.userExperienceModel != null && mounted){
      showConfirmDialog(context, onConfirmTapped: (){
        final user = AppStorage.currentUserSession!;
        userCubit.deleteExperience(user, widget.userExperienceModel!);
      }, title: "Delete Experience");
    }
  }

  void clearForm() {
    titleTextEditingController.clear();
    selectedCompany = null;
    companyTextEditingController.clear();
    resetDates();
    current.value = false;
    descriptionTextEditingController.clear();
    userStacks.value = [];

  }


  void addStack(UserStackModel userStackModel) {
    final userStacksCopied = [...userStacks.value];
    userStacksCopied.add(userStackModel);
    userStacks.value = userStacksCopied;

    // update techStack on the server if -----
    if(widget.userExperienceModel != null){
      final user = AppStorage.currentUserSession!;
      userCubit.addUserExperienceStack(user, userExperienceModel: widget.userExperienceModel!, stackModel: userStackModel);
    }

  }

  /// remove user tech stacks
  void removeStack(UserStackModel userStackModel){
    final userStacksCopied = [...userStacks.value];
    userStacksCopied.remove(userStackModel);
    userStacks.value = userStacksCopied;

    // update techStack on the server if -----
    if(widget.userExperienceModel != null){
      final user = AppStorage.currentUserSession!;
      userCubit.deleteUserExperienceStack(user, userExperienceModel: widget.userExperienceModel!, techStackModel: UserTechStackModel(
        stackId: userStackModel.id,
        experienceId: widget.userExperienceModel?.id,
        stack: userStackModel
      ));
    }

  }



  @override
  void dispose() {
    super.dispose();
    titleTextEditingController.dispose();
    userStateStreamSubscription.cancel();
  }

}