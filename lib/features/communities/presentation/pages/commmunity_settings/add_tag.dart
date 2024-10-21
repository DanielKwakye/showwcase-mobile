import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_thread_tag.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';


class CommunityAddTag extends StatefulWidget {
  final CommunityModel? communityModel;
  final List<CommunityThreadTagsModel>? communityTags;
  const CommunityAddTag({super.key, this.communityModel, this.communityTags});

  @override
  State<CommunityAddTag> createState() => _CommunityAddTagState();
}

class _CommunityAddTagState extends State<CommunityAddTag> {

  late CommunityAdminCubit communityAdminCubit;
  late final TextEditingController _tagName;
  late List<CommunityThreadTagsModel> communityTags ;
  late ValueNotifier<String> tagColor  ;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    communityTags = widget.communityTags ?? [];
    tagColor = ValueNotifier('#999999');
    _tagName = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        elevation: 0.0,
        title: Text(
          'Add Tag',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: 16.0),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return value
                  ? const Center(
                  child: Row(
                    children: [
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(kAppBlue),
                            strokeWidth: 1,
                          )),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ))
                  : TextButton(
                  onPressed: () {
                    var isValidated = _formKey.currentState!.validate();
                    if (isValidated) {
                      communityTags = [...communityTags, CommunityThreadTagsModel(name: _tagName.text, color: tagColor.value)];

                      //communityTags.add(CommunityThreadTagsModel(name: _tagName.text, color: tagColor.value));
                      communityAdminCubit.updateFeedsTag(communityTags: communityTags, communityId: widget.communityModel!.id!,);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: kAppBlue,
                        fontSize: defaultFontSize,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ));
            },
          ),
        ],
      ),
      body: BlocListener<CommunityAdminCubit, CommunityAdminState>(
        listener: (context, state) {
          if (state is UpdateFeedsTagsLoading) {
            _isLoading.value = true;
          }
          if (state is UpdateFeedsTagsSuccess) {
            _isLoading.value = false;
            communityAdminCubit.fetchCommunityTags(slug: widget.communityModel!.slug!);
            context.showSnackBar('Tag created successfully');
          }
          if (state is UpdateFeedsTagsError) {
            _isLoading.value = false;
            context.showSnackBar(state.apiError.errorDescription.toString(),
                appearance: Appearance.error);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomTextFieldWidget(
                label: 'Tags Name',
                controller: _tagName,
                placeHolder: '',
                validator: (String? value) {
                  if (value == null || value == '') {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Text('Edit Color', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),
              ValueListenableBuilder(
                valueListenable: tagColor,
                builder: (BuildContext context, String value, Widget? child) {
                  return Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#999999';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xff999999),
                                border: Border.all(color: tagColor.value == '#999999' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#51D388';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xff51D388),
                                border: Border.all(color: tagColor.value == '#51D388' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#73B7EA';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xff73B7EA),
                                border: Border.all(color: tagColor.value == '#73B7EA' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#F2C94C';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffF2C94C),
                                border: Border.all(color: tagColor.value == '#F2C94C' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#F2994A';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffF2994A),
                                border: Border.all(color: tagColor.value == '#F2994A' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#EB5757';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xff9B51E0),
                                border: Border.all(color: tagColor.value == '#EB5757' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            tagColor.value = '#A31867';
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffA31867),
                                border: Border.all(color: tagColor.value == '#A31867' ?  kAppBlue : Colors.transparent, width: 4)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) ;
                },

              )
            ],
          ),
        ),
      ),
    );
  }
}
