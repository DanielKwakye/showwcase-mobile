import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/mix/launch_external_app_mixin.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/home/data/bloc/home_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_preview_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/job_preview_state.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';

class JobPreviewPage extends StatefulWidget {

  final JobModel job;
   const JobPreviewPage({ required this.job, Key? key}) : super(key: key);

  @override
  JobPreviewPageController createState() => JobPreviewPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _JobPreviewPageView extends WidgetView<JobPreviewPage, JobPreviewPageController> {
  const _JobPreviewPageView(JobPreviewPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<JobPreviewCubit, JobPreviewState>(
        builder: (context, jobState) {
          final updatedJob = jobState.jobPreviews.firstWhere((element) => element.id == widget.job.id);
          return SafeArea( top: false, bottom: true,
            child: NestedScrollView(
              //controller: state.scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: theme.colorScheme.background,
                    iconTheme: IconThemeData(
                      color: theme.colorScheme.onBackground,
                    ),
                    elevation: 0.0,
                    pinned: true,
                    centerTitle: true,
                    title: innerBoxIsScrolled ? Text(
                      updatedJob.title ?? '',
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: defaultFontSize),
                    )
                        : const SizedBox.shrink(),
                    bottom:  PreferredSize(
                        preferredSize: const Size.fromHeight(2),
                        child: jobState.status == JobStatus.jobsPreviewFetching ?
                              const LinearProgressIndicator(color: kAppBlue, minHeight: 2,)
                            :  const CustomBorderWidget()
                    ),
                    actions: [
                      if (innerBoxIsScrolled) ...{
                        UnconstrainedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: CustomButtonWidget(
                              text: 'Apply',
                              onPressed: () => state._applyNowButtonTapped(updatedJob),
                              appearance: Appearance.clean,
                              textColor: kAppBlue,
                            ),
                          ),
                        )
                      },
                      if (!innerBoxIsScrolled && updatedJob.applyUrl != null) ...{
                        /// Linked In
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              // SocialShare.shareOptions(url ?? AppConfig.websiteUrl, imagePath: imageUrl);
                              FlutterShareMe().shareToSystem(msg: '${ApiConfig.websiteUrl}/job/${updatedJob.id}-${updatedJob.slug}');
                            },
                            icon: const Icon(
                              Icons.share,
                            ),
                            visualDensity: const VisualDensity(horizontal: -4),
                          ),
                        ),
                      }
                    ],
                  ),
                ];
              },
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: theme.colorScheme.outline))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.only(top: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: updatedJob.company?.logoUrl ?? '',
                                errorWidget: (context, url, error) => _fallbackIcon(
                                    context, updatedJob.company?.name ?? 'Company'),
                                placeholder: (ctx, url) => _fallbackIcon(
                                    context, updatedJob.company?.name ?? 'Company'),
                                cacheKey: updatedJob.company?.logoUrl ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // ,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                updatedJob.title ?? '',
                                                style: TextStyle(
                                                    color: theme.colorScheme.onBackground,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (updatedJob.score != null) ...{
                                              Container(
                                                decoration: BoxDecoration(
                                                    color:  kAppGreen.withOpacity(0.2),
                                                    borderRadius:
                                                    BorderRadius.circular(4)),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 8),
                                                child: Text(
                                                  '${updatedJob.score}% Match',
                                                  style: const TextStyle(
                                                      color: kAppGreen,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            }
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    updatedJob.company?.name ?? '',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                     children: [
                                       CustomButtonWidget(
                                         text: 'Apply Now',
                                         onPressed: () => state._applyNowButtonTapped(updatedJob),
                                       ),
                                       const SizedBox(
                                         width: 0,
                                       ),

                                       /// Bookmark
                                       LikeButton(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         padding: EdgeInsets.zero,
                                         isLiked: updatedJob.hasBookmarked != null && updatedJob.hasBookmarked!,
                                         onTap: (value) {
                                           return state.onBookmarkTapped(job: updatedJob, feedActionType: JobFeedActionType.bookmark, toggle: !value);
                                         },

                                         likeBuilder: (bool isBookmarked) {
                                           /// We use align so we can manage the icon size in here
                                           return Align(
                                               alignment: Alignment.centerRight,
                                               child: isBookmarked ?
                                               SvgPicture.asset(kBookmarkFilledIconSvg, colorFilter: const ColorFilter.mode(kAppBlue, BlendMode.srcIn),  width: 13) :
                                               SvgPicture.asset(kBookmarkOutlinedIconSvg, colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn,),)

                                           );
                                         },
                                         bubblesColor: const BubblesColor(
                                           dotSecondaryColor: kAppBlue,
                                           dotPrimaryColor: kAppBlue,
                                         ),
                                         // countBuilder: (int? count, bool isLiked, String text){
                                         //   return Text(text, style: TextStyle(color: widget.iconColor ?? theme.colorScheme.onPrimary),);
                                         // },
                                         // countDecoration: (widget, likCount) {
                                         //   return Padding(padding: EdgeInsets.zero, child: widget,);
                                         // },
                                       )
                                     ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),

                  /// Job Information
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (updatedJob.arrangement != null) ...{
                              Expanded(
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: <Widget>[
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                          color: theme.colorScheme.onBackground,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 5,),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        state.getJobLocation(job: updatedJob,
                                            compact: false),
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary),
                                      ),
                                    ),
                                    // BlocBuilder<JobsCubit, JobsState>(
                                    //   builder: (context, jobState) {
                                    //     if (jobState.status ==
                                    //         JobStatus.jobsPreviewFetchingSuccessful) {
                                    //       return ;
                                    //     }
                                    //     return Padding(
                                    //       padding: const EdgeInsets.only(right: 20),
                                    //       child: Text(
                                    //         state.getJobLocation(
                                    //             job: job, compact: true),
                                    //         style: TextStyle(
                                    //             color: theme.colorScheme.onPrimary),
                                    //       ),
                                    //     );
                                    //   },
                                    //   buildWhen: (_, next) {
                                    //     return next.status ==
                                    //         JobStatus.jobsPreviewFetchingSuccessful;
                                    //   },
                                    //   bloc: state.jobsCubit,
                                    // )
                                  ],

                                ),
                              ),
                            },
                            if (updatedJob.type != null) ...{
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Job Type',
                                        style: TextStyle(
                                            color: theme.colorScheme.onBackground,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        updatedJob.type?.capitalize() ?? '',
                                        style:
                                        TextStyle(color: theme.colorScheme.onPrimary),
                                      )
                                    ],
                                  )),
                            },
                            if ((updatedJob.salary?.to != null && updatedJob.salary?.to != 0) ||
                                (updatedJob.salary?.from != null && updatedJob.salary?.from != 0)) ...{
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Salary',
                                        style: TextStyle(
                                            color: theme.colorScheme.onBackground,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 5,),
                                      if (updatedJob.salary?.range != null && updatedJob.salary?.range != '') ...{
                                        Text(
                                          updatedJob.salary?.range ?? '',
                                          style: TextStyle(
                                              color:
                                              theme.colorScheme.onPrimary),
                                        ),
                                      },
                                      //
                                      // const SizedBox(
                                      //   width: 5,
                                      // ),
                                      // Wrap(
                                      //   crossAxisAlignment: WrapCrossAlignment.center,
                                      //   children: [
                                      //     if (job.salary?.from != null && job.salary?.from != '') ...{
                                      //       Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           // Icon(Icons.attach_money_outlined, color: theme.colorScheme.onPrimary, size: 14,),
                                      //           // const SizedBox(width: 5,),
                                      //           Text(
                                      //             '${job.salary?.currency ?? '\$'} ',
                                      //             style: TextStyle(
                                      //                 color: theme.colorScheme.onPrimary),
                                      //           ),
                                      //           const SizedBox(
                                      //             width: 0,
                                      //           ),
                                      //           Text(
                                      //             toCompactFigure(
                                      //                 int.parse(job.salary?.from ?? "1").toDouble()),
                                      //             style: TextStyle(
                                      //                 color: theme.colorScheme.onPrimary),
                                      //           )
                                      //         ],
                                      //       ),
                                      //       const SizedBox(
                                      //         width: 5,
                                      //       ),
                                      //     },
                                      //     if (job.salary?.to != null && job.salary?.to != '') ...{
                                      //       Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           if (job.salary?.from != null && job.salary?.from != '') ...{
                                      //             Text(
                                      //               ' - ',
                                      //               style: TextStyle(
                                      //                   color:
                                      //                   theme.colorScheme.onPrimary),
                                      //             ),
                                      //             const SizedBox(
                                      //               width: 5,
                                      //             ),
                                      //           },
                                      //           Text(
                                      //             '${job.salary?.currency ?? '\$'} ',
                                      //             style: TextStyle(
                                      //                 color: theme.colorScheme.onPrimary),
                                      //           ),
                                      //           const SizedBox(
                                      //             width: 0,
                                      //           ),
                                      //           Text(
                                      //             toCompactFigure(
                                      //                 int.parse(job.salary?.to ?? "1").toDouble()),
                                      //             style: TextStyle(
                                      //                 color: theme.colorScheme.onPrimary),
                                      //           )
                                      //         ],
                                      //       ),
                                      //       const SizedBox(
                                      //         width: 7,
                                      //       ),
                                      //     },
                                      //   ],
                                      // )
                                    ],
                                  )),
                            },
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // if(job.publishedDate != null) ... {
                        //
                        //   Column(
                        //     children: [
                        //
                        //       Text('Posted', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
                        //       const SizedBox(width: 10,),
                        //       Text(getTimeAgo(updatedJob.publishedDate!), style: TextStyle(color: theme.colorScheme.onPrimary,
                        //           fontSize: defaultFontSize - 1),),
                        //       const SizedBox(height: 20,),
                        //
                        //     ],
                        //   )
                        //
                        // },

                        if (updatedJob.stacks != null &&
                            updatedJob.stacks!.isNotEmpty) ...{
                          Text(
                            'Tech Stack',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            runSpacing: 8,
                            children: [
                              ...updatedJob.stacks!.map((stack) {
                                String? iconUrl;
                                if (stack.icon != null) {
                                  iconUrl =
                                  "${ApiConfig.stackIconsUrl}/${stack.icon}";
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: theme.brightness == Brightness.dark
                                          ? const Color(0xff202021)
                                          : const Color(0xffF7F7F7)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (iconUrl != null) ...{
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(2),
                                            child: CachedNetworkImage(
                                              imageUrl: iconUrl,
                                              errorWidget: (context, url, error) =>
                                                  _fallbackIcon(
                                                      context, stack.name ?? ''),
                                              placeholder: (ctx, url) =>
                                                  _fallbackIcon(
                                                      context, stack.name ?? ''),
                                              cacheKey: iconUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      },
                                      Text(
                                        stack.name ?? '',
                                        style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                            fontSize: 12),
                                      ),
                                      if(stack.isMatched != null && stack.isMatched == true) ... {
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Container(
                                              color: kAppGreen.withOpacity(0.5),
                                              width: 20,
                                              height: 20,
                                              child:  Icon(Icons.check, color: theme.brightness == Brightness.dark ? kAppGreen : kAppWhite, size: 15,),
                                            ),
                                          ),
                                        )
                                      }

                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        },

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                  (updatedJob.company?.size?.value != null || updatedJob.company?.stage?.label != null ||
                                      updatedJob.company?.industry?.name != null) ? 20.0
                                      : 0.0),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (updatedJob.company?.size?.value !=
                                      null) ...{
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Company Size',
                                            style: TextStyle(
                                                color: theme
                                                    .colorScheme.onBackground,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 5,),
                                          Text(updatedJob.company?.size?.value ??
                                              '',
                                            style: TextStyle(
                                                color:
                                                theme.colorScheme.onPrimary),
                                          )
                                        ],
                                      ),
                                    ),
                                  },
                                  if (updatedJob.company?.industry?.name !=
                                      null) ...{
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Industry',
                                            style: TextStyle(
                                                color: theme
                                                    .colorScheme.onBackground,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 5,),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(updatedJob.company?.industry?.name ??
                                                '',
                                              style: TextStyle(
                                                  color:
                                                  theme.colorScheme.onPrimary),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  },
                                  if (updatedJob.company?.stage?.label !=
                                      null) ...{
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Investment Stage',
                                            style: TextStyle(
                                                color: theme
                                                    .colorScheme.onBackground,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 5,),
                                          Text(updatedJob.company?.stage?.label ?? '',
                                            style: TextStyle(
                                                color:
                                                theme.colorScheme.onPrimary),
                                          )
                                        ],
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                            if (updatedJob.experience != null) ...{
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Wrap(
                                  runSpacing: 8,
                                  children: [
                                    ...experienceOptions.map((exp) {
                                      final bool selected =
                                          exp['label'] as String == updatedJob.experience;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            color: selected
                                                ? kAppBlue.withOpacity(0.5)
                                                : (theme.brightness ==
                                                Brightness.dark
                                                ? const Color(0xff202021)
                                                : const Color(0xffF7F7F7))),
                                        child: Text(
                                          exp['label'] as String,
                                          style: TextStyle(
                                              color: selected
                                                  ? kAppBlue
                                                  : theme.colorScheme.onPrimary,
                                              fontSize: 12),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              )
                            }
                          ],
                        ),

                      ],
                    ),
                  ),

                  const CustomBorderWidget(),

                  /// Job Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomMarkdownWidget(markdown: updatedJob.description ?? '', onLinkTapped: (link) {
                          context.push(browserPage, extra: link);
                        }, onMentionTapped: (mention) {
                          if(mention.startsWith('u/')){
                            mention = mention.substring(2);
                          }
                          final url = "https://www.showwcase.com/${mention.toLowerCase()}";
                          context.read<HomeCubit>().redirectLinkToPage(url: url, fallBackRoutePath: browserPage, fallBackRoutePathData:  url);
                        },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }


  Widget _fallbackIcon(BuildContext context, String name, {double size = 40}) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          // border: Border.all(color: theme.colorScheme.outline),
          // borderRadius: BorderRadius.circular(5),
          color: theme.colorScheme.outline),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(top: 0),
      child: Center(
          child: Text(
        getInitials(name.toUpperCase()),
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      )),

      // ,
    );
    // return Center(child: Text(getInitials(name.toUpperCase()), style: TextStyle(color: Theme.of(context).colorScheme.onBackground),));
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class JobPreviewPageController extends State<JobPreviewPage> with LaunchExternalAppMixin {

  @override
  Widget build(BuildContext context) => _JobPreviewPageView(this);

  late JobPreviewCubit jobPreviewCubit;


  // final List<String> experienceLevels = ["Beginner", "Junior", "Mid-level", "Senior", "Expert"];

  @override
  void initState() {
    super.initState();
    jobPreviewCubit = context.read<JobPreviewCubit>();
    jobPreviewCubit.setJobPreview(job: widget.job);
    jobPreviewCubit.fetchJobPreview(jobModel: widget.job);
  }

  void _applyNowButtonTapped(JobModel job) {
      context.push(browserPage, extra: job.applyUrl!);
      AnalyticsService.instance.sendEventJobApply(jobModel: widget.job);

  }

  String getJobLocation({required JobModel job, bool compact = true}) {
    switch (job.arrangement) {
      case 'remote':
        return 'Remote';
      case 'onsite':
        return job.location ?? '';
      case 'semi-remote':
        return compact
            ? 'Remote'
            : '${job.timezone?.label} ±${job.timezone?.offset}';
      default:
        return job.arrangement?.capitalize() ?? '';
    }
  }

  Future<bool> onBookmarkTapped({required JobModel job, required JobFeedActionType feedActionType, required bool toggle}) async {

    if(feedActionType == JobFeedActionType.bookmark) {
      context.read<JobsCubit>().bookmarkJob(job: job, isBookmark: toggle);
    }

    return toggle;

  }
}
