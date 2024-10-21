import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dropdown.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_cubit.dart';
import 'package:showwcase_v3/features/users/data/bloc/user_profile_state.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';

import '../../../../companies/presentation/pages/search_company_page.dart';
import '../../../data/bloc/user_enums.dart';

class PersonalCredentialsEditorPage extends StatefulWidget {

  final UserCertificationModel? userCertificationModel;
  const PersonalCredentialsEditorPage({Key? key, this.userCertificationModel}) : super(key: key);

  @override
  PersonalCredentialsEditorPageController createState() => PersonalCredentialsEditorPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _PersonalCredentialsEditorPageView extends WidgetView<PersonalCredentialsEditorPage, PersonalCredentialsEditorPageController> {

  const _PersonalCredentialsEditorPageView(PersonalCredentialsEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: SafeArea(
          top: false,
          bottom: true,
          child: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const CustomInnerPageSliverAppBar(
                pinned: true,
                pageTitle: 'Credentials',
              )
            ];
          }, body:
          SingleChildScrollView(
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
                    GestureDetector(
                      onTap: state._handleCertificationImageUpload,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: ColoredBox(
                                color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                                child: Stack(
                                  children: [
                                    ValueListenableBuilder<String?>(valueListenable: state.certificationImage, builder: (_, certificationImage, __) {

                                      if(certificationImage == null){
                                        return BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                        selector: (fileManagerState) {
                                          return fileManagerState.fileItems.firstWhereOrNull(
                                                (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 0,
                                          );
                                        },
                                        builder: (context, fileItem) {
                                          if(fileItem?.status == FileItemStatus.inProgress){
                                            return const SizedBox.shrink();
                                          }
                                          return Center(
                                                child: Icon(Icons.camera_alt_rounded, size: 18, color: theme.colorScheme.onBackground,),
                                              );
                                          },
                                        );
                                      }
                                      return SizedBox(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        child: CustomNetworkImageWidget(
                                          imageUrl: getProfileImage(certificationImage),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),

                                    BlocBuilder<FileManagerCubit, FileManagerState>(
                                      builder: (context, fileManagerState) {
                                        if(fileManagerState.status == FileManagerStatus.uploadImageInProgress){
                                          return const Center(
                                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppBlue,strokeWidth: 2,),),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Set profile picture',
                                style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600,),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('Upload a photo',
                                style: TextStyle(color: theme.colorScheme.onPrimary),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('size 2MB',
                                style: TextStyle(color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFieldWidget(
                      label: 'Title *',
                      placeHolder: 'eg. Google IT Support Professional',
                      validator: state.isRequired,
                      controller: state.titleTextEditingController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFieldWidget(
                      label: 'Institution *',
                      placeHolder: 'Institution Name',
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

                    CustomTextFieldWidget(
                      controller: state.certificationIdTextEditingController,
                      label: 'Certification ID',
                      placeHolder: 'Eg. 1234567890',
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    CustomTextFieldWidget(
                      controller: state.certificationURLTextEditingController,
                      label: 'Certification URL',
                      placeHolder: 'eg. https://example.com',
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        if(widget.userCertificationModel != null) ... {
                          Expanded(child:  BlocBuilder<UserProfileCubit, UserProfileState>(
                              builder: (ctx, userState) {
                                return CustomButtonWidget(
                                  expand: true,
                                  loading: userState.status == UserStatus.deleteCertificationInProgress,
                                  appearance: Appearance.error,
                                  text: 'Delete', onPressed: () => state.deleteCertification() ,);
                              }
                          ),),
                          const SizedBox(width: 10,),
                        },
                        Expanded(child:  BlocBuilder<UserProfileCubit, UserProfileState>(
                            builder: (ctx, userState) {
                              return CustomButtonWidget(
                                loading: userState.status == UserStatus.addCertificationInProgress
                                    || userState.status == UserStatus.updateCertificationInProgress,
                                expand: true,
                                text: 'Save', onPressed: (){
                                state.handleSubmit(ctx);
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
          ),
        )
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class PersonalCredentialsEditorPageController extends State<PersonalCredentialsEditorPage> with FormMixin  {

  final TextEditingController titleTextEditingController = TextEditingController();
  final TextEditingController companyTextEditingController = TextEditingController();
  final TextEditingController certificationIdTextEditingController = TextEditingController();
  final TextEditingController certificationURLTextEditingController = TextEditingController();
  CompanyModel? selectedCompany;
  final ValueNotifier<bool> current = ValueNotifier(false);
  late ValueNotifier<String> startMonth;
  late ValueNotifier<String> startYear;
  late ValueNotifier<String> endMonth;
  late ValueNotifier<String> endYear;

  final ValueNotifier<String?> certificationImage = ValueNotifier(null);
  late FileManagerCubit fileManagerCubit;
  late UserProfileCubit userCubit;
  late StreamSubscription<UserProfileState> userStateStreamSubscription;
  final String fileUploadGroupId = "personal_credentials_editor_page";


  @override
  Widget build(BuildContext context) => _PersonalCredentialsEditorPageView(this);

  @override
  void initState() {
    super.initState();
    fileManagerCubit = context.read<FileManagerCubit>();
    userCubit = context.read<UserProfileCubit>();
    userStateStreamSubscription = userCubit.stream.listen((event) {
      if(mounted){
        if(event.status == UserStatus.addCertificationFailed || event.status == UserStatus.updateCertificationFailed || event.status == UserStatus.deleteCertificationFailed){
          context.showSnackBar(event.message);
        }

        if(event.status == UserStatus.addCertificationSuccessful){
          context.showSnackBar("New credentials added");
          clearForm();
          pop(context);
        }

        if(event.status == UserStatus.updateCertificationSuccessful){
          context.showSnackBar("Credentials updated");
          clearForm();
          pop(context);
        }

        if(event.status == UserStatus.deleteCertificationSuccessful){
          context.showSnackBar("Credentials deleted");
          pop(context);
        }

      }
    });

    resetDates();
    initializeFields();

  }

  void initializeFields() {

    if(widget.userCertificationModel != null) {

      certificationImage.value = widget.userCertificationModel?.attachmentUrl;
      titleTextEditingController.text = widget.userCertificationModel?.title ?? '';
      if(widget.userCertificationModel?.organizationId != null) {
        selectedCompany = CompanyModel(
            id: widget.userCertificationModel?.organizationId,
            name: widget.userCertificationModel?.organizationName,
            logo: widget.userCertificationModel?.organizationLogo
        );
        companyTextEditingController.text = widget.userCertificationModel?.organizationName ?? '';
      }
      if(widget.userCertificationModel?.startDate != null){
        startMonth.value = monthsList[widget.userCertificationModel!.startDate!.month - 1];
        startYear.value = widget.userCertificationModel!.startDate!.year.toString();
      }
      if(widget.userCertificationModel?.endDate != null){
        endMonth.value = monthsList[widget.userCertificationModel!.endDate!.month - 1];
        endYear.value = widget.userCertificationModel!.endDate!.year.toString();
      }

      current.value = widget.userCertificationModel?.current ?? false;
      certificationIdTextEditingController.text = widget.userCertificationModel?.credentialId ?? '';
      certificationURLTextEditingController.text = widget.userCertificationModel?.url ?? '';

    }
  }

  void clearForm() {
    certificationImage.value = null;
    titleTextEditingController.clear();
    selectedCompany = null;
    companyTextEditingController.clear();
    resetDates();
    current.value = false;
    certificationIdTextEditingController.clear();
    certificationURLTextEditingController.clear();
  }

  void resetDates() {
    final now = DateTime.now();
    startMonth = ValueNotifier(monthsList[now.month - 1]);
    startYear = ValueNotifier((now.year - 5).toString());
    endMonth = ValueNotifier(monthsList[now.month - 1]);
    endYear = ValueNotifier(now.year.toString());
  }

  void handleSetCompanyTapped() async {
    final CompanyModel? company = await pushScreen(context, const SearchCompaniesPage(title: "Institution")) as CompanyModel?;
    if(company == null) {
      return;
    }
    selectedCompany = company;
    companyTextEditingController.text = company.name ?? '';
  }

  void handleSubmit(BuildContext ctx){
    if(!validateAndSaveOnSubmit(ctx)){
      return;
    }

    final startDateAsDateTime = convertYearMonthToDate(year: startYear.value, month: startMonth.value);
    final endDateAsDateTime = convertYearMonthToDate(year: endYear.value, month: endMonth.value);

    final user = AppStorage.currentUserSession!;


    /// Update  experience
    if(widget.userCertificationModel != null){

      userCubit.updateCertification(user, widget.userCertificationModel!,
        attachmentUrl: certificationImage.value,
        title: titleTextEditingController.text.trim(),
        company: selectedCompany,
        startDate: startDateAsDateTime,
        endDate: current.value ? null : endDateAsDateTime,
        current: current.value,
        certificationId: certificationIdTextEditingController.text,
        url: certificationURLTextEditingController.text
      );
      return;
    }

    userCubit.addCertification(user,
         attachmentUrl: certificationImage.value,
         title: titleTextEditingController.text.trim(),
         company: selectedCompany,
         startDate: startDateAsDateTime,
         endDate: endDateAsDateTime,
         current: current.value,
         certificationId: certificationIdTextEditingController.text.trim(),
         url: certificationURLTextEditingController.text.trim(),
    );

  }

  void _handleCertificationImageUpload() async {
    final files = await pickFilesFromGallery(context);
    if(files != null && files.isNotEmpty) {
      final croppedFile = await cropImage(files[0].path, cropStyle: CropStyle.rectangle);
      if(croppedFile != null) {
        _uploadImageToServer(croppedFile);
      }
    }
  }

  _uploadImageToServer(File file) async {
    final either = await fileManagerCubit.uploadImage(file: file, bucketName: profilePictureBucket, fileTag: 0, groupId: fileUploadGroupId);
    if(!mounted){
      return;
    }
    if(either.isLeft()){
      context.showSnackBar("Upload failed");
      return;
    }

    // successful
    final fileItem = either.asRight();
    // set the profileImage to the current user session
    if(fileItem.preSignedUrl?.url == null){
      context.showSnackBar("Upload failed");
      return;
    }

    final pImageKey = fileItem.preSignedUrl?.preSignedUrlFields?.key;
    if(pImageKey == null){
      context.showSnackBar("Upload failed");
      return;
    }

    final pImage = getProfileImage(pImageKey);

    certificationImage.value = pImage;
    context.showSnackBar("Upload completed");

  }

  /// Delete certification
  void deleteCertification() {
    if(widget.userCertificationModel != null && mounted){
      showConfirmDialog(context, onConfirmTapped: (){
        final user = AppStorage.currentUserSession!;
        userCubit.deleteCertification(user, widget.userCertificationModel!);
      }, title: "Delete Credential");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

}