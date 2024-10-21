import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_type_model.dart';
import 'package:showwcase_v3/features/jobs/presentation/widgets/job_filter_item_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

class JobFilterPanelWidget extends StatelessWidget {
  const JobFilterPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => _onFiltersButtonTapped(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: theme.brightness == Brightness.light ? Colors.white : theme.colorScheme.background,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    label: Text(
                      "Add Filters",
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      _onFiltersButtonTapped(context);
                    },
                    icon: Icon(
                      Icons.add,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  SvgPicture.asset(
                    kFilterIcon,
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.onBackground,
                        BlendMode.srcIn),
                  )
                  // Icon(Icons.filter_alt_sharp, color: theme.colorScheme.onBackground, size: 18,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoTextField(
                readOnly: true,
                padding: const EdgeInsets.only(
                    left: 15, top: 10, bottom: 10),
                placeholder: 'Search for Job Skills...',
                onTap: () async {
                  // await changeScreenWithConstructor(context, const JobPositionsPage());
                  context.push(context.generateRoutePath(subLocation: jobsPositionPage));
                  // state._jobsCubit.fetchNewJobs(replaceFirstPage: true, updateFilters: true);
                },
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? kLightOnPrimaryColor.withOpacity(0.1)
                      : kDarkOutlineColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: CupertinoTextField(
            //     readOnly: true,
            //     padding: const EdgeInsets.only(
            //         left: 15, top: 10, bottom: 10),
            //     placeholder: 'Search Job Location...',
            //     onTap: () async {
            //       // open
            //       context.push(context.generateRoutePath(subLocation: jobsLocationPage));
            //       // await changeScreenWithConstructor(context, const JobLocationsPage());
            //       // state._jobsCubit.fetchNewJobs(replaceFirstPage: true, updateFilters: true);
            //     },
            //     decoration: BoxDecoration(
            //       color: theme.brightness == Brightness.light
            //           ? kLightOnPrimaryColor.withOpacity(0.1)
            //           : kDarkOutlineColor.withOpacity(0.5),
            //       borderRadius: BorderRadius.circular(4),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            BlocBuilder<JobsCubit, JobsState>(
              builder: (context, jobsState) {
                final salary = jobsState.salaryFilter;
                final positions = jobsState.jobFilters?.positions
                    ?.where((element) => element['selected'] == true);
                final locations = jobsState.jobFilters?.locations
                    ?.where((element) => element['selected'] == true);
                final types = jobsState.jobFilters?.types
                    ?.where((element) => element['selected'] == true);
                final stacks = jobsState.jobFilters?.stacks
                    ?.where((element) => element['selected'] == true);

                final selectedCount = (positions?.length ?? 0) +
                    (locations?.length ?? 0) +
                    (types?.length ?? 0) +
                    (stacks?.length ?? 0);

                if (selectedCount <= 0 && salary == 0.0) {
                  return const SizedBox.shrink();
                }

                return SizedBox(
                  width: mediaQuery.size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<JobsCubit>().clearAllJobFilters();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(
                                right: 5, left: 20),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                BorderRadius.circular(4),
                                border: Border.all(
                                    color: theme
                                        .colorScheme.onPrimary)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_alt_off_outlined,
                                  size: 12,
                                  color:
                                  theme.colorScheme.onPrimary,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Clear filters',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// salary filter
                        if (salary != 0.0) ...{
                          GestureDetector(
                            onTap: () {
                              // remove filter
                              context.read<JobsCubit>().removeSalaryFilter(refreshPage: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              margin:
                              const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color:
                                  kAppBlue.withOpacity(0.3),
                                  borderRadius:
                                  BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Text(
                                    "\$ ${salary.toStringAsFixed(0)}K",
                                    style: const TextStyle(
                                        color: kAppBlue),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.close,
                                    size: 12,
                                    color: kAppBlue,
                                  )
                                ],
                              ),
                            ),
                          )
                        },

                        /// positions
                        if (positions != null &&
                            positions.isNotEmpty) ...{
                          ...positions
                              .map((position) => GestureDetector(
                            onTap: () {
                              // remove filter
                              context.read<JobsCubit>().selectDeselectJobPositionsFilter({
                                "filter": position["filter"],
                                "selected": false
                              });
                            },
                            child: JobFilterItemWidget(filterName: position["filter"]),
                          ))
                        },

                        /// locations
                        if (locations != null &&
                            locations.isNotEmpty) ...{
                          ...locations
                              .map((position) => GestureDetector(
                            onTap: () {
                              // remove filter
                              context.read<JobsCubit>().selectDeselectJobLocationFilter({
                                "filter": position["filter"],
                                "selected": false
                              });
                            },
                            child: JobFilterItemWidget(
                                filterName:
                                position["filter"]),
                          ))
                        },

                        /// job types
                        if (types != null &&
                            types.isNotEmpty) ...{
                          ...types.map((type) => GestureDetector(
                            onTap: () {
                              // remove filter
                              context.read<JobsCubit>().selectDeselectJobTypesFilter({
                                "filter": type["filter"] as JobTypeModel,
                                "selected": false
                              });
                            },
                            child: JobFilterItemWidget(
                                filterName: (type["filter"]
                                as JobTypeModel)
                                    .label ??
                                    ''),
                          ))
                        },

                        /// job stacks
                        if (stacks != null &&
                            stacks.isNotEmpty) ...{
                          ...stacks.map((stack) =>
                              GestureDetector(
                                onTap: () {
                                  // remove filter
                                  context.read<JobsCubit>().selectDeselectJobStacksFilter({
                                    "filter": stack["filter"] as UserStackModel,
                                    "selected": false
                                  });
                                },
                                child: JobFilterItemWidget(
                                    filterName: (stack["filter"]
                                    as UserStackModel)
                                        .name ??
                                        ""),
                              ))
                        },
                      ],
                    ),
                  ),
                );
              },
              buildWhen: (_, next) {
                return next.status == JobStatus.jobsFilterToggled;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onFiltersButtonTapped(BuildContext context) {
    context.push(context.generateRoutePath(subLocation: jobFiltersPage));
  }
}
