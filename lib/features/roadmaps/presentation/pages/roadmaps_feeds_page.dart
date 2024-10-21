import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_enums.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_state.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/presentation/widgets/roadmap_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_gradient_text_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';

class RoadmapsFeedsPage extends StatefulWidget {

  const RoadmapsFeedsPage({Key? key}) : super(key: key);

  @override
  RoadmapsHomePageController createState() => RoadmapsHomePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapsHomePageView extends WidgetView<RoadmapsFeedsPage, RoadmapsHomePageController> {

  const _RoadmapsHomePageView(RoadmapsHomePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: BlocBuilder<RoadmapCubit, RoadmapState>(
          buildWhen: (_, next){
            return next.status == RoadmapStatus.fetchRoadmapsFailed
                || next.status == RoadmapStatus.fetchRoadmapsSuccessful;
          },
          builder: (context, roadmapState) {
            return Padding(
              padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
              child: SeparatedColumn(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 7,);
                },
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Text(
                            'Roadmaps',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: defaultFontSize + 4),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            kLogoSvg,
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onBackground, BlendMode.srcIn),
                            width: 19,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const CustomGradientTextWidget("[academy]",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: defaultFontSize,
                                  color: Colors.white),
                              gradient: LinearGradient(colors: [
                                Color(0xff6F77FF),
                                Color(0xff3BD3FF),
                              ])),
                        ],
                      ),
                      Text(
                        'Roadmaps to help you level up as a developer.',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 5,),
                    ],
                  ),

                  if(roadmapState.status == RoadmapStatus.fetchRoadmapsInProgress) ... {
                    const Center(child: CustomAdaptiveCircularIndicator(),)
                  }
                  else if(roadmapState.status == RoadmapStatus.fetchRoadmapsFailed) ... {
                    const CustomNoConnectionWidget(title: "Restore connection and swipe to refresh ...",)
                  }
                  else if(roadmapState.status == RoadmapStatus.fetchRoadmapsSuccessful) ... {
                      ...roadmapState.roadmaps.map((item) {
                        return RoadmapItemWidget(roadmap: item);
                      })
                    }
                ],
              ),
            );
          },
        ),
      ),
    );



  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapsHomePageController extends State<RoadmapsFeedsPage> {

  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, RoadmapModel> pagingController = PagingController(firstPageKey: 0);
  late RoadmapCubit roadmapCubit;

  @override
  Widget build(BuildContext context) => _RoadmapsHomePageView(this);

  @override
  void initState() {
    roadmapCubit = context.read<RoadmapCubit>();
    fetchRoadmaps();
    super.initState();
  }


  void fetchRoadmaps() async {
    roadmapCubit.fetchRoadmaps();
  }


  @override
  void dispose() {
    super.dispose();
  }

}