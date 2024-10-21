import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/jobs/data/bloc/jobs_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/widget_view.dart';

class SalaryFilterWidget extends StatefulWidget {

  const SalaryFilterWidget({Key? key}) : super(key: key);

  @override
  SalaryFilterWidgetController createState() => SalaryFilterWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SalaryFilterWidgetView extends WidgetView<SalaryFilterWidget, SalaryFilterWidgetController> {

  const _SalaryFilterWidgetView(SalaryFilterWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpandableNotifier(  // <-- Provides ExpandableController to its children
      child: Column(
        children: [
          Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
            collapsed: _header(context, icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onBackground,)),
            expanded: Column(
                children: [
                  _header(context, icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onBackground,)),
                  const SizedBox(height: 20,),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _content(context)
                  ),
                  const SizedBox(height: 8,),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _sliderReader()
                  ),

                  const SizedBox(height: 20,),
                  const CustomBorderWidget(),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context){
    final theme = Theme.of(context);
    return Container(
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outline),
          color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7)
      ),
      child: ValueListenableBuilder<double>(valueListenable: state.rating, builder: (_, double rating, __) {
        return Theme(
          data: theme.copyWith(
           sliderTheme: theme.sliderTheme.copyWith(
            valueIndicatorColor: kAppBlue,
            valueIndicatorTextStyle: const TextStyle(
                backgroundColor: Colors.transparent
            ))
          ),
          child: Slider(
            onChanged: state._onSliderChanged,
            value: rating,
            min: 0,
            max: 500,
            divisions: 500,
            activeColor: kAppBlue,
            inactiveColor: theme.colorScheme.outline,
            label: "\$ ${rating.toStringAsFixed(0)}K",
          ),
        );
      }),
    );
  }

  Widget _sliderReader() {
    return ValueListenableBuilder<double>(valueListenable: state.rating, builder: (_, double rating, __) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$ ${rating.toStringAsFixed(0)}K',
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: defaultFontSize - 2),
          ),
          Text(
            '\$ ${rating.toStringAsFixed(0)}K',
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: defaultFontSize - 2),
          )
        ],
      );
    });

  }

  Widget _header(BuildContext context, {required Icon icon}) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ExpandableButton(
        // <-- Expands when tapped on the cover photo
        theme: const ExpandableThemeData(
            useInkWell: false
        ),
        child: Container(
          width: mediaQuery.size.width,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.colorScheme.outline))
          ),
          padding: const EdgeInsets.only(bottom: 15, left: 17, right: 15),
          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Salary',
                        style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      icon
                    ],
                  ),
                  ValueListenableBuilder<double>(valueListenable: state.rating, builder: (_, double rating, __) {
                    if(rating == 0){
                      return Text(
                        'No filters selected',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: defaultFontSize - 2),
                      );
                    }

                    return Text(
                      '\$ ${rating.toStringAsFixed(0)}K',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: defaultFontSize - 2),
                    );

                  })

                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SalaryFilterWidgetController extends State<SalaryFilterWidget> {

  late ValueNotifier<double> rating;
  late JobsCubit jobsCubit;

  @override
  void initState() {
    super.initState();
    jobsCubit = context.read<JobsCubit>();
    rating =  ValueNotifier(jobsCubit.state.salaryFilter);
  }

  @override
  Widget build(BuildContext context) => _SalaryFilterWidgetView(this);

  void _onSliderChanged(double value) {
    rating.value = value;

    EasyDebounce.debounce(
        'job-salary-filter-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 400), // <-- The debounce duration
            () {
              jobsCubit.updateSalaryFilter(salary: value);
        });
  }
}