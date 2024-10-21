import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/fallback_icon_widget.dart';

class CompanyItemWidget extends StatelessWidget {

  final CompanyModel company;
  const CompanyItemWidget({
    required this.company,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // context.push(context.generateRoutePath(subLocation: companyPreview), extra: company);
      },
      child: Container(
        decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? kAppBlack : kAppWhite
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 16, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: Uri.encodeFull(company.logo ?? ''),
                    errorWidget: (context, url, error) =>
                        FallBackIconWidget(name: company.name ?? 'Company'),
                    placeholder: (ctx, url) =>
                        FallBackIconWidget(name: company.name ?? 'Company'),
                    cacheKey: company.logo ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                // ,
              ),

              const SizedBox(width: 15,),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(
                    company.name ?? '',
                    style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600, fontSize: 16, ),
                  ),
                  const SizedBox(height: 7,),
                  if(company.oneLiner != null) ... {
                    Text(
                      company.oneLiner ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 5,),
                  },
                  Row(
                    children: [

                      if(company.location != null) ... {
                        Expanded(flex: 3,child: Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: theme.colorScheme.onPrimary, size: 14,),
                            const SizedBox(width: 5,),
                            Expanded(child: Text(company.location?.capitalize() ?? '',
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              style: TextStyle(color: theme.colorScheme.onPrimary,
                              ),))
                          ],
                        ),),
                        const SizedBox(width: 20,),
                      },


                      if(company.totalJobs != null) ... {
                        Expanded(flex: 2,child:  Row(
                          children: [
                            Icon(Icons.work, color: theme.colorScheme.onPrimary, size: 14,),
                            const SizedBox(width: 5,),
                            Expanded(child: Text("${company.totalJobs} jobs".capitalize(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: theme.colorScheme.onPrimary),))
                          ],
                        ),),
                      }

                    ],
                  )

                ],
              ))
            ],
          ),
        ),
      ),
    );
  }


}
