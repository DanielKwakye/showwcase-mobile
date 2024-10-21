// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:showwcase_v3/core/utils/constants.dart';
// import 'package:showwcase_v3/core/utils/extensions.dart';
// import 'package:showwcase_v3/core/utils/theme.dart';
// import 'package:showwcase_v3/core/utils/widget_view.dart';
// import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
// import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
// import 'package:showwcase_v3/features/jobs/data/bloc/jobs_enums.dart';
// import 'package:showwcase_v3/features/jobs/data/bloc/jobs_state.dart';
// import 'package:showwcase_v3/features/jobs/presentation/widgets/job_item_widget.dart';
// import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
// import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
// import 'package:showwcase_v3/features/shared/presentation/widgets/custom_markdown_widget.dart';
// import 'package:showwcase_v3/features/shared/presentation/widgets/fallback_icon_widget.dart';
//
//
// class CompanyPreviewPage extends StatefulWidget {
//
//   final CompanyModel company;
//   const CompanyPreviewPage({
//     required this.company,
//     Key? key}) : super(key: key);
//
//   @override
//   State<CompanyPreviewPage> createState() => _CompanyPreviewPageController();
// }
//
// ////////////////////////////////////////////////////////
// /// View is dumb, and purely declarative.
// /// Easily references values on the controller and widget
// ////////////////////////////////////////////////////////
//
// class _CompanyPreviewPageView extends WidgetView<CompanyPreviewPage, _CompanyPreviewPageController> {
//
//   const _CompanyPreviewPageView(_CompanyPreviewPageController state) : super(state);
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//           body: NotificationListener(
//             onNotification: (ScrollNotification scrollInfo) {
//               state._onScroll();
//               return false;
//             },
//             child: NestedScrollView(
//               controller: state.scrollController,
//               headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//                 return [
//                   SliverAppBar(
//                     backgroundColor: theme.colorScheme.background,
//                     iconTheme: IconThemeData(color: theme.colorScheme.onBackground,),
//                     elevation: 0.0,
//                     pinned: true,
//                     floating: true,
//                     centerTitle: true,
//                     title: innerBoxIsScrolled ? Text(widget.company.name?? '', style: TextStyle(color: theme.colorScheme.onBackground, fontSize: defaultFontSize),) : const SizedBox.shrink(),
//                   ),
//                 ];
//               },
//               body: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                     decoration: BoxDecoration(
//                         border: Border(bottom: BorderSide(color: theme.colorScheme.outline))
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           padding: const EdgeInsets.all(0),
//                           margin: const EdgeInsets.only(top: 5),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: CachedNetworkImage(
//                               imageUrl: widget.company.logo ?? '',
//                               errorWidget: (context, url, error) =>
//                                   FallBackIconWidget(name: widget.company.name ?? 'Company'),
//                               placeholder: (ctx, url) =>
//                                   FallBackIconWidget(name: widget.company.name ?? 'Company'),
//                               cacheKey: widget.company.logo ?? '',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           // ,
//                         ),
//                         const SizedBox(width: 20,),
//                         Expanded(child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//
//                             Text(
//                               widget.company.name ?? '',
//                               style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 16, fontWeight: FontWeight.w600 ),
//                             ),
//                             const SizedBox(height: 10,),
//                             if(widget.company.oneLiner != null) ... {
//                               Text(
//                                 widget.company.oneLiner ?? '',
//                                 style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6),
//                                 ),
//                               ),
//                               const SizedBox(height: 10,),
//                             },
//
//                             Row(
//                               children: [
//
//                                 if(widget.company.location != null) ... {
//                                   Expanded(flex: 2,child: Row(
//                                     children: [
//                                       Icon(Icons.location_on_rounded, color:  theme.colorScheme.onBackground.withOpacity(0.6), size: 14,),
//                                       const SizedBox(width: 5,),
//                                       Expanded(child: Text(widget.company.location?.capitalize() ?? '',
//                                         // overflow: TextOverflow.ellipsis,
//                                         // maxLines: 1,
//                                         style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6),
//                                         ),))
//                                     ],
//                                   ),),
//                                   const SizedBox(width: 10,),
//                                 },
//
//
//                                 if(widget.company.industry != null) ... {
//                                   Expanded(child:  Row(
//                                     children: [
//                                       Icon(Icons.work, color: theme.colorScheme.onBackground.withOpacity(0.6), size: 14,),
//                                       const SizedBox(width: 5,),
//                                       Expanded(child:
//                                       Text( widget.company.industry?.name?.capitalize() ?? '',
//                                         // maxLines: 1,
//                                         // overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),))
//                                     ],
//                                   ),),
//                                 }
//
//                               ],
//                             )
//
//                           ],
//                         ))
//                       ],
//                     ),
//                   ),
//
//                   if(widget.company.description != null) ... {
//
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//                           child: Text(
//                             'About',
//                             style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 16, fontWeight: FontWeight.w600 ),
//                           ),
//                         ),
//                         const SizedBox(height: 5,),
//
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
//                           child: CustomMarkdownWidget(
//                             markdown: widget.company.description ?? "",
//                           ),
//                         ),
//
//
//                         // border
//                         const CustomBorderWidget()
//
//                       ],
//                     )
//
//                   },
//
//                   if(widget.company.totalJobs != null) ... {
//
//                     BlocBuilder<JobsCubit, JobsState>(
//                       buildWhen: (_, next) {
//                         return next.status == JobStatus.companiesJobsFetchedSuccessful
//                             || next.status ==  JobStatus.companiesJobsFetchError;
//                       },
//                       builder: (context, jobState) {
//
//                         switch (jobState.status) {
//                           case JobStatus.companiesJobsFetchError:
//                             return const SizedBox.shrink();
//
//                           case JobStatus.companiesJobsFetchedSuccessful:
//
//                             if (jobState.companyJobResponseList.isEmpty) {
//                               return const SingleChildScrollView(
//                                 child: CustomEmptyContentWidget(
//                                   title: "No jobs published yet!",
//                                   subTitle: "All the published jobs will be visible here",
//                                 ),
//                               );
//                             }
//
//                             return ListView.separated(
//                               padding: const EdgeInsets.only(top: 0),
//                               separatorBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     color: theme.brightness == Brightness.dark ? const Color(0xff101011) : theme.colorScheme.surface,
//                                   ),
//                                   height: 8,
//                                   width: MediaQuery.of(context).size.width,
//                                 );
//                               },
//                               shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemBuilder: (BuildContext context, int index) {
//
//                                   if (index >= jobState.companyJobResponseList.length) {
//                                     return const SizedBox(
//                                       height: 100,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child: CupertinoActivityIndicator(),
//                                       ),
//                                     );
//                                   }
//
//
//                                   final job = jobState.companyJobResponseList[index];
//                                   if(job.title!.isNullOrEmpty()) {
//                                     return const SizedBox.shrink();
//                                   }
//                                   //AnalyticsManager.jobImpression(pageName: 'company_page', jobId: job.id!,index: index,pageTitle: job.title!,containerName: 'company_preview');
//
//                                   return JobItemWidget(job: job,containerName: 'company_preview',);
//
//
//                                 }, itemCount: jobState.hasCompaniesJobsReachedMax
//                                     ? jobState.companyJobResponseList.length
//                                     : jobState.companyJobResponseList.length + 1,
//
//                                 );
//                              // );
//
//                           default:
//                             return _loader();
//                         }
//                       },
//                     )
//
//                   }
//                 ],
//               ),
//
//             ),
//           ),
//         );
//   }
//
//   Widget _loader() {
//     return const Padding(
//       padding: EdgeInsets.only(top: kToolbarHeight),
//       child: Align(
//         alignment: Alignment.center,
//         child: SizedBox(width: 50,
//           height: 50,
//           child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(kAppBlue), strokeWidth: 2,),),
//       ),
//     );
//   }
//
// }
//
// ////////////////////////////////////////////////////////
// /// Controller holds state, and all business logic
// ////////////////////////////////////////////////////////
//
// class _CompanyPreviewPageController extends State<CompanyPreviewPage> {
//
//   late final JobsCubit _jobsCubit;
//   late ScrollController scrollController;
//
//   @override
//   initState() {
//     super.initState();
//     scrollController = ScrollController();
//     _jobsCubit = context.read<JobsCubit>();
//     _jobsCubit.fetchCompanyJobs(slug: widget.company.id.toString() , replaceFirstPage: true);
//
//   }
//
//   @override
//   dispose(){
//     super.dispose();
//     scrollController.dispose();
//   }
//
//   bool get _isBottom {
//     if (!scrollController.hasClients) return false;
//     final maxScroll = scrollController.position.maxScrollExtent;
//     final currentScroll = scrollController.offset;
//     return currentScroll >= (maxScroll * 0.9);
//   }
//
//   void _onScroll() {
//     if (_isBottom) {
//
//       /// we use debouncer because _onScroll is called multiple times
//       EasyDebounce.debounce(
//           'company-jobs-debouncer', // <-- An ID for this particular debouncer
//           const Duration(milliseconds: 500), // <-- The debounce duration
//               () {
//             _jobsCubit.fetchCompanyJobs(slug: widget.company.id.toString() , replaceFirstPage: false);
//           }
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => _CompanyPreviewPageView(this);
//
//
// }