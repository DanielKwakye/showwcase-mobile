import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_fallback_icon_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_see_more_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_experience_model.dart';

class UserExperienceWidget extends StatefulWidget {

  final UserExperienceModel experienceModel;
  final Function(UserExperienceModel)? onEditTapped;
  final bool? showEditButton;
  const UserExperienceWidget({Key? key, required this.experienceModel, this.onEditTapped,  this.showEditButton = true}) : super(key: key);

  @override
  UserExperienceWidgetController createState() => UserExperienceWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _UserExperienceWidgetView extends WidgetView<UserExperienceWidget, UserExperienceWidgetController> {

  const _UserExperienceWidgetView(UserExperienceWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final icon = widget.experienceModel.companyLogo != null
        ? getCompanyLogo(widget.experienceModel.companyLogo) : '${ApiConfig.companyAssetUrl}/default-profile-picture/company_default.svg';

    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 0),
                child: CustomNetworkImageWidget(imageUrl: icon,)

            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: SeparatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separatorBuilder: (BuildContext context, int index) {
                  return
                    const SizedBox(
                      height: 7,
                    );
                },
                children: <Widget>[
                  Text(
                    widget.experienceModel.title ?? '', style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: defaultFontSize),
                  ),

                  Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if(!widget.experienceModel.companyName.isNullOrEmpty()) ... [
                        Text(widget.experienceModel.companyName ?? '',
                          style: const TextStyle(
                              color: kAppBlue, fontSize: 12
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const CustomDotWidget(),
                        const SizedBox(
                          width: 10,
                        ),
                      ],

                      if (widget.experienceModel.startDate != null) ... {
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getFormattedDateWithIntl(widget.experienceModel.startDate!),
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimary, fontSize: 12),
                            ),
                            if (widget.experienceModel.endDate != null) ...[
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "-",
                                style: TextStyle(
                                    color:
                                    theme.colorScheme.onPrimary, fontSize: 12),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              if (widget.experienceModel.current != null &&
                                  widget.experienceModel.current!) ...{
                                Text(
                                  'Present',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary, fontSize: 12),
                                )
                              } else if (widget.experienceModel.startDate ==
                                  widget.experienceModel.endDate) ...{
                                Text(
                                  'Present',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary, fontSize: 12),
                                )
                              } else ...{
                                Text(
                                  getFormattedDateWithIntl(
                                      widget.experienceModel.endDate!),
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary, fontSize: 12),
                                ),
                              }
                            ]
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      }


                    ],
                  ),

                  // description here
                  if(widget.experienceModel.description != '' && widget.experienceModel.description != null) ... {
                    CustomSeeMoreWidget(text: widget.experienceModel.description ?? '',),

                  },


                  Wrap(
                    runSpacing: 8,
                    children: List.generate(
                        widget.experienceModel.stacks?.length ?? 0, (index) {
                      String? iconUrl;
                      if (widget.experienceModel.stacks![index].stack?.icon != null) {
                        iconUrl =
                        "${ApiConfig.stackIconsUrl}/${widget.experienceModel.stacks![index].stack!.icon!}";
                      }
                      return IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(4),
                              color: theme.brightness ==
                                  Brightness.dark
                                  ? const Color(0xff2c2c2c)
                                  : const Color(0xffF7F7F7)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(2),
                                  child: iconUrl != null
                                      ? CachedNetworkImage(
                                    imageUrl: iconUrl,
                                    errorWidget: (context,
                                        url, error) =>
                                    const CustomFallbackIconWidget( name: '',),
                                    placeholder: (ctx, url) => const CustomFallbackIconWidget( name: '',),
                                    cacheKey: iconUrl,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                      kTechStackPlaceHolderIcon),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                widget.experienceModel.stacks?[index].stack?.name ?? '',
                                style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )
                ],
              )),

          /// Edit action
         if(widget.showEditButton!) ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child:  GestureDetector(
              onTap: () => widget.onEditTapped?.call(widget.experienceModel),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  //color: backgroundColor,
                    color: theme.colorScheme.outline,
                    border: Border.all(color: theme.colorScheme.outline)
                ),
                // padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
                child: Icon(Icons.edit, size: 14, color: theme.colorScheme.onBackground,),
              ),
            ),
          ),
        ],
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class UserExperienceWidgetController extends State<UserExperienceWidget> {


  @override
  Widget build(BuildContext context) => _UserExperienceWidgetView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}