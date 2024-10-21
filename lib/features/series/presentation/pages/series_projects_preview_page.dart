import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_cubit.dart';
import 'package:showwcase_v3/features/series/data/bloc/series_enums.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_cubit.dart';
import 'package:showwcase_v3/features/shows/data/bloc/show_preview_state.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/shows/presentation/pages/show_preview_page.dart';

class SeriesProjectsPreviewPage extends StatefulWidget {

  final SeriesModel seriesModel;
  final int initialProjectIndex;
  const SeriesProjectsPreviewPage({Key? key, required this.seriesModel, this.initialProjectIndex = 0}) : super(key: key);

  @override
  SeriesProjectsPreviewPageController createState() => SeriesProjectsPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SeriesProjectsPreviewPageView extends WidgetView<SeriesProjectsPreviewPage, SeriesProjectsPreviewPageController> {

  const _SeriesProjectsPreviewPageView(SeriesProjectsPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return ShowPreviewPage(
      showModel: state.selectedProject,
      hideRecommendedShows: true,
      actions: [

        BlocSelector<ShowPreviewCubit, ShowPreviewState, ShowModel?>(
          selector: (showPreviewState) {
            return showPreviewState.showPreviews.firstWhereOrNull((element) => element.id == state.selectedProject.id);
          },
          builder: (context, ShowModel? reactiveProject) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:  Container(
                width: 35,
                height: 35,
                color:  (reactiveProject?.hasCompleted ?? state.selectedProject.hasCompleted ?? false) ? kAppGreen : kAppBlue,
                child: IconButton(
                  icon: const Icon(Icons.check, size: 18, color: kAppWhite,),
                  onPressed: () {
                    showMarkAsCompleteDialog(context);
                  },
                ),
              ),
            );
          },
        )
        ,
        const SizedBox(width: 10,),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child:  Container(
            width: 35,
            height: 35,
            color: theme.colorScheme.outline,
            child: IconButton(
              icon: Icon(Icons.list, size: 18, color: theme.colorScheme.onBackground,),
              onPressed: () {
                showSeriesProjectList(context);
              },
            ),
          ),
        ),
        const SizedBox(width: 10,),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child:  Container(
            width: 35,
            height: 35,
            color: theme.colorScheme.outline,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 12, color: theme.colorScheme.onBackground,),
              onPressed: () {
                state.goToPreviousProject();
              },
            ),
          ),
        ),
        const SizedBox(width: 10,),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child:  Container(
            width: 35,
            height: 35,
            color: theme.colorScheme.outline,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 12, color: theme.colorScheme.onBackground,),
              onPressed: () {
                state.goToNextProject();
              },
            ),
          ),
        ),
        const SizedBox(width: 10,),


      ],
    );

  }

  void showMarkAsCompleteDialog(BuildContext context) {
    showConfirmDialog(context, onConfirmTapped: () {
        state.handleMarkProjectAsCompleted();
    }, title: "Mark this Show as completed");
  }

  void showSeriesProjectList(BuildContext context) {
    final theme = Theme.of(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final ch = SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          height: deviceHeight * 0.7,
          child: Column(
             children: [

               Expanded(child: ListView.separated(

                   shrinkWrap: true,
                   itemBuilder: (_, i){

                     final ShowModel project = widget.seriesModel.projects![i];

                     return ListTile(
                       title: Text(project.title ?? '', style: theme.textTheme.bodyMedium, ),
                       leading: Icon(Icons.menu_book, size: 20, color: theme.colorScheme.onBackground,),
                       minLeadingWidth: 0,
                       trailing:( project.hasCompleted == true)  ?  Container(
                         width: 13,
                         height: 13,
                         decoration: BoxDecoration(
                             color: Colors.green,
                             borderRadius: BorderRadius.circular(100)
                         ),
                         child:  const Icon(Icons.check, size: 10, color: kAppWhite,),
                       ) : null ,
                       onTap: () {
                         state.switchProject(project);
                         pop(context);
                       },
                     );

                   }, separatorBuilder: (_, __) {
                 return const CustomBorderWidget();
               }, itemCount: widget.seriesModel.projects!.length
               ))
             ],
          ),
        )
    );
    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SeriesProjectsPreviewPageController extends State<SeriesProjectsPreviewPage> {

  late ShowModel selectedProject;
  late ShowPreviewCubit showPreviewCubit;
  late SeriesCubit seriesCubit;

  @override
  Widget build(BuildContext context) => _SeriesProjectsPreviewPageView(this);

  @override
  void initState() {
    showPreviewCubit = context.read<ShowPreviewCubit>();
    seriesCubit = context.read<SeriesCubit>();
    selectedProject = widget.seriesModel.projects![widget.initialProjectIndex];

    seriesCubit.stream.listen((event) {
      if(event.status == SeriesStatus.markProjectAsCompleteSuccessful) {
        context.showSnackBar("Good job. This Show has been recorded as completed");
      }
    });
    super.initState();
  }

  void switchProject(ShowModel newProject) async {

    showPreviewCubit.setShowPreview(show: newProject, updateIfExist: false);
    final either = await showPreviewCubit.fetchShowsPreview(showId: newProject.id!);
    if(either.isLeft()){
      final error = either.asLeft();
      if(mounted) {
        context.showSnackBar(error);
      }
      return;
    }

    final projectPreview = either.asRight();
    setState(() {
      selectedProject = projectPreview;
    });

  }

  void goToNextProject() {
    final int? currentProjectIndex = widget.seriesModel.projects?.indexWhere((element) => element.id == selectedProject.id);
    if((currentProjectIndex ?? -1) < 0 ) {
      return;
    }
    final lastProjectIndex =  (widget.seriesModel.projects?.length ?? 0) - 1;
    final nextProjectIndex = (currentProjectIndex ?? -1) + 1;

    if(nextProjectIndex > lastProjectIndex) {
      context.showSnackBar("There are no more Shows after this");
      return;
    }

    final nextProject = widget.seriesModel.projects![nextProjectIndex];
    switchProject(nextProject);

  }

  void goToPreviousProject( ) {

    final int? currentProjectIndex = widget.seriesModel.projects?.indexWhere((element) => element.id == selectedProject.id);
    if((currentProjectIndex ?? -1) < 0 ) {
      return;
    }
    final nextProjectIndex = (currentProjectIndex ?? -1) - 1;
    if(nextProjectIndex < 0) {
      if((currentProjectIndex ?? -1) == 0) {
        context.showSnackBar("You're currently on the first Show under this Series");
        return;
      }
      context.showSnackBar("There are no more Shows before this Show");
      return;
    }

    final nextProject = widget.seriesModel.projects![nextProjectIndex];
    switchProject(nextProject);

  }

  void handleMarkProjectAsCompleted() {
    final showPreviews = showPreviewCubit.state.showPreviews;
    // get the most updated show data
    final latest = showPreviews.where((element) => element.id == selectedProject.id).firstOrNull;
    if(latest?.content == null && (latest?.markdown ?? '').isNullOrEmpty()) {
      return;
    }
    seriesCubit.markSeriesProjectAsComplete(seriesModel: widget.seriesModel, showModel: latest!);

  }

  @override
  void dispose() {
    super.dispose();
  }

}