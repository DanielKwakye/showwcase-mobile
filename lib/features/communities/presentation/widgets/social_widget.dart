import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/models/community_link_model.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';


class SocialWidget extends StatefulWidget {
  final List<SharedSocialLinkIconModel> socialList ;
  final CommunityLinkModel link ;
  final ValueChanged<String> onChanged ;
  final ValueChanged<String> onSelectedSocial ;
  final ValueChanged<void> onDeleted ;
  const SocialWidget({Key? key, required this.socialList, required this.link, required this.onChanged, required this.onDeleted, required this.onSelectedSocial}) : super(key: key);

  @override
  State<SocialWidget> createState() => _SocialWidgetState();
}

class _SocialWidgetState extends State<SocialWidget> {
  String? selectedLink ;
  List<String?> socialLists = [];
  List<String?> socialImageLabel = [];


  @override
  void initState() {
   socialLists = widget.socialList.map((e) => e.name).toList();
   socialImageLabel = widget.socialList.map((e) => e.label).toList();
   selectedLink = widget.socialList.firstWhere((element) => element.name!.toLowerCase() == widget.link.name!.toLowerCase()).name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
     // key: UniqueKey(),
      width: width(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String?>(
                    key: widget.key,
                    value: selectedLink,
                    isExpanded: true,
                    elevation: 3,
                    items: socialLists
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.network(Uri.encodeFull(ApiConfig.socialImageUrl(value!) ?? ''),
                            colorBlendMode:
                            BlendMode
                                .difference,
                            width: 20,
                            placeholderBuilder:
                                (BuildContext
                            context) =>
                            const CircularProgressIndicator
                                .adaptive(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            socialImageLabel[socialLists.indexOf(value)]!,
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(
                            () {
                              selectedLink = newValue!;
                        },

                      );
                      widget.onSelectedSocial(newValue!);
                    },
                    underline: const SizedBox(),
                    hint: Text(
                      '  ',
                      style: TextStyle(
                          color: theme
                              .colorScheme.onBackground),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  widget.onDeleted(0);
                },
                  child: SvgPicture.asset('assets/svg/delete.svg',height: 22)),
            ],
          ),
          const SizedBox(height: 20,),
          CustomTextFieldWidget(
            label: '',
           // key: UniqueKey(),
            initialValue: widget.link.value,
            placeHolder: 'eg. https://example.com',
            onChange: (String? value){
              widget.onChanged(value!);
            },
            validator: (String? value) {
              if (value == null || value == '') {
                return 'This field is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}
