import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_any_link_preview_widget.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';

class ShowGistBlockWidget extends StatelessWidget {

  final ShowBlockModel block;
  final ShowModel show;
  const ShowGistBlockWidget({
    required this.block,
    Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    if(block.gistBlock?.gistURL == null) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
         if(block.gistBlock?.fileName != null && block.gistBlock!.fileName!.isNotEmpty) ... {
           Text(block.gistBlock!.fileName!, style: theme.textTheme.bodyLarge,),
           const SizedBox()
         },
         CustomAnyLinkPreviewWidget(message: block.gistBlock?.gistURL ?? '', onTap: (link) {
           context.push(context.generateRoutePath(subLocation: showBrowserPage), extra: {
             "show": show,
             "url" : link
           });
         },)
      ],
    );
  }
}
