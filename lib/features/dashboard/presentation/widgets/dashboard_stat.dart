import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_cubit.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_state.dart';
import 'package:showwcase_v3/features/dashboard/data/bloc/dashboard_status.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashboardStats extends StatefulWidget {
  const DashboardStats({Key? key}) : super(key: key);

  @override
  DashboardStatsController createState() => DashboardStatsController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class DashboardStatsView
    extends WidgetView<DashboardStats, DashboardStatsController> {
  const DashboardStatsView(DashboardStatsController state, {super.key})
      : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.brightness == Brightness.light
        ? kAppGray
        : const Color(0xff999999);

    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: state.dashboardCubit,
      builder: (context, dashboardState) {
        if (dashboardState.status == DashboardStatus.dashboardLoading) {
          return const Center(
            child: CustomAdaptiveCircularIndicator(),
          );
        }
        if (dashboardState.status == DashboardStatus.dashboardFailed) {
          return const Center(child: Text('Error'));
        }
        if (dashboardState.status == DashboardStatus.dashboardLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Stats",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () {
                      filterDate(context: context, color: color, theme: theme);
                    },
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: state._dateTypeNotifier,
                          builder: (context, String value, child) {
                            return Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            );
                          },
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/eye.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.network!.profileViews}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Profile Views",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onPrimary)),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/send.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "${dashboardState.dashboardModel?.network!.inviteCodeUsed}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Invite Codes Used",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/worked_with.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.network!.newWorkedwiths}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "New Circle Members",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/user.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.network!.newFollowers}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "New Followers",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Threads",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/thread.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.threads!.newThreads}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Threads",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onPrimary)),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/eye.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.threads!.threadsViews}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Thread Views",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/share.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.threads!.threadsInteractions}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Thread Interactions",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/worked_with.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.threads!.threadsMentions}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Mentions",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Shows",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/shows.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.projects!.newProjects}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Shows",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/eye.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.projects!.projectsViews}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Show Views",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/share.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.projects!.projectsInteractions}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Show Interactions",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 1,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/svg/shows_streak.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${dashboardState.dashboardModel?.projects!.projectsStreak}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Show Streak (Week)",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void filterDate(
      {required BuildContext context,
      required Color color,
      required ThemeData theme}) {
    final ch = StatefulBuilder(builder: (context, StateSetter setInnerState) {
      return SafeArea(
        bottom: true,
        child: SizedBox(
          height: 220,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const CustomBorderWidget(),
              SeparatedColumn(
                separatorBuilder: (BuildContext context, int index) {
                  return const CustomBorderWidget();
                },
                children:
                    List<Widget>.generate(state.dateType.length, (int index) {
                  return ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      title: Text(
                        state.dateType[index],
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing:
                          state._dateTypeNotifier.value == state.dateType[index]
                              ? const Icon(
                                  Icons.check,
                                  color: kAppBlue,
                                )
                              : null,
                      onTap: () async {
                        state._dateTypeNotifier.value = state.dateType[index];
                        pop(context);
                        if (index < 3) {
                          state.dashboardCubit.getDashboardStat(
                              startDate: state.dates[index],
                              endDate: DateTime.now()
                                  .getDateOnly()
                                  .millisecondsSinceEpoch);
                        } else if (index == 3) {
                          state.dashboardCubit.getDashboardStat();
                        } else {
                          openDatePicker(context, theme);
                        }
                      });
                  return RadioListTile<int>(
                    value: state.dates[index],
                    activeColor: kAppBlue,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    title: Text(
                      state.dateType[index],
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    groupValue: state.startDate,
                    toggleable: true,
                    onChanged: (int? newValue) {
                      setInnerState(() => state.startDate = newValue!);
                      Navigator.pop(context);
                      state.dashboardCubit.getDashboardStat(
                          startDate: state.startDate,
                          endDate: DateTime.now()
                              .getDateOnly()
                              .millisecondsSinceEpoch);
                      state._dateTypeNotifier.value = state.dateType[index];
                    },
                  );
                }),
              ),
              // const CustomBorderWidget(),
              // ListTile(
              //   visualDensity:
              //   const VisualDensity(horizontal: -4, vertical: -4),
              //   title: Row(
              //     children: [
              //       const SizedBox(
              //         width: 15,
              //       ),
              //       Text(
              //         'All Time',
              //         style: TextStyle(
              //             color: theme.colorScheme.onBackground,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     ],
              //   ),
              //   onTap: () async {
              //     Navigator.pop(context);
              //     state.dashboardCubit.getDashboardStat();
              //   },
              // ),
              // const CustomBorderWidget(),
              // ListTile(
              //   visualDensity:
              //   const VisualDensity(horizontal: -4, vertical: -4),
              //   trailing: Icon(
              //     Icons.calendar_month_outlined,
              //     size: 18,
              //     color: theme.colorScheme.onBackground,
              //   ),
              //   title: Row(
              //     children: [
              //       const SizedBox(
              //         width: 15,
              //       ),
              //       Text(
              //         'Custom',
              //         style: TextStyle(
              //             color: theme.colorScheme.onBackground,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     ],
              //   ),
              //   onTap: () async {
              //     openDatePicker(context, theme);
              //   },
              // ),
              const CustomBorderWidget(),
            ],
          ),
        ),
      );
    });
    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }

  void openDatePicker(BuildContext context, ThemeData theme) {
    final ch = Builder(builder: (context) {
      return SizedBox(
        height: height(context) / 1.5,
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: CustomButtonWidget(
                  text: 'Save',
                  textColor: kAppBlue,
                  onPressed: () {
                    state.dashboardCubit.getDashboardStat(
                        startDate: state.startDate, endDate: state.endDate);
                    state._dateTypeNotifier.value =
                    '${getFormattedDateWithIntl(DateTime.fromMillisecondsSinceEpoch(state.startDate),format: 'dd MMM')} -'
                        ' ${getFormattedDateWithIntl(DateTime.fromMillisecondsSinceEpoch(state.endDate), format: 'dd MMM yyyy')}';
                    pop(context);
                  },
                  backgroundColor: Colors.transparent,
                  outlineColor: Colors.transparent,
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SfDateRangePicker(
                  backgroundColor: theme.colorScheme.background,
                  selectionColor: kAppBlue,
                  //enableMultiView: true,
                  rangeSelectionColor: kAppBlue,
                  todayHighlightColor: kAppBlue,
                  maxDate: DateTime.now().getDateOnly(),
                  rangeTextStyle: const TextStyle(color: Colors.white),
                  initialSelectedRange: PickerDateRange(
                      DateTime.fromMillisecondsSinceEpoch(state.startDate),
                      DateTime.fromMillisecondsSinceEpoch(state.endDate)),
                  selectionTextStyle:
                      TextStyle(color: theme.colorScheme.onBackground),
                  yearCellStyle: DateRangePickerYearCellStyle(
                      todayTextStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      textStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      todayTextStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      trailingDatesTextStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      textStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    state.setState(() {
                      state.startDate =
                          args.value.startDate!.millisecondsSinceEpoch;
                      if (args.value.endDate != null) {
                        state.endDate =
                            args.value.endDate!.millisecondsSinceEpoch;
                      }
                    });
                  },
                  startRangeSelectionColor: kAppBlue,
                  endRangeSelectionColor: kAppBlue,
                  selectionMode: DateRangePickerSelectionMode.range,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    enableSwipeSelection: true,
                    showTrailingAndLeadingDates: true,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  )),
            ),
          ],
        ),
      );
    });
    showCustomBottomSheet(context, child: ch, showDragHandle: true);
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class DashboardStatsController extends State<DashboardStats> {
  final Color coldPurple = const Color(0xff9399D4);
  final Color seaShellGrey = const Color(0xffF1F1F1);
  final Color mineShaftBlack = const Color(0xff2C2C2C);
  final Color seaGullBlue = const Color(0xff72B7E3);
  final Color eastSidePurple = const Color(0xffC896CD);
  int endDate = DateTime.now().getDateOnly().millisecondsSinceEpoch;
  int startDate = DateTime.now()
      .getDateOnly()
      .subtract(const Duration(days: 29))
      .millisecondsSinceEpoch;

  late DashboardCubit dashboardCubit;
  List<String> dateType = [
    'Today',
    '7 days',
    '30 days',
    'All Time',
    'Custom',
  ];
  final ValueNotifier<String> _dateTypeNotifier =
      ValueNotifier<String>('30 days');
  late List<int> dates;

  @override
  initState() {
    dates = [
      DateTime.now().getDateOnly().millisecondsSinceEpoch,
      DateTime.now()
          .getDateOnly()
          .subtract(const Duration(
            days: 6,
          ))
          .millisecondsSinceEpoch,
      DateTime.now()
          .getDateOnly()
          .subtract(const Duration(days: 29))
          .millisecondsSinceEpoch
    ];
    dashboardCubit = context.read<DashboardCubit>();
    dashboardCubit.getDashboardStat(startDate: startDate, endDate: endDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DashboardStatsView(this);
}
