import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/analytics/data/service/analytics_service.dart';
import 'package:showwcase_v3/features/jobs/data/models/job_model.dart';

class JobItemWidget extends StatefulWidget {
  final JobModel job;
  final String? timeFormat;
  final String containerName;

  JobItemWidget({required this.job, this.timeFormat,required this.containerName,Key? key})
      : super(key: ValueKey(job.id));

  @override
  State<JobItemWidget> createState() => _JobItemWidgetState();
}

class _JobItemWidgetState extends State<JobItemWidget> {

  @override
  void initState() {
    AnalyticsService.instance.sendEventJobImpression(jobModel: widget.job,containerName: widget.containerName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    final logo = widget.job.company?.logoUrl ?? '';

    return GestureDetector(
      onTap: () {
        context.push(context.generateRoutePath(subLocation: jobsPreviewPage),extra: widget.job);
        AnalyticsService.instance.sendEventJobTap(jobModel: widget.job,containerName: widget.containerName);
      },
      child: Container(
        decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? kAppCardDarkModeBackground : kAppWhite),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    errorWidget: (context, url, error) =>
                        _fallbackIcon(context, widget.job.company?.name ?? 'Company'),
                    placeholder: (ctx, url) =>
                        _fallbackIcon(context, widget.job.company?.name ?? 'Company'),
                    cacheKey: widget.job.company?.logoUrl ?? '',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.job.company?.name ?? '',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground.withOpacity(0.8),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.job.score != null && widget.job.score! >= 70) ...{
                        Container(
                          decoration: BoxDecoration(
                              color: kAppGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 3),
                          //alignment: Alignment.topRight,
                          child: Text(
                            '${widget.job.score}%',
                            style: const TextStyle(
                                color: kAppGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      }
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    widget.job.title ?? '',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    if(getJobLocation(job: widget.job).isNotEmpty) ...{
                      Flexible(
                        fit: FlexFit.tight,
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: theme.colorScheme.onPrimary,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                getJobLocation(job: widget.job),
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    },
                      Flexible(
                        fit: FlexFit.tight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: theme.colorScheme.onPrimary,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                              widget.job.type?.capitalize() ?? '',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.job.salary?.range != null &&
                          widget.job.salary?.range != '') ...{
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/subscriptions.svg',
                                color: theme.colorScheme.onPrimary,
                                width: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  widget.job.salary?.range ?? '',
                                  style:
                                      TextStyle(color: theme.colorScheme.onPrimary),
                                ),
                              ),
                            ],
                          ),
                        )
                      },
                      if (widget.job.salary?.range != null && widget.job.salary?.range != '')
                        const SizedBox(
                          width: 10,
                        ),
                      if (widget.job.publishedDate != null) ...{
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                kCalendarIconSvg,
                                color: theme.colorScheme.onPrimary,
                                width: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                !widget.timeFormat.isNullOrEmpty()
                                    ? getFormattedDateWithIntl(widget.job.publishedDate!,
                                        format: widget.timeFormat!)
                                    : getTimeAgo(widget.job.publishedDate!),
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: defaultFontSize - 1),
                              ),
                            ],
                          ),
                        )
                      }
                    ],
                  ),

                  /// stacks required ------------
                  if (widget.job.stacks != null && widget.job.stacks!.isNotEmpty) ...{
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      runSpacing: 8,
                      children: [
                        ...widget.job.stacks!.map((stack) {
                          String? iconUrl;
                          if (stack.icon != null) {
                            iconUrl = "${ApiConfig.stackIconsUrl}/${stack.icon}";
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
                                        placeholder: (ctx, url) => _fallbackIcon(
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
                                if (stack.isMatched != null &&
                                    stack.isMatched == true) ...{
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        color: kAppGreen.withOpacity(0.5),
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.check,
                                          color:
                                              theme.brightness == Brightness.dark
                                                  ? kAppGreen
                                                  : kAppWhite,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                }
                              ],
                            ),
                          );
                        })
                      ],
                    )
                  },
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  String getJobLocation({required JobModel job}) {
    switch (job.arrangement) {
      case 'remote':
        return 'Remote';
      case 'onsite':
        return job.location ?? '';
      case 'semi-remote':
        return 'Remote';
      default:
        return job.arrangement?.capitalize() ?? '';
    }
  }

  Widget _fallbackIcon(BuildContext context, String name, {double size = 40}) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: theme.colorScheme.outline),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(top: 0),
      child: Center(
          child: Text(
        getInitials(name.toUpperCase()),
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      )),
    );
  }
}
