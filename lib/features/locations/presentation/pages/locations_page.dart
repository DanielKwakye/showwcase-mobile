import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_cubit.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_enum.dart';
import 'package:showwcase_v3/features/locations/data/bloc/location_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';


/// This is a helper class for selecting location
class LocationsPage extends StatefulWidget {

  final String? pageTitle;
  final String? initialLocation;
  const LocationsPage({
    this.pageTitle,
    this.initialLocation,
    Key? key}) : super(key: key);

  @override
  LocationsPageController createState() => LocationsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SelectLocationPageView extends WidgetView<LocationsPage, LocationsPageController> {

  const _SelectLocationPageView(LocationsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const CustomInnerPageSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextFieldWidget(
                focusNode: state.focusNode,
                controller: state.textEditingController,
                label: 'Search location',
                onChange: state._onTextFieldChanged,
                placeHolder: 'eg. india',
                prefixIcon: Padding(padding: const EdgeInsets.all(15), child: SvgPicture.asset(
                  kLocationIconSvg,
                  colorFilter: ColorFilter.mode(theme.colorScheme.onPrimary, BlendMode.srcIn),
                ),),
              ),
            ),
          ),
          // SliverToBoxAdapter(child: SizedBox(height: 1.h,),),

          ValueListenableBuilder<List<String>>(valueListenable: state.locationList, builder: (_, list, __) {
            return SliverToBoxAdapter(
                child: BlocBuilder<LocationCubit, LocationState>(
                  builder: (context, locationState) {
                    if(locationState.status == LocationStatus.searchLocationsInProgress){
                      return const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: SizedBox(
                          height: 50, width: double.maxFinite,
                          child: Center(
                            child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),
                          ),
                        ),
                      );
                    }
                    return list.isNotEmpty ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(6),
                          color: theme.colorScheme.primary,
                        ),
                        child: Column(
                          children: list.map((city) => ListTile(
                              onTap: () => state._onItemTapped(city),
                              title: Text(city, style: TextStyle(color: theme.colorScheme.onPrimary),)
                          )).toList(),
                        ) ,
                      ),
                    ) : const SizedBox.shrink();
                  },
                )
            );
          }),



        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class LocationsPageController extends State<LocationsPage> {

  final focusNode = FocusNode();
  final ValueNotifier<List<String>> locationList = ValueNotifier([]);
  late LocationCubit locationCubit;
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => _SelectLocationPageView(this);

  @override
  void initState() {
    super.initState();
    /// after page is done loading show keypad
    focusNode.requestFocus();
    locationCubit = context.read<LocationCubit>();
    if(!widget.initialLocation.isNullOrEmpty()){
        textEditingController.text = widget.initialLocation!;
        _onTextFieldChanged(widget.initialLocation!);
    }
    // else {
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
        'location-search-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

            debugPrint('searchText: $searchText');

            if(searchText.isNullOrEmpty()) {
              locationList.value = [];
              return;
            }

            final countryList = await locationCubit.searchLocations(keyword: searchText!);
            if(countryList == null) {
              return;
            }

            locationList.value = countryList;

        }
    );

  }

  void _onItemTapped(String city){
    pop(context, city);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    textEditingController.dispose();
  }

}