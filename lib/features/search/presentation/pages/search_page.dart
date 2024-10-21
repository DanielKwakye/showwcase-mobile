import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_cubit.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_enums.dart';
import 'package:showwcase_v3/features/search/data/bloc/search_state.dart';
import 'package:showwcase_v3/features/search/presentation/pages/search_top_results_page.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';

class SearchPage extends StatefulWidget {

  final String? searchText;
  const SearchPage({Key? key, this.searchText}) : super(key: key);

  @override
  SearchPageController createState() => SearchPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SearchPageView extends WidgetView<SearchPage, SearchPageController> {

  const _SearchPageView(SearchPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(

        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              /// Search app bar
              SliverAppBar(
                // automaticallyImplyLeading: true,
                backgroundColor: theme.colorScheme.background,
                iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
                pinned: true,
                elevation: 0,
                // title: ,
                // expandedHeight: kToolbarHeight,
                actions: [
                  UnconstrainedBox(
                    child: SizedBox(
                      width: width(context) - 50,
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: _searchBar(theme),
                      ),
                    ),
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, searchState) {
                      if(searchState.status == SearchStatus.searchInProgress){
                        return const CustomLinearLoadingIndicatorWidget();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

              //! search loader
              // const SliverToBoxAdapter(
              //   child: CustomLinearLoadingIndicatorWidget(),
              // )

            ];
          },
          body: BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (_, next){
              return next.status == SearchStatus.searchSuccessful;
            },
            builder: (_, searchState) {
              return SearchTopResultsPage(topSearchModel: searchState.topSearch,);
            },
          ),

        )
    );

  }

  Widget _searchBar(ThemeData theme) {
    return  TextField(
        controller: state.searchTextEditingController,
      onChanged: (value) => state._onSearchTextChanged(text: value),
      focusNode: state.searchFocusNode,
      onSubmitted: (value) =>  state._onSearchSubmitted(text: value),
      decoration: InputDecoration(
        filled: true,
        fillColor:   theme.brightness == Brightness.light ? kAppLightGray : kDarkOutlineColor.withOpacity(0.5),
        hintText: 'Search',
        hintStyle: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.5), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 0),
         borderRadius: BorderRadius.circular(100),),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 0),
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 0),
          borderRadius: BorderRadius.circular(100),
        ),
        suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: state.searchActivated,
            builder: (ctx, activated, ch) {
              if(!activated) return const SizedBox.shrink();
              return IconButton(onPressed: () => state.searchActivated.value = false , icon:
              UnconstrainedBox(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: kAppBlue,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: const Icon(Icons.close, color: kAppWhite, size: 12,),
                ),
              ));
            }
        ),
          prefixIconConstraints: const BoxConstraints(maxWidth: 50),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: UnconstrainedBox(child: SvgPicture.asset(kSearchIconSvg, width: 14,colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary.withOpacity(0.5), BlendMode.srcIn))),
          ),
      ),

    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SearchPageController extends State<SearchPage> {

  late ScrollController scrollController;
  late TabController tabController;
  TextEditingController searchTextEditingController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  ValueNotifier<bool> searchActivated = ValueNotifier(false); // to show close and search action buttons
  late SearchCubit searchCubit;

  @override
  Widget build(BuildContext context) => _SearchPageView(this);

  @override
  void initState() {
    searchCubit = context.read<SearchCubit>();
    onWidgetBindingComplete(onComplete: () {
      if(!widget.searchText.isNullOrEmpty()) {
        String message = widget.searchText ?? '';
        message = message.replaceAll("\n", "");
        message = message.replaceAll(" ", "");
        if(message.startsWith('#')){
          message = message.substring(1);
        }
        searchTextEditingController.text = message;
        _onSearchTextChanged(text: message);
      }
      searchFocusNode.requestFocus();
    });
    super.initState();
  }

  void _onSearchTextChanged({required String text}) {
    EasyDebounce.debounce(
        'general-search-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 400), // <-- The debounce duration
            () {

          if(searchTextEditingController.text.isEmpty) {
            return;
          }
          searchCubit.search(searchText: text);
        });
  }

  void _onSearchSubmitted({required String text}){

    if(text.isEmpty) { // don't search if the search is empty
      return;
    }
    // push to search results tabs page
    context.push(context.generateRoutePath(subLocation: searchResultsPage), extra: text);
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchTextEditingController.dispose();
    super.dispose();
  }

}