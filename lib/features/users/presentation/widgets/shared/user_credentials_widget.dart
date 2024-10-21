import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_dot_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_certification_model.dart';

class UserCredentialWidget extends StatefulWidget {

  final UserCertificationModel userCertificationModel;
  final Function(UserCertificationModel)? onEditTapped;
  final bool? showEditButton;
  const UserCredentialWidget({Key? key, required this.userCertificationModel, this.onEditTapped, this.showEditButton = true}) : super(key: key);

  @override
  UserCredentialWidgetController createState() => UserCredentialWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _UserCredentialWidgetView extends WidgetView<UserCredentialWidget, UserCredentialWidgetController> {

  const _UserCredentialWidgetView(UserCredentialWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final icon = widget.userCertificationModel.organizationLogo != null
        ? getCompanyLogo(widget.userCertificationModel.organizationLogo) : '${ApiConfig.companyAssetUrl}/default-profile-picture/company_default.svg';

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
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline
                ),
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Center(
                      child: Text(getInitials(widget.userCertificationModel.organizationName ?? '')),
                    ),
                    CustomNetworkImageWidget(imageUrl: icon)
                  ],
                )

            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.userCertificationModel.title ?? '', style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: defaultFontSize),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if(!widget.userCertificationModel.organizationName.isNullOrEmpty()) ... [
                        Text(widget.userCertificationModel.organizationName ?? '',
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

                      if (widget.userCertificationModel.startDate != null) ... {
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getFormattedDateWithIntl(widget.userCertificationModel.startDate!),
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimary, fontSize: 12),
                            ),
                            if (widget.userCertificationModel.endDate != null) ...[
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
                              if (widget.userCertificationModel.current != null &&
                                  widget.userCertificationModel.current!) ...{
                                Text(
                                  'Present',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary, fontSize: 12),
                                )
                              } else if (widget.userCertificationModel.startDate ==
                                  widget.userCertificationModel.endDate) ...{
                                Text(
                                  'Present',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary, fontSize: 12),
                                )
                              } else ...{
                                Text(
                                  getFormattedDateWithIntl(
                                      widget.userCertificationModel.endDate!),
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

                  const SizedBox(
                    height: 10,
                  ),

                  /// Attachment  ----

                  if (widget.userCertificationModel.attachmentUrl != null &&
                      widget.userCertificationModel.attachmentUrl != "") ...{
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      // padding: const EdgeInsets.only(left: 10),
                      width: 120,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GestureDetector(
                            child: Hero(
                              tag: getProfileImage(widget.userCertificationModel.attachmentUrl!),
                              child: CachedNetworkImage(
                                imageUrl: Uri.encodeFull(
                                    getProfileImage(
                                        widget.userCertificationModel.attachmentUrl!)),
                                errorWidget:
                                    (context, url, error) =>
                                    Container(
                                      color: kAppBlue,
                                    ),
                                placeholder: (ctx, url) =>
                                    Container(
                                      color: kAppBlue,
                                    ),
                                cacheKey: Uri.encodeFull(
                                    getProfileImage(
                                        widget.userCertificationModel.attachmentUrl!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // onTap: () {
                            //   changeScreenWithConstructor(
                            //       context,
                            //       ProfileImagePreviewPage(
                            //           url: Uri.encodeFull(
                            //               getProfileImage(
                            //                   item.attachmentUrl!)),
                            //           tag: getProfileImage(
                            //               item.attachmentUrl!),
                            //           borderRadius: 0.0));
                            // }
                        ),
                      ),
                    ),
                  },
                  const SizedBox(
                    height: 10,
                  ),

                ],
              )),

          /// Edit action
         if(widget.showEditButton!) ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child:  GestureDetector(
              onTap: () => widget.onEditTapped?.call(widget.userCertificationModel),
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

class UserCredentialWidgetController extends State<UserCredentialWidget> {

  @override
  Widget build(BuildContext context) => _UserCredentialWidgetView(this);

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

}