import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_readers_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/features/users/presentation/widgets/shared/users_horizontal_overlapping_list_widget.dart';

import '../../../../app/routing/route_constants.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/theme.dart';
import '../../../../core/utils/widget_view.dart';
import '../../../roadmaps/data/bloc/roadmap_cubit.dart';
import '../../../roadmaps/data/bloc/roadmap_state.dart';
import '../../../shared/presentation/widgets/custom_button_widget.dart';

class RoadmapItemWidget extends StatefulWidget {

  final RoadmapModel roadmap;
  const RoadmapItemWidget({
    required this.roadmap,
    Key? key}) : super(key: key);

  @override
  RoadmapItemWidgetController createState() => RoadmapItemWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _RoadmapItemWidgetView extends WidgetView<RoadmapItemWidget, RoadmapItemWidgetController> {

  const _RoadmapItemWidgetView(RoadmapItemWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    Color color = HexColor.fromHex(widget.roadmap.color ?? "#000000");

    return GestureDetector(
      onTap: (){
        if(widget.roadmap.id == null) return;
        context.push(context.generateRoutePath(subLocation: roadmapsPreviewPage), extra: widget.roadmap);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        // width: width(context) ,
        // height: 180, // this items will be auto sized
        padding: const EdgeInsets.all(15),
        // margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient:   LinearGradient(colors: [
              color,
              const Color(0xff202021),
            ])),
        child: SeparatedColumn(
          separatorBuilder: (_,__){
            return const SizedBox(height: 10,);
          },
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '${widget.roadmap.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: defaultFontSize + 2),
            ),
            Text(
              '${widget.roadmap.description}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500,color: Colors.white),
              maxLines: widget.roadmap.id == null ? null : 3,
              overflow: widget.roadmap.id == null ? null : TextOverflow.ellipsis,
            ),
            BlocSelector<RoadmapCubit, RoadmapState, RoadmapReadersModel?>(
              selector: (roadmapState) {
                return roadmapState.roadmapReaders[widget.roadmap.id];
              },
              builder: (context, readerModel) {
                    final readers = readerModel?.readers ?? <UserModel>[];
                    final numberOfReaders = readerModel?.numberOfReaders;
                    if(readers.isNotEmpty) {
                      return SeparatedColumn(
                        mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 5,);
                         },
                         children: [
                           UsersHorizontalOverlappingListWidget(users: readers,),
                           if(numberOfReaders != null && numberOfReaders > 0) ... {
                              Text( "$numberOfReaders learning", style: const TextStyle( fontSize: 13, fontWeight: FontWeight.w500,color: Colors.white),)
                          }

                         ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
            ),

            if(widget.roadmap.comingSoon)...[
              const SizedBox(
                height: 10,
              ),
              CustomButtonWidget(
                text: 'Coming Soon',
                outlineColor: Colors.transparent,
                onPressed: () {},
                backgroundColor: Colors.white,
                textColor: kAppBlue,
              )
            ] 
          ],
        ),
      ),
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class RoadmapItemWidgetController extends State<RoadmapItemWidget> {

  late RoadmapCubit roadmapCubit;
  @override
  Widget build(BuildContext context) => _RoadmapItemWidgetView(this);

  @override
  void initState() {
    super.initState();
    roadmapCubit = context.read<RoadmapCubit>();
    if(widget.roadmap.id != null) {
      roadmapCubit.fetchRoadmapReadingList(roadmapId: widget.roadmap.id!);
    }

  }


  @override
  void dispose() {
    super.dispose();
  }

}