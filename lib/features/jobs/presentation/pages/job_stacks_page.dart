import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

class JobStacksPage extends StatefulWidget {

  const JobStacksPage({Key? key}) : super(key: key);

  @override
  State<JobStacksPage> createState() => _JobStacksPageState();
}

class _JobStacksPageState extends State<JobStacksPage> {

  @override
  void initState() {
    context.read<JobsCubit>().fetchJobsFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomInnerPageSliverAppBar(
            pageTitle: 'Stacks',
            pinned: true,
          ),
          BlocBuilder<JobsCubit, JobsState>(
            buildWhen: (_, next) {
              return next.status == JobStatus.jobsFiltersFetchedSuccessful
                  || next.status == JobStatus.jobsFiltersFetchError
                  || next.status == JobStatus.jobsFiltersFetching;
            },
            builder: (context, jobsState) {

                if(jobsState.status == JobStatus.jobsFiltersFetching) {
                return const SliverToBoxAdapter(child:   Center(
                    child: CustomCircularLoader(),),);
                }

                if(jobsState.status == JobStatus.jobsFiltersFetchError){
                  return const SliverToBoxAdapter(child: CustomEmptyContentWidget(title: "Sorry we couldn't fetch filters try again",),);
                }

                // fetch was successful

                if(jobsState.status == JobStatus.jobsFiltersFetchedSuccessful && jobsState.jobFilters != null){
                    return  SliverToBoxAdapter(child: SafeArea(
                      bottom: true,
                      child: Wrap(
                        children: [
                          ...(jobsState.jobFilters?.stacks ?? <Map<String, dynamic>>[]).map((skill) =>
                              BlocSelector<JobsCubit, JobsState, Map<String, dynamic>?>(
                                selector: (jobState) {
                                  final mapIndex =  jobState.jobFilters!.stacks!.indexWhere((element) => element["filter"] == skill["filter"]);
                                  if(mapIndex >= 0){
                                    final map = jobState.jobFilters!.stacks![mapIndex];
                                    return map;
                                  }
                                  return null;
                                },
                                builder: (context, filterItem) {
                                  if(filterItem == null) return const SizedBox.shrink();

                                  final bool selected = filterItem["selected"] as bool;
                                  final UserStackModel stack = filterItem["filter"] as UserStackModel;

                                  String? iconUrl;
                                  if(stack.icon != null){
                                    iconUrl = "${ApiConfig.stackIconsUrl}/${stack.icon}";
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      context.read<JobsCubit>().selectDeselectJobStacksFilter({
                                        "filter" : filterItem["filter"],
                                        "selected": !selected
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      decoration: BoxDecoration(
                                          color: selected ? kAppBlue.withOpacity(0.3) : theme.colorScheme.outline,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
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
                                                    _fallbackIcon(context, stack.name ?? ''),
                                                placeholder: (ctx, url) =>
                                                    _fallbackIcon(context, stack.name ?? ''),
                                                cacheKey: iconUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                                : Image.asset(kTechStackPlaceHolderIcon),
                                          ),
                                          const SizedBox(width: 5,),
                                          Text(stack.name ?? "", style: TextStyle(color:
                                          selected ? kAppBlue: theme.colorScheme.onBackground.withOpacity(0.4)),)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                          )

                        ],
                      ),
                    ),);
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink(),);

            },
          )
        ],
      ),
    );
  }

  Widget _fallbackIcon(BuildContext context, String name){
    return Container(
        color: kAppBlue.withOpacity(0.3),
        child: Center(child: Text(getInitials(name.toUpperCase()), style: TextStyle(color: Theme.of(context).colorScheme.onBackground),)));
  }
}
