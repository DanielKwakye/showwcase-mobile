import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_cubit.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_enum.dart';
import 'package:showwcase_v3/features/companies/data/bloc/company_state.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/presentation/pages/add_company_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_network_image_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

import '../../../shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class SearchCompaniesPage extends StatefulWidget {

  final String? title;
  const SearchCompaniesPage({Key? key, this.title}) : super(key: key);

  @override
  SearchCompaniesPageController createState() => SearchCompaniesPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchCompaniesPageView extends WidgetView<SearchCompaniesPage, SearchCompaniesPageController> {

  const _SearchCompaniesPageView(SearchCompaniesPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return  [
              const CustomInnerPageSliverAppBar(
                pinned: true,
                pageTitle: '',
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20,),),
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextFieldWidget(
                    focusNode: state.focusNode,
                    controller: state.textEditingController,
                    label:  'Search ${widget.title?.toLowerCase() ?? 'company'}',
                    onChange: state._onTextFieldChanged,
                    placeHolder: '${widget.title?.capitalize() ?? 'Company'} name',
                  ),
                ),
              ),
            ];
        }, body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 0, right: 0),
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(6),
              color: theme.colorScheme.primary,
            ),
            child: Column(
               children: [
                 ListTile(
                     onTap: () => state.handleAddNewCompany(),
                     dense: true,
                     title: RichText(
                       text: TextSpan(
                         style: theme.textTheme.bodyMedium,
                           children: [
                             TextSpan(text: 'Cant find ${widget.title?.toLowerCase() ?? 'company'} ?  ', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),),
                              TextSpan(text: 'Add it to Showwcase', style: theme.textTheme.bodyMedium?.copyWith(color: kAppBlue,),)
                           ]
                       ),
                     )
                 ),
                 ValueListenableBuilder<List<CompanyModel>>(valueListenable: state.companyList, builder: (_, list, __) {
                   return BlocBuilder<CompanyCubit, CompanyState>(
                     builder: (context, companyState) {
                       if(companyState.status == CompanyStatus.searchCompaniesInProgress){
                         return const Padding(
                           padding: EdgeInsets.only(top: 5, bottom: 15),
                           child: SizedBox(
                             height: 50, width: double.maxFinite,
                             child: Center(
                               child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),
                             ),
                           ),
                         );
                       }


                       return list.isNotEmpty ? Column(
                           children: [
                             ...list.map((company) {

                               final icon = company.logo != null
                                   ? getCompanyLogo(company.logo) : '${ApiConfig.companyAssetUrl}/default-profile-picture/company_default.svg';

                               return ListTile(
                                 dense: true,
                                 onTap: () => state._onItemTapped(company),
                                 minLeadingWidth: 0,
                                 leading: ClipRRect(
                                   borderRadius: BorderRadius.circular(5),
                                   child: Container(
                                       width: 30,
                                       height: 30,
                                       padding: const EdgeInsets.all(0),
                                       margin: const EdgeInsets.only(top: 0),
                                       child: CustomNetworkImageWidget(imageUrl: icon,)
                                   ),
                                 ),
                                 title: Text(company.name ?? '', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary),)
                             );
                             }).toList(),
                           ]
                       ) : const SizedBox.shrink();
                     },
                   );
                 }),
               ],
            ),
          )

        )

        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SearchCompaniesPageController extends State<SearchCompaniesPage> {

  final textEditingController = TextEditingController();
  final focusNode = FocusNode();
  final ValueNotifier<List<CompanyModel>> companyList = ValueNotifier([]);
  late CompanyCubit companyCubit;


  @override
  Widget build(BuildContext context) => _SearchCompaniesPageView(this);

  @override
  void initState() {
    super.initState();
    companyCubit = context.read<CompanyCubit>();
    // if(!widget.initialLocation.isNullOrEmpty()){
    //   textEditingController.text = widget.initialLocation!;
    //   _onTextFieldChanged(widget.initialLocation!);
    // }else {
    //   final user = AppStorage.currentUserSession;
    //   if(user != null && !user.location.isNullOrEmpty()){
    //     final location = user.location ?? '';
    //     textEditingController.text = location;
    //     _onTextFieldChanged(location);
    //   }
    // }
  }

  void _onTextFieldChanged(String? searchText) async{

    EasyDebounce.debounce(
        'company-search-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          debugPrint('searchText: $searchText');

          if(searchText.isNullOrEmpty()) {
            companyList.value = [];
            return;
          }

          final companiesResponse = await companyCubit.searchCompanies(keyword: searchText!);
          if(companiesResponse == null) {
            return;
          }

          companyList.value = companiesResponse;

        }
    );

  }

  void _onItemTapped(CompanyModel company){
    pop(context, company);
  }

  void handleAddNewCompany() async {
      final company = (await pushScreen(context, AddCompanyPage(title: widget.title,))) as CompanyModel?;
      if(company == null){
        return;
      }

      textEditingController.text = company.name ?? '';
      _onTextFieldChanged(company.name ?? '');

  }


  @override
  void dispose() {
    super.dispose();
  }

}