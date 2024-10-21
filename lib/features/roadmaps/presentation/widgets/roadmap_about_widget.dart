import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_cubit.dart';
import 'package:showwcase_v3/features/roadmaps/data/bloc/roadmap_preview_state.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';

class RoadmapAboutWidget extends StatefulWidget {
  final RoadmapModel roadmapModel;

  const RoadmapAboutWidget({
    super.key,
    required this.roadmapModel,
  });

  @override
  State<RoadmapAboutWidget> createState() => _RoadmapAboutWidgetState();
}

class _RoadmapAboutWidgetState extends State<RoadmapAboutWidget> {
  late RoadmapModel roadmapModel;
  late RoadmapPreviewCubit roadmapPreviewCubit;

  @override
  void initState() {
    roadmapModel = widget.roadmapModel;
    roadmapPreviewCubit = context.read<RoadmapPreviewCubit>();
    roadmapPreviewCubit.fetchRoadmapPreview(roadmapId: widget.roadmapModel.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<RoadmapPreviewCubit, RoadmapPreviewState,
        RoadmapModel>(
      bloc: roadmapPreviewCubit,
      selector: (state) {
        return state.roadmapPreviews.firstWhere(
          (element) => element.id == roadmapModel.id,
        );
      },
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      splitReadingStat(
                          state.readingStats?.text ?? '', true),
                      style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      splitReadingStat(
                          state.readingStats?.text ?? '', false),
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    )
                  ],
                )),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roadmapModel.info?.language ?? 'English',
                      style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Other languages coming soon',
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    )
                  ],
                )),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roadmapModel.info?.difficulty ?? 'Beginner',
                      style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Level required to get started',
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    )
                  ],
                )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roadmapModel.info?.title ?? 'N/A',
                        style: TextStyle(
                            fontSize: 18,
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        roadmapModel.info?.description ?? 'N/A',
                        style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          state.info?.salary?.range ?? 'N/A',
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          roadmapModel.info?.career?.percentage ?? 'N/A',
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          roadmapModel.info?.salary?.label ?? 'N/A',
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          roadmapModel.info?.career?.label ?? 'N/A',
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          roadmapModel.info?.jobs?.total ?? 'N/A',
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          roadmapModel.info?.company?.total ?? 'N/A',
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          roadmapModel.info?.jobs?.label ?? 'N/A',
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          roadmapModel.info?.company?.label ?? 'N/A',
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'source: https://www.ziprecruiter.com/Salaries/Web-Developer-Salary',
                    style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Skills you will master',
              style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...(roadmapModel.info?.skills ?? [])
                    .map((languageName) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              //color: backgroundColor,
                              border:
                                  Border.all(color: theme.colorScheme.outline)),
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, bottom: 10, right: 14),
                          child: Text(
                            languageName,
                            style: TextStyle(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.w700,
                                fontSize: (defaultFontSize - 2)),
                          ),
                        ))
                    .toList(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomMarkdownWidget(markdown: roadmapModel.about ?? '')
          ],
        );
      },
    );
  }

  String splitReadingStat(String inputString, bool returnWeek) {
    // Find the index of the opening parenthesis
    int openingParenthesisIndex = inputString.indexOf('(');

    // If the opening parenthesis is found
    if (openingParenthesisIndex != -1) {
      // Extract the substring before the opening parenthesis
      String result = inputString.substring(0, openingParenthesisIndex).trim();
      if (returnWeek) {
        return result;
      }

      // Extract the substring inside the parentheses as hours
      int closingParenthesisIndex = inputString.indexOf(')');
      String hours = inputString
          .substring(openingParenthesisIndex + 1, closingParenthesisIndex)
          .trim();

      return hours;
    } else {
      // If the opening parenthesis is not found, return the input string as is
      return inputString;
    }
  }
}
