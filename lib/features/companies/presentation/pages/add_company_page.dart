import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_cubit.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_enum.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_state.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_stage_model.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/file_manager/data/models/file_item.dart';
import 'package:showwcase_v3/features/locations/presentation/pages/locations_page.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dropdown.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/social_link_list_widget.dart';

class AddCompanyPage extends StatefulWidget {

  final bool returnCompany;
  final String? title;
  const AddCompanyPage({Key? key, this.returnCompany = true, this.title}) : super(key: key);

  @override
  AddCompanyPageController createState() => AddCompanyPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AddCompanyPageView extends WidgetView<AddCompanyPage, AddCompanyPageController> {

  const _AddCompanyPageView(AddCompanyPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          extendBodyBehindAppBar: true,
          body:  SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: state.coverImage,
                          builder: (BuildContext context, coverImage, Widget? child) {
                            return SizedBox(
                              height: 200,
                              child: GestureDetector(
                                onTap: () {
                                  state.setCoverImage();
                                },
                                child: Stack(
                                  children: [

                                    /// Default image
                                    SizedBox(
                                      width: double.infinity, height: double.infinity,
                                      child: Image.asset('assets/img/settings_background.png', fit: BoxFit.cover,),
                                    ),

                                    /// Actual cover image
                                    if(!coverImage.isNullOrEmpty()) ... {
                                      SizedBox(
                                        width: double.infinity, height: double.infinity,
                                        child: CustomNetworkImageWidget(imageUrl: coverImage!, fit: BoxFit.cover,),
                                      ),
                                    },


                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    /// upload background image progress
                                    BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                      selector: (fileManagerState) {
                                        return fileManagerState.fileItems.firstWhereOrNull(
                                              (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 0,
                                        );
                                      },
                                      builder: (context, fileItem) {
                                        if(fileItem?.status == FileItemStatus.inProgress) {
                                          return  const Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(color: kAppWhite, strokeWidth: 2,),
                                          );
                                        }

                                        return const SizedBox.shrink();
                                      },
                                    )

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          left: 15,
                          child: ValueListenableBuilder<String?>(
                            valueListenable: state.companyImage,
                            builder: (BuildContext context, String? profileImage, Widget? child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(120),
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      state.setProfilePicture();
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        /// Actual cover image


                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: theme.colorScheme.background, width: !profileImage.isNullOrEmpty()  ? 5 : 5),
                                              color: theme.colorScheme.outline,
                                              borderRadius: BorderRadius.circular(120)
                                          ),
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: !profileImage.isNullOrEmpty() ?
                                          SizedBox(
                                            width: double.infinity, height: double.infinity,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(120),
                                                child: CustomNetworkImageWidget(imageUrl: profileImage!, fit: BoxFit.cover,)),
                                          ) : null,
                                        ),

                                        /// upload profile pic progress
                                        BlocSelector<FileManagerCubit, FileManagerState, FileItem?>(
                                          selector: (fileManagerState) {
                                            return fileManagerState.fileItems.firstWhereOrNull(
                                                  (element) => element.groupId == state.fileUploadGroupId && element.fileTag == 1,
                                            );
                                          },
                                          builder: (context, fileItem) {
                                            if(fileItem?.status == FileItemStatus.inProgress) {
                                              return SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(color: profileImage != null ? Colors.white : kAppBlue, strokeWidth: 2,),
                                              );
                                            }
                                            return  Padding(
                                              padding: const EdgeInsets.only(left: 0.0),
                                              child: Icon(
                                                Icons.camera_enhance,
                                                size: 20,
                                                color: profileImage != null ? Colors.white : theme.colorScheme.onBackground,
                                              ),
                                            );
                                          },
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      child: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           CustomTextFieldWidget(
                             label: '${widget.title ?? 'Company'} name *',
                             placeHolder: '',
                             validator: state.isRequired,
                             onChange: state._onCompanyNameTextFieldChange,
                             controller: state.companyNameTextEditingController,
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           ValueListenableBuilder<String?>(valueListenable: state.slugError, builder: (_, slugError, __){
                             return BlocBuilder<CompanyCubit, CompanyState>(
                                builder: (context, companyState) {
                                  return CustomTextFieldWidget(
                                           label: 'showwcase.com/${widget.title?.toLowerCase() ?? 'company'}/*',
                                           placeHolder: 'This field will be auto filled',
                                           disabled: true,
                                           errorText: slugError,
                                           controller: state.slugTextEditingController,
                                           suffix:
                                           companyState.status == CompanyStatus.getCompanyBySlugInProgress ?
                                           const UnconstrainedBox(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1, color: kAppBlue,),))
                                               : (slugError == null && state.slugTextEditingController.text.isNotEmpty) ? const Icon(
                                             Icons.check_circle_outline,
                                             color: kAppGreen,
                                             size: 20,
                                           ) : null,
                                         );
                                },
                              );
                           }),
                           const SizedBox(
                             height: 15,
                           ),
                           CustomTextFieldWidget(
                             label: 'Location',
                             placeHolder: '',
                             controller: state.locationsTextEditingController,
                             readOnly: true,
                             maxLines: null,
                             onTap: () {
                               if(state.locations.isNotEmpty){
                                 return;
                               }
                               state._onLocationTextFieldTapped(addNextLocation: false);
                             },
                             prefixIcon: Padding(
                               padding: const EdgeInsets.all(15),
                               child: SvgPicture.asset(
                                 kLocationIconSvg,
                                 colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
                               ),
                             ),
                             suffix: ValueListenableBuilder<bool>(valueListenable: state.showClearLocationBtn, builder: (_, showClearLocationBtn, __){
                               if(!showClearLocationBtn) {
                                 return const SizedBox.shrink();
                               }
                               return Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   GestureDetector(
                                     onTap:  () => state._onLocationTextFieldTapped(addNextLocation: true),
                                     behavior: HitTestBehavior.opaque,
                                     child:  SvgPicture.asset(
                                       kCircularAddIconSvg,
                                       colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                                     ),
                                   ),
                                   GestureDetector(
                                     onTap: state.handleClearLocation,
                                     behavior: HitTestBehavior.opaque,
                                     child:  Padding(
                                       padding: const EdgeInsets.all(15),
                                       child: Icon(
                                         Icons.delete,
                                         size: 20,
                                         color: theme.colorScheme.onBackground,
                                       ),
                                     ),
                                   ),
                                 ],
                               );
                             }),
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           CustomTextFieldWidget(
                             label: 'About the ${widget.title ?? 'company'}',
                             placeHolder: 'Add some information about the ${widget.title ?? 'company'}',
                             maxLines: 5,
                             controller: state.aboutTextEditingController,
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           SocialLinkListWidget(listener: state._onCompanyLinksUpdatedListener,),
                           const SizedBox(
                             height: 15,
                           ),
                           CustomTextFieldWidget(
                             label: 'One liner', placeHolder: '',
                             controller: state.oneLinerTextEditingController,
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           CustomTextFieldWidget(
                             label: 'Website', placeHolder: '',
                             controller: state.websiteUrlLinerTextEditingController,
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           Row(
                              children: [
                                 Expanded(child:
                                   BlocSelector<CompanyCubit, CompanyState, List<CompanySizeModel>>(
                                     selector: (companyState) {
                                       return companyState.companySizes;
                                     },
                                     builder: (context, list) {

                                       if(list.isEmpty){
                                         return const SizedBox.shrink();
                                       }

                                       return ValueListenableBuilder<String>(valueListenable: state.companySize, builder: (_, value, __){
                                         return CustomDropdownWidget(
                                           items: list.where((element) => !element.label.isNullOrEmpty()).map((e) => e.label ?? '').toList(),
                                           hintText: '${widget.title ?? 'Company'} Size',
                                           label: '${widget.title ?? 'Company'} Size',
                                           value: value,
                                           onChanged: (String? value) {
                                             if(value == null) {
                                               return;
                                             }
                                             state.companySize.value = value;
                                           },
                                         );
                                       });

                                     },
                                   )
                                 ),
                                 const SizedBox(width: 10,),
                                 Expanded(
                                     child: BlocSelector<CompanyCubit, CompanyState, List<CompanyStageModel>>(
                                  selector: (companyState) {
                                    return companyState.companyStages;
                                  },
                                  builder: (context, list) {

                                    if(list.isEmpty || list.first.label.isNullOrEmpty()){
                                      return const SizedBox.shrink();
                                    }

                                    return ValueListenableBuilder<String>(valueListenable: state.companyStage, builder: (_, value, __){
                                      return CustomDropdownWidget(
                                        items: list.where((element) => !element.label.isNullOrEmpty()).map((e) => e.label ?? '').toList(),
                                        hintText: '${widget.title ?? 'Company'} Stage',
                                        label: '${widget.title ?? 'Company'} Stage',
                                        value: value ,
                                        onChanged: (String? value) {
                                          debugPrint("customLog: value: $value");
                                          if(value == null){
                                            return;
                                          }
                                          state.companyStage.value = value;
                                        },
                                      );
                                    });
                                  },
                                )
                                ),
                                // Expanded(child:
                                //    BlocSelector<CompanyCubit, CompanyState, List<CompanySizeModel>>(
                                //      selector: (companyState) {
                                //
                                //        return companyState.;
                                //      },
                                //      builder: (context, list) {
                                //
                                //        return CustomDropdownWidget(
            //                                      items: ,
            //                                      hintText: 'Select ',
            //                                      value: '',
            //                                      onChanged: (String? value) {
            //                                        if(value == null){
            //                                          return;
            //                                        }
            //                                        state.endYear.value = value;
            //                                      },
            //                                    );
                                //      },
                                //    )
                                //
                                //  ),
                                // Expanded(child:
                                //   CustomDropdownWidget(
                                //     items: generateYearList(DateTime(int.parse(startYear)).year, DateTime.now().year),
                                //     hintText: 'Select Year',
                                //     value: value ?? DateTime.now().year.toString(),
                                //     onChanged: (String? value) {
                                //       if(value == null){
                                //         return;
                                //       }
                                //       state.endYear.value = value;
                                //     },
                                //   )
                                // ),
                              ],
                           ),
                           const SizedBox(
                             height: 15,
                           ),
                           BlocSelector<CompanyCubit, CompanyState, List<CompanyIndustryModel>>(
                             selector: (companyState) {
                               return companyState.companyIndustries;
                             },
                             builder: (context, list) {

                               if(list.isEmpty){
                                 return const SizedBox.shrink();
                               }

                               return ValueListenableBuilder<String>(valueListenable: state.companyIndustry, builder: (_, value, __){
                                 return CustomDropdownWidget(
                                   items: list.where((element) => !element.name.isNullOrEmpty()).map((e) => e.name ?? '').toList(),
                                   hintText: '${widget.title ?? 'Company'} Industry',
                                   label: '${widget.title ?? 'Company'} Industry',
                                   value: value,
                                   onChanged: (String? value) {
                                     if(value == null){
                                       return;
                                     }
                                     state.companyIndustry.value = value;
                                   },
                                 );
                               });

                             },
                           ),

                           const SizedBox(height: 20,),

                           BlocBuilder<CompanyCubit, CompanyState>(
                             builder: (ctx, companyState) {
                               return CustomButtonWidget(
                                 loading: companyState.status == CompanyStatus.createCompanyInProgress,
                                 expand: true,
                                 text: 'Create ${widget.title?.toLowerCase() ?? 'company'}', onPressed: () => state.handleSubmit(ctx),
                               );
                             },
                           ),

                           const SizedBox(
                             height: kToolbarHeight,
                           )

                         ],
                      ),
                    ),
                  )


                ],
              ),
            ),
          )
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AddCompanyPageController extends State<AddCompanyPage> with FormMixin {

  final ValueNotifier<String?> coverImage = ValueNotifier(null);
  final ValueNotifier<String?> companyImage = ValueNotifier(null);
  late FileManagerCubit fileManagerCubit;
  late CompanyCubit companyCubit;
  final fileUploadGroupId = "addCompanyPage";
  final TextEditingController companyNameTextEditingController = TextEditingController();
  final TextEditingController slugTextEditingController = TextEditingController();
  final TextEditingController oneLinerTextEditingController = TextEditingController();
  final TextEditingController websiteUrlLinerTextEditingController = TextEditingController();
  final TextEditingController locationsTextEditingController = TextEditingController();
  final ValueNotifier<bool> showClearLocationBtn = ValueNotifier(false);
  final ValueNotifier<bool> showAddNextLocationBtn = ValueNotifier(false);
  final List<String> locations = [];

  final TextEditingController aboutTextEditingController = TextEditingController();
  final ValueNotifier<String?> slugError = ValueNotifier(null);

  List<Map<String, dynamic>> companyLinks = [];
  final ValueNotifier<String> companySize = ValueNotifier('');
  final ValueNotifier<String> companyIndustry = ValueNotifier('');
  final ValueNotifier<String> companyStage = ValueNotifier('');

  @override
  Widget build(BuildContext context) => _AddCompanyPageView(this);

  @override
  void initState() {
    super.initState();
    fileManagerCubit = context.read<FileManagerCubit>();
    companyCubit = context.read<CompanyCubit>();
    companyCubit.getCompanySizes();
    companyCubit.getCompanyStages();
    companyCubit.getCompanyIndustries();
    companyCubit.stream.listen((event) {
      if(event.status == CompanyStatus.createCompanyFailed){
        context.showSnackBar(event.message);
      }
      if(event.status == CompanyStatus.createCompanySuccessful){
        context.showSnackBar("Company created!");
        clearFields();
      }
    });

  }

  void clearFields(){
    if(mounted){
      coverImage.value = null;
      companyImage.value = null;
      companyNameTextEditingController.clear();
      oneLinerTextEditingController.clear();
      slugTextEditingController.clear();
      locations.clear(); // array<String>
      aboutTextEditingController.clear();
      companyLinks = []; // socials: array<{id: String, name: String, value: String, tooltip: String}>, companyLinks: array<id: String, icon:SocialLinkIconModel, link:String, toolTip:String>
      companySize.value = '';
      companyIndustry.value = '';
      companyStage.value = '';
      websiteUrlLinerTextEditingController.clear();
    }
  }

  void setProfilePicture() async {

    final imageUrl = await _getImage(tag: 1);

    if(imageUrl == null){
      return;
    }
    companyImage.value = imageUrl;
  }

  void setCoverImage() async {

    final imageUrl = await _getImage(tag: 0);

    if(imageUrl == null){
      return;
    }
    coverImage.value = imageUrl;
  }

  Future<String?> _getImage({required int tag}) async {

    final files = await pickFilesFromGallery(context);
    if(files == null || files.isEmpty) {
      return null;
    }

    final croppedImage = await cropImage(files[0].path, cropStyle: tag == 0 ?  CropStyle.rectangle :  CropStyle.circle);
    if(croppedImage == null){
      return null;
    }

    // upload cover image
    final either = await fileManagerCubit.uploadImage(
        file: croppedImage, bucketName: profilePictureBucket, fileTag: tag, groupId: fileUploadGroupId);
    if(!mounted){
      return null;
    }
    if(either.isLeft()){
      context.showSnackBar("Upload failed");
      return null;
    }

    // successful
    final fileItem = either.asRight();
    // set the profileImage to the current user session
    if(fileItem.preSignedUrl?.url == null){
      context.showSnackBar("Upload failed");
      return null;
    }

    final pImageKey = fileItem.preSignedUrl?.preSignedUrlFields?.key;
    if(pImageKey == null){
      context.showSnackBar("Upload failed");
      return null;
    }

    final pImage = getProfileImage(pImageKey);
    return pImage;

  }

  _onCompanyLinksUpdatedListener(List<Map<String, dynamic>> updatedValues) {
    companyLinks = updatedValues;
  }


  /// when user taps on location, the keypad does not show so navigate to location helper page
  _onLocationTextFieldTapped({bool addNextLocation = false}) async {
    // final city = await context.router.push(SelectLocationPageRoute(pageTitle: '')) as String?;

    final location = await pushScreen(context, LocationsPage(initialLocation: addNextLocation ? null : locationsTextEditingController.text,)) as String?;

    if (location == null) {
      return;
    }

    if(addNextLocation){
      final existingTextFieldLocations = locationsTextEditingController.text;
      locationsTextEditingController.text = "$existingTextFieldLocations, $location";
    }else{
      locationsTextEditingController.text = location;
    }

    locations.add(location);


    if(locationsTextEditingController.text.isNotEmpty){
      showClearLocationBtn.value = true;
      showAddNextLocationBtn.value = true;
    }

  }

  void handleClearLocation() {
    locationsTextEditingController.clear();
    showClearLocationBtn.value = false;
    showAddNextLocationBtn.value = false;
    locations.clear();
  }

  _onCompanyNameTextFieldChange(String? companyName) async {
    EasyDebounce.debounce(
        'company-name-text-change-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          debugPrint('text: $companyName');

          setCompanySlug(companyName);

        }
    );
  }

  // use debounce to call this method when company name changes
  void setCompanySlug(String? companyName) async {

    if(companyName.isNullOrEmpty()) {
      slugTextEditingController.clear();
      slugError.value = "";
      slugError.value = null;
      return;
    }

    const regex = r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';

    String slug = companyName!.replaceAll(RegExp(regex, unicode: true),'');
    slug = companyName.trim().toLowerCase().replaceAll(' ', '-');

    slugTextEditingController.text = slug;

     final CompanyModel? companyFound = await companyCubit.getCompanyBySlug(slug: slug);
     if(companyFound == null) {
       slugError.value = null;
     }else{
       slugError.value = "This public URL is already in use";
     }

  }


  void handleSubmit(BuildContext ctx) async {
    if(!validateAndSaveOnSubmit(ctx)){
      if(companyNameTextEditingController.text.isEmpty){
        context.showSnackBar("Company name is required");
      }
      return;
    }

    if(slugError.value != null){
      context.showSnackBar("the public URL is already in use");
      return;
    }

    final cover = coverImage.value ?? "";
    final logo = companyImage.value ?? "";
    final companyName = companyNameTextEditingController.text.trim();
    final oneLiner = oneLinerTextEditingController.text.trim();
    final slug = slugTextEditingController.text.trim();
    final companyLocations = locations; // array<String>
    final description = aboutTextEditingController.text.trim();
    final socials = companyLinks.where((element) => element['link'] != "").map((e) {
        final socialLinkIconModel = e["icon"] as SharedSocialLinkIconModel;
        return {
          "id": e['id'],
          "name": socialLinkIconModel.name,
          "value": e["link"],
          "tooltip": e["toolTip"]
        };
    }).toList(); // socials: array<{id: String, name: String, value: String, tooltip: String}>, companyLinks: array<id: String, icon:SocialLinkIconModel, link:String, toolTip:String>
    final sizeId = companyCubit.state.companySizes.where((element) => element.label == companySize.value).firstOrNull?.id ?? '';
    final industryId = companyCubit.state.companyIndustries.where((element) => element.name == companyIndustry.value).firstOrNull?.id ?? '';
    final investmentStageId = companyCubit.state.companyStages.where((element) => element.label == companyStage.value).firstOrNull?.id ?? '';
    final url = websiteUrlLinerTextEditingController.text.trim();

    final payload = {
      "coverImage": cover,
      // "coverImagePreview": ,
      "description": description,
      "industryId": industryId,
      "investmentStageId": investmentStageId,
      "locations": companyLocations,
      "logo": logo,
      "logo_remote": logo,
      "name": companyName,
      "oneLiner": oneLiner,
      "sizeId": sizeId,
      "slug": slug,
      "socials": socials,
      "url": url,
    };

    payload.removeWhere((key, value) {
      if(value is String){
        return value == '';
      }else if (value is List){
        return value.isEmpty;
      }
      return false;
    });

    final company = await companyCubit.createCompany(payload: payload);

    if(company == null){
      return;
    }
    if(context.mounted && widget.returnCompany) {
      pop(context, company);
    }



  }


  @override
  void dispose() {
    super.dispose();
  }



}