import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/sliver_persistent_header_delegate_impl.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_adaptive_circular_indicator.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_error_widget.dart';
import 'package:tenor/tenor.dart';

class GifsPickerPage extends StatefulWidget {

  final Function(TenorResult)? onTap;
  const GifsPickerPage({Key? key, this.onTap}) : super(key: key);

  @override
  GifsPickerPageController createState() => GifsPickerPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _GifsPickerPageView extends WidgetView<GifsPickerPage, GifsPickerPageController> {

  const _GifsPickerPageView(GifsPickerPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.outline,
        body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                      maxExtent: kToolbarHeight,
                      child: Container(
                        color: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Theme(
                                data: theme.copyWith(
                                    cupertinoOverrideTheme: CupertinoThemeData(
                                  primaryColor: theme.colorScheme.onPrimary,
                                )),
                                child: CupertinoSearchTextField(
                                  onChanged: state._onGifSearch,
                                  style: TextStyle(
                                      color: theme.colorScheme.onBackground),
                                  borderRadius: BorderRadius.circular(100),
                                  // cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                                  // decoration:  const InputDecoration(
                                  //     prefixIcon: Icon(Icons.search),
                                  //   // fillColor:  theme.brightness == Brightness.light ? kAppLightGray : kDarkOutlineColor,
                                  //     filled: true,
                                  //     border: InputBorder.none,
                                  //     enabledBorder: InputBorder.none,
                                  //     // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                  //     // contentPadding:  EdgeInsets.symmetric(horizontal: 15),
                                  //     hintText: 'Search gif...',
                                  //     // hintStyle:  TextStyle(fontSize: 13)
                                  // ),
                                ),
                              ),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Done',
                                    style: theme.textTheme.headline6?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ))
                          ],
                        ),
                      )),
                )
              ];
        }, body: PagedGridView<int, TenorResult>(
          showNewPageProgressIndicatorAsGridChild: false,
          showNewPageErrorIndicatorAsGridChild: false,
          showNoMoreItemsIndicatorAsGridChild: false,
          pagingController: state.pagingController,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 100 / 100,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 3,
          ),
          builderDelegate: PagedChildBuilderDelegate<TenorResult>(
              itemBuilder: (context, item, index) {
                return GestureDetector(
                  onTap: () => state._onGifItemSelected(item),
                  child: CachedNetworkImage(
                    imageUrl: item.media!.gif!.url!,
                    errorWidget: (context, url, error) => const SizedBox.shrink(),
                    placeholder: (ctx, url) => const Center(
                      child: CustomAdaptiveCircularIndicator(),
                    ),
                    cacheKey: "${item.media!.gif!.url!}${item.id!}",
                    fit: BoxFit.cover,
                  ),
                );
              },
              firstPageErrorIndicatorBuilder: (ctx) {
                return CustomErrorWidget(onRefreshTapped: () => state.pagingController.refresh());
              },
              firstPageProgressIndicatorBuilder: (ctx) {
                return const Center(
                  child: SizedBox(width: 50, height: 50, child: CustomAdaptiveCircularIndicator(),),
                );
              },
              newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink()
          ),
        )
        //   Column(
        //   children: <Widget>[
        //
        //     Expanded(child:
        //     // BlocConsumer<SharedCubit, SharedState>(
        //     //   listener: state._sharedCubitListener,
        //     //   bloc: state._sharedCubit,
        //     //   builder: (context, bloc) {
        //     //
        //     //     if(bloc is GifLoading) {
        //     //       return const Center(
        //     //         child: CupertinoActivityIndicator(),
        //     //       );
        //     //     }
        //     //
        //     //     if(bloc is GifSuccess){
        //     //
        //     //       return GridView.builder(
        //     //         controller: widget.controller,
        //     //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     //           crossAxisCount: 3,
        //     //           mainAxisSpacing: 0,
        //     //           crossAxisSpacing: 0,
        //     //           // width / height: fixed for *all* items
        //     //           childAspectRatio: 1/1,
        //     //         ),
        //     //         // return a custom ItemCard
        //     //         itemBuilder: (context, i) {
        //     //           final gifItem = bloc.gifList[i];
        //     //
        //     //
        //     //           return GestureDetector(
        //     //             onTap: () => state._onGifItemSelected(gifItem),
        //     //             child: CachedNetworkImage(
        //     //               imageUrl: gifItem.media!.gif!.url!,
        //     //               errorWidget: (context, url, error) => const SizedBox.shrink(),
        //     //               placeholder: (ctx, url) => const Center(
        //     //                 child: CupertinoActivityIndicator(),
        //     //               ),
        //     //               cacheKey: "${gifItem.media!.gif!.url!}${gifItem.id!}",
        //     //               fit: BoxFit.cover,
        //     //             ),
        //     //           );
        //     //         },
        //     //         itemCount: bloc.gifList.length,
        //     //       );
        //     //
        //     //     }
        //     //
        //     //     return const Center(
        //     //       child: CustomNoConnectionWidget(title: "Unable to fetch gif...",),
        //     //     );
        //     //
        //     //   },
        //     // )
        //     )
        //   ],
        // ),
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class GifsPickerPageController extends State<GifsPickerPage> {

  late FileManagerCubit fileManagerCubit;
  // page key is page index. Starting from 0, 1, 2 .........
  final PagingController<int, TenorResult> pagingController = PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context) => _GifsPickerPageView(this);

  @override
  void initState() {
    super.initState();
    fileManagerCubit = context.read<FileManagerCubit>();

    pagingController.addPageRequestListener((pageKey) async {
      final response = await fileManagerCubit.fetchTrendingGifs(limit: 20);
      if(response.isLeft()){
        pagingController.error = response.asLeft();
        return;
      }
      final newItems = response.asRight();
      pagingController.appendLastPage(newItems);
    });

  }

  void _onGifItemSelected(TenorResult gifItem){

    if(widget.onTap != null){
      widget.onTap!(gifItem);
    }
    Navigator.of(context).pop();
  }



  @override
  void dispose() {
    super.dispose();
  }

  _onGifSearch(String text){
    EasyDebounce.debounce(
        'search-gifs-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500), // <-- The debounce duration
            () async {
          final either = await fileManagerCubit.searchGifs(limit: 50, keyword: text);
          if(either.isRight()){
            pagingController.value = PagingState(
                nextPageKey: 1,
                itemList: either.asRight()
            );
          }

        }
    );

  }

}