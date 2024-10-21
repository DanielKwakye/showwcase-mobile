import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class PagePreviewLoadingPage extends StatelessWidget {
  const PagePreviewLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomInnerPageSliverAppBar(
            pageTitle: '',
            pinned: true,
            backgroundColor: theme(context).colorScheme.primary,
          ),
          const SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
