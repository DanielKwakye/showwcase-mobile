import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/active_communities.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/growing_communities.dart';
import 'package:showwcase_v3/features/communities/presentation/widgets/proposed_communities.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class DiscoverCommunitiesPage extends StatefulWidget {

  const DiscoverCommunitiesPage({Key? key}) : super(key: key);

  @override
  DiscoverCommunitiesController createState() => DiscoverCommunitiesController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _DiscoverCommunitiesView extends WidgetView<DiscoverCommunitiesPage, DiscoverCommunitiesController> {

   const _DiscoverCommunitiesView(DiscoverCommunitiesController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: state._scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const CustomInnerPageSliverAppBar(pageTitle: 'Showwcase Communities',)
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            children: const [
              ProposedCommunities(),
              ActiveCommunities(),
              GrowingCommunities(),
            ],
          ),
        ),
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class DiscoverCommunitiesController extends State<DiscoverCommunitiesPage> {
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) => _DiscoverCommunitiesView(this);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}