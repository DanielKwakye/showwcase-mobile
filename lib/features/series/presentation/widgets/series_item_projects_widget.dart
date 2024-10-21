import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/straight_line_painter.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';


class SeriesItemProjectsWidget extends StatefulWidget {

  final List<ShowModel> projects;
  final SeriesModel seriesItem;
  final int? limit;

  const SeriesItemProjectsWidget({
    required this.projects,
    required this.seriesItem,
    this.limit,
    Key? key}) : super(key: key);

  @override
  SeriesItemProjectsWidgetController createState() => SeriesItemProjectsWidgetController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SeriesItemProjectsWidgetView extends WidgetView<SeriesItemProjectsWidget, SeriesItemProjectsWidgetController> {

  const _SeriesItemProjectsWidgetView(SeriesItemProjectsWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final selectedProject = context.read<SeriesState>().sta
    final lineColor =  theme.brightness == Brightness.dark ? theme.colorScheme.outline : theme.colorScheme.onPrimary;
    // final lineColor =  theme.colorScheme.outline;

    return Column(
      children: <Widget>[
        ...widget.projects.map((project) {
          final currentIndex = widget.projects.indexOf(project);
          final nextIndex = currentIndex + 1;
          final lastIndex = widget.projects.length - 1;
          final previousIndex = currentIndex - 1;
          final isStartIndex = currentIndex == 0;
          final isLastIndex = currentIndex == lastIndex;
          final depth = (((project.depth ?? 0) + 0) * 15).toDouble();

          ShowModel? nextProject;
          if(nextIndex <= widget.projects.length - 1){
            nextProject = widget.projects[nextIndex];
          }
          double nextDepth = depth;
          if(nextProject != null){
             nextDepth = ((nextProject.depth ?? 0) * 15).toDouble();
          }

          // ShowsResponse? previousProject;
          // if(previousIndex >= 0){
          //   previousProject = widget.projects[previousIndex];
          // }
          // double previousDepth = depth;
          // if(previousProject != null){
          //   previousDepth = ((previousProject.depth ?? 0) * 15).toDouble();
          // }

          const boxWidth = 15.0;

          const bulletSize = 10.0;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {

              final initialIndex = widget.projects.indexWhere((element) => element.id == project.id);
              if(initialIndex < 0){
                return;
              }

              context.push(context.generateRoutePath(subLocation: seriesProjectsPreviewPage), extra: {
                "initialProjectIndex" : initialIndex,
                "series": widget.seriesItem
              });
              AnalyticsService.instance.sendEventSeriesStart(seriesModel: widget.seriesItem,pageName: seriesProjectsPreviewPage,containerName: 'toc ');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column( ///this column separates one item from the other with the bezier line
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        SizedBox(width: depth,),
                        SizedBox(
                          // color: Colors.yellow,
                          width:  boxWidth,
                          child: CustomPaint(
                            painter: StraightLinePaint(color: lineColor),
                            child: Container(
                                alignment: Alignment.center,
                                child: (( project.hasCompleted == true) || project.hasCompleted == true)  ? Container(
                                  width: ((project.hasCompleted == true) || project.hasCompleted == true) ? bulletSize * 1.2 : bulletSize * 1.5,
                                  height: ((project.hasCompleted == true) || project.hasCompleted == true) ? bulletSize * 1.2 : bulletSize * 1.5,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: ((project.hasCompleted == true) || project.hasCompleted == true) ? const Icon(Icons.check, size: ((bulletSize * 1.5) / 2), color: kAppWhite,) : const SizedBox.shrink(),
                                ) :
                                Container(
                                  width: bulletSize,
                                  height: bulletSize,
                                  decoration: BoxDecoration(
                                      color: lineColor,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                )
                            ),
                          ),

                        ),
                        const SizedBox(width: 10 ,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(project.title ?? '', style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),),
                            if(project.readingStats?.text != null) ... {
                              const SizedBox(height: 5,),
                              Text(project.readingStats!.text!, style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2),)
                            }
                          ],
                        )),
                        // const SizedBox(width: depthSize,),
                      ],
                    ),
                  ),
                  if(!isLastIndex)
                    SizedBox(
                      // color: Colors.red,
                      width: boxWidth + depth + nextDepth,
                      height: 20,
                      child: CustomPaint(
                        foregroundPainter: (nextDepth > depth) ? SShapeLinePaint(color: lineColor) : (nextDepth < depth) ? SReversShapeLinePaint(color: lineColor) : StraightLinePaint(color: lineColor),
                      ),
                    )
                ],
              ),
            ),
          );
        })
      ],
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SeriesItemProjectsWidgetController extends State<SeriesItemProjectsWidget> {
  @override
  Widget build(BuildContext context) => _SeriesItemProjectsWidgetView(this);
}



class SShapeLinePaint extends CustomPainter {

  final Color color;
  SShapeLinePaint({required this.color});

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..strokeWidth = 1
      ..color = color
      ..style = PaintingStyle.stroke;

    final startPoint = Offset(size.width * (0.25), 0.0);
    // final midPoint = Offset(size.width * (0.5), size.height * 0.5);
    final endPoint = Offset(size.width * (0.75), size.height);

    final controlPoint1 = Offset(size.width * (0.25), size.height * 0.9);
    final controlPoint2 = Offset(size.width * (0.75), size.height * 0.1);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);
    // path.lineTo(midPoint.dx, midPoint.dy);
    // path.arcToPoint(endPoint, radius: const Radius.circular(15), clockwise: false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

class SReversShapeLinePaint extends CustomPainter {

  final Color color;
  SReversShapeLinePaint({
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..strokeWidth = 1
      ..color = color
      ..style = PaintingStyle.stroke;

    final startPoint = Offset(size.width * (0.75), 0.0);
    // final midPoint = Offset(size.width * (0.5), size.height * 0.5);
    final endPoint = Offset(size.width * (0.25), size.height);

    final controlPoint1 = Offset(size.width * (0.75), size.height * 0.9);
    final controlPoint2 = Offset(size.width * (0.25), size.height * 0.1);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}