import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/features/file_manager/presentation/widgets/custom_gallery_asset_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

import '../../../../core/utils/widget_view.dart';

class AlbumsPage extends StatefulWidget {

  final RequestType requestType;
  final int selectedAlbumIndex;
  final Function({required int albumIndex, required String albumName})? onAlbumSelected;
  const AlbumsPage({
    this.requestType = RequestType.all,
    this.selectedAlbumIndex = 0,
    this.onAlbumSelected,
    Key? key}) : super(key: key);

  @override
  AlbumsPageController createState() => AlbumsPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _AlbumsPageView extends WidgetView<AlbumsPage, AlbumsPageController> {

  const _AlbumsPageView(AlbumsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final textStyle = TextStyle(color: theme.colorScheme.onBackground,fontSize: defaultFontSize);

    return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Albums', style: TextStyle(color: theme.colorScheme.onBackground,fontSize: 18),),
                iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
                pinned: true,
                centerTitle: true,
                elevation: 0,
                backgroundColor: theme.colorScheme.primary,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                    child: TextButton(onPressed: state._onCancelButtonTapped, child: Align(alignment: Alignment.centerLeft, child: Text('Cancel', style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.normal, fontSize: 18),),))),
                leadingWidth: mediaQuery.size.width,
                bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: CustomBorderWidget()
                ),
              ),

              // SliverToBoxAdapter(
              //   child: GestureDetector(
              //     onTap: () {
              //
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              //       child: Row(
              //         children: [
              //           Text('All Photos', style: textStyle,),
              //           const Spacer(),
              //           const Icon(Icons.check_circle, color: Colors.green, size: 18,)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              ValueListenableBuilder<List<AssetPathEntity>>(
                  valueListenable: state.albums,
                  builder: (ctx, albums, _) {

                   return SliverList(delegate: SliverChildBuilderDelegate((ctx, i)  {

                     final album = albums[i];
                     final albumName = album.name;
                     final firstAsset =  album.getAssetListRange(
                       start: 0, // start at index 0
                       end: 1, // end at the first index
                     );

                     return InkWell(
                       onTap: () {
                         state.onAlbumSelected(index: i, albumName: albumName);
                       },
                       child: Padding(
                         padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             FutureBuilder<List<AssetEntity>>(
                               future: firstAsset,
                               builder: (ctx, AsyncSnapshot<List<AssetEntity>> result){
                                 if(result.connectionState == ConnectionState.waiting){
                                   return _placeHolder(context, child: const Center(child: CupertinoActivityIndicator(),));
                                 }else if(result.hasError){
                                   return _placeHolder(context, );
                                 }else{
                                   final assets = result.data;
                                   if(assets == null || assets.isEmpty) {
                                     return _placeHolder(context, );
                                   }
                                   final asset = assets.first;

                                   return Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       _placeHolder(context, child: CustomGalleryAssetWidget(asset: asset, onItemTap: (_, __, ___) {
                                         state.onAlbumSelected(index: i, albumName: albumName);
                                       },)),
                                       const SizedBox(width: 10,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisSize: MainAxisSize.min,
                                         children: <Widget>[
                                           Text(albumName , style: textStyle),
                                           //Text(!asset.title.isNullOrEmpty() ? asset.title! : 'album', style: textStyle),
                                           FutureBuilder<int>(
                                             future: album.assetCountAsync,
                                             builder: (ctx, AsyncSnapshot<int> resultSnapshot){
                                               if(resultSnapshot.connectionState == ConnectionState.waiting){
                                                 return const SizedBox.shrink();
                                               }else if(resultSnapshot.hasError){
                                                 return const SizedBox.shrink();
                                               }else{
                                                 if(resultSnapshot.data == null || resultSnapshot.data == 0) {
                                                   return  const SizedBox.shrink();
                                                 }
                                                 final assetCount = resultSnapshot.data;
                                                 return Column(
                                                   mainAxisSize: MainAxisSize.min,
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: <Widget>[
                                                     Text("$assetCount", style: textStyle.copyWith(color: theme.colorScheme.onPrimary, fontSize: defaultFontSize - 2)),
                                                     const SizedBox(height: 4,),
                                                   ],
                                                 );
                                               }
                                             },
                                           ),

                                         ],
                                       )
                                     ],
                                   );

                                   // return FutureBuilder<File?>(
                                   //   future: asset.file,
                                   //   builder: (c, AsyncSnapshot<File?> result2) {
                                   //
                                   //     if(result2.connectionState == ConnectionState.waiting){
                                   //       return _placeHolder(child: const Center(child: CupertinoActivityIndicator(),));
                                   //     }else if(result2.hasError){
                                   //       return _placeHolder();
                                   //     }else {
                                   //       final file = result2.data;
                                   //       if(file == null) {
                                   //         return _placeHolder();
                                   //       }
                                   //
                                   //       return ;
                                   //
                                   //     }
                                   //   },
                                   // );
                                 }
                               },
                             ),
                             if(i == widget.selectedAlbumIndex) ... {
                               const Icon(Icons.check_circle, color: Colors.green, size: 18,)
                             }
                           ],
                         ),
                       ),
                     );

                    }, childCount: albums.length));

              })

            ],
          ),
        );
  }

  Widget _placeHolder(BuildContext context, {Widget? child, bool showBackground = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 50,
        height: 50,
        color: showBackground ? theme(context).colorScheme.background : Colors.transparent,
        child: child,
      ),
    );
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class AlbumsPageController extends State<AlbumsPage> {

  ValueNotifier<List<AssetPathEntity>> albums = ValueNotifier([]);
  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }
  @override
  Widget build(BuildContext context) => _AlbumsPageView(this);

  /// Fetch images from user gallery
  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albumList  = await PhotoManager.getAssetPathList(
        type: widget.requestType
    );
    albums.value = albumList;

  }

  void _onCancelButtonTapped(){
    pop(context);
  }

  void onAlbumSelected({required index, required albumName}) {
    if(widget.onAlbumSelected != null) {
      widget.onAlbumSelected?.call(albumIndex: index, albumName: albumName);
      pop(context);
    }
  }

}