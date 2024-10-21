import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_cubit.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_enum.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_state.dart';
import 'package:showwcase_v3/features/companies/presentation/widgets/company_item_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_emtpy_content_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';

class CompanyFeedsPage extends StatefulWidget {

  const CompanyFeedsPage({Key? key}) : super(key: key);

  @override
  CompanyFeedsPageController createState() => CompanyFeedsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CompanyFeedsPageView extends WidgetView<CompanyFeedsPage, CompanyFeedsPageController> {

  const _CompanyFeedsPageView(CompanyFeedsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        state._onScroll();
        return false;
      },
      child: NestedScrollView(
        controller: state.scrollController,
          headerSliverBuilder: (_, __) {
        return [

        ];
      }, body:  BlocBuilder<CompanyCubit, CompanyState>(
        bloc: state._companyCubit,
        buildWhen: (_, next) {
          return next.status == CompanyStatus.companiesFetchedSuccessful || next.status == CompanyStatus.companiesFetchError;
        },
        builder: (context, jobState) {

          switch (jobState.status) {
            case CompanyStatus.companiesFetchError:
              return const SingleChildScrollView(
                child: CustomNoConnectionWidget(),
              );


            case CompanyStatus.companiesFetchedSuccessful:

              if (jobState.companies.isEmpty) {
                return const SingleChildScrollView(
                  child: CustomEmptyContentWidget(
                    title: "No companies published yet!",
                    subTitle: "All the published companies will be visible here",
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8),
                //padding: const EdgeInsets.only(top: 20),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: theme(context).brightness == Brightness.dark ? kAppCardGapsDarkMode: theme(context).colorScheme.surface,
                    ),
                    height: 8,
                    width: width(context),
                  );
                }, itemCount: jobState.hasCompaniesReachedMax
                  ? jobState.companies.length
                  : jobState.companies.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= jobState.companies.length) {
                    return const SizedBox(
                      height: 100,
                      child: Align(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }

                  final company = jobState.companies[index];
                  return CompanyItemWidget(company: company,);
                },);


            default:
              return _loader();
          }
        },
      )),
    );

  }
  Widget _loader() {
    return const Padding(
      padding: EdgeInsets.only(top: kToolbarHeight),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(width: 50,
          height: 50,
          child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(kAppBlue), strokeWidth: 2,),),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class CompanyFeedsPageController extends State<CompanyFeedsPage> with AutomaticKeepAliveClientMixin{

  late CompanyCubit _companyCubit;
  late ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _CompanyFeedsPageView(this);
  }

  @override
  void initState() {
    scrollController = ScrollController();
    _companyCubit = context.read<CompanyCubit>();
    _companyCubit.fetchCompanies(replaceFirstPage: true);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }
  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }


  void _onScroll() {
    if (_isBottom) {
      /// we use debouncer because _onScroll is called multiple times
      EasyDebounce.debounce(
          'job-companies-debouncer', // <-- An ID for this particular debouncer
          const Duration(milliseconds: 500), // <-- The debounce duration
              () {
                _companyCubit.fetchCompanies(replaceFirstPage: false);
          }
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}