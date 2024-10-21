import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

import '../../../../core/network/api_config.dart';

class ShowSkillsTechsBlockWidget extends StatelessWidget {

  final ShowBlockModel block;
  final ShowModel show;

  const ShowSkillsTechsBlockWidget({
    required this.block,
    required this.show,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(block.skillsTechsBlock?.stacks == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Stacks", style: theme.textTheme.titleMedium,),
        const SizedBox(height: 10,),
        const CustomBorderWidget(),
        const SizedBox(height: 10,),

        if(block.skillsTechsBlock?.stacks != null) ...{
          ...block.skillsTechsBlock!.stacks!.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(entry.key, style: theme.textTheme.titleSmall,),
                ...entry.value.map((stackItem) {

                  final String? iconUrl = stackItem.icon != null ?"${ApiConfig.stackIconsUrl}/${stackItem.icon}" : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [

                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: iconUrl != null ?
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: iconUrl,
                              errorWidget: (context, url, error) =>
                                  _fallbackIcon(context, entry.key),
                              placeholder: (ctx, url) =>
                                  _fallbackIcon(context, entry.key),
                              cacheKey: iconUrl,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(kTechStackPlaceHolderIcon),
                        ),
                        const SizedBox(width: 15,),
                        Text(stackItem.name ?? "", style: theme.textTheme.bodyText2,),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10,),
              ],
            );
          })
        }


      ],
    );
  }

  Widget _fallbackIcon(BuildContext context, String name){
    final theme = Theme.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // border: Border.all(color: theme.colorScheme.outline),
        // borderRadius: BorderRadius.circular(5),
          color: theme.colorScheme.outline
      ),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(top: 0),
      child: Center(child: Text(getInitials(name.toUpperCase()), style: TextStyle(color: Theme.of(context).colorScheme.onBackground),)),

      // ,
    );
  }

}
