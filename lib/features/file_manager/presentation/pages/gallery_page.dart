import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/file_manager/presentation/pages/albums_page.dart';
import 'package:showwcase_v3/features/file_manager/presentation/widgets/custom_gallery_asset_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_circular_loader.dart';


/// Implementing in-app gallery
/// ref -> https://dev.to/aouahib/build-a-flutter-gallery-to-display-all-the-photos-and-videos-in-your-phone-pb6
// even if multiple is set to true, GalleryPage will still return one item if the selected item is a video
// or the selected item is from camera
class GalleryPage extends StatefulWidget {

  final RequestType requestType; // By default, galley shows only images
  final bool multiple;
  const GalleryPage({Key? key,
    this.requestType = RequestType.image,
    this.multiple = false
  }) : super(key: key);

  @override
  GalleryPageController createState() => GalleryPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _GalleryPageView extends WidgetView<GalleryPage, GalleryPageController> {

  const _GalleryPageView(GalleryPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
          body: CustomScrollView(
              slivers: [
                ValueListenableBuilder(valueListenable: state.selectedFiles,
                  builder: (BuildContext context, Map<int, File> values, Widget? child) {
                    return SliverAppBar(
                      title: GestureDetector(
                        onTap: () {
                          pushScreen(context,
                              AlbumsPage(
                                requestType: state.requestType,
                                selectedAlbumIndex: state.albumIndex,
                                onAlbumSelected: ({required int albumIndex, required String albumName}) {
                                state._fetchAssets(albumIndex: albumIndex);
                              },)
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<String>(
                                    valueListenable: state.albumName, builder: (_, String albumName, __) {
                                  return Text(albumName, style: TextStyle(color: theme.colorScheme.onBackground,fontSize: 15),);
                                }),
                                const SizedBox(width: 5,),
                                 Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onBackground,)
                              ],
                            ),
                            if(values.isNotEmpty)...{
                              Text('${values.length} item(s) selected', style: TextStyle(color: theme.colorScheme.onBackground,fontSize: 12),),
                            }
                          ],
                        ),
                      ),
                      iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: theme.colorScheme.primary,
                      leading: TextButton(onPressed: state._onCancelButtonTapped, child: Align(alignment: Alignment.centerLeft, child: Text('Cancel', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: kAppBlue, fontSize: 15),),)),
                      leadingWidth: mediaQuery.size.width / 3,
                      bottom: const PreferredSize(
                          preferredSize: Size.fromHeight(2),
                          child: CustomBorderWidget()
                      ),
                      actions: [
                        if(values.isNotEmpty) ... {
                          TextButton(onPressed: state._onConfirmMultipleSelectedFilesTapped, child: Align(alignment: Alignment.centerLeft, child: Text('Add', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: kAppBlue, fontSize: 15),),)),
                        }
                      ],
                    );
                  },
                ),

                ValueListenableBuilder<List<AssetEntity>>(
                    valueListenable: state.assets,
                    builder: (_, assets, __ ) {
                      if(state.loadingAssets) {
                        return const SliverFillRemaining(child: Center(child: CustomCircularLoader(),),);
                      }

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: mediaQuery.size.width / 3,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          // childAspectRatio: 4.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            // The first item on grid allows user to use camera
                            if(index == 0) {
                              return GestureDetector(
                                onTap: state._openCamera,
                                child: Container(width: double.infinity,
                                  color: theme.brightness == Brightness.light ? theme.colorScheme.outline : theme.colorScheme.primary,
                                  child: UnconstrainedBox(child: SvgPicture.asset(kCameraIconSvg,
                                      colorFilter: ColorFilter.mode(theme.brightness == Brightness.light ? theme.colorScheme.onBackground : kAppBlue , BlendMode.srcIn),
                                    width: 30,)),
                                ),
                              );
                            }

                            final currentIndex = index - 1;

                            final asset = assets[currentIndex];
                            if(asset.type != AssetType.image && asset.type != AssetType.video) return const SizedBox.shrink();
                            return CustomGalleryAssetWidget(
                                asset: asset,
                                onItemTap:  (file, assetType, selected) =>
                                    state._onAssetItemTapped(file, assetType, currentIndex, selected)
                            );


                          },
                          childCount: assets.length + 1,
                        ),
                      );

                    }
                )
              ],
            ),
        );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class GalleryPageController extends State<GalleryPage> {

  // This will hold all the assets we fetched
  ValueNotifier<List<AssetEntity>> assets = ValueNotifier([]);
  bool loadingAssets = false;
  ValueNotifier<String> albumName = ValueNotifier('Recent');
  int albumIndex = 0;
  ValueNotifier<Map<int, File>> selectedFiles = ValueNotifier({});
  late RequestType requestType;
  final ImagePicker picker = ImagePicker();



  @override
  Widget build(BuildContext context) => _GalleryPageView(this);

  @override
  void initState() {
    super.initState();
    requestType = widget.requestType;
    _fetchAssets(albumIndex: albumIndex);
  }

  //
  void _onAssetItemTapped(File file, AssetType assetType, int index, bool selected){
    // file item retrieved
    if(!widget.multiple){
      // return file to the caller of this class
      pop(context, file);
      return;
    }

    // we can't select multiple videos --- cus we need to trim the video first
    if(requestType == RequestType.video){
      // return file to the caller of this class
      pop(context, file);
      return;
    }

    // if user can select multiple files

    if(selected){

      // once the user selects a video just return only the single video
      if(requestType != RequestType.image){
        final fileType = getFileType(path: file.path);

        if(fileType == null) {
          context.showSnackBar("Unable to determine selected video type", appearance: Appearance.primary);
          return;
        }

        if((fileType['type'] as RequestType) == RequestType.video){
          pop(context, file);
        }
      }

      final items = {...selectedFiles.value};
      // if item is not selected add it
      items.addAll({index: file});

      selectedFiles.value = items;

    }else{

      // if item is already selected remove it
      final items = {...selectedFiles.value};
      if(selectedFiles.value.containsKey(index)){
        items.remove(index);
      }
      selectedFiles.value = items;

    }


  }



  void _openCamera() async {

    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if(image == null) {
      return;
    }
    if(!mounted){
      return;
    }
    final file = File(image.path);

    if(widget.multiple){
      pop(context, <File>[file]); // return a list of files if caller expects multiple
      return;
    }
    pop(context, file);



  }

  // when user selects multiple files and clicks the add button at the top right
  void _onConfirmMultipleSelectedFilesTapped(){
    final List<File> files = selectedFiles.value.values.toList();
    pop(context, files);

  }

  void _onCancelButtonTapped(){
    pop(context);
  }

  /// Fetch images from user gallery
  _fetchAssets({required int albumIndex}) async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    loadingAssets = true;
    final albums = await PhotoManager.getAssetPathList(
      type: requestType
    );
    final selectedAlbum = albums[albumIndex];

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await selectedAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    albumName.value = selectedAlbum.name;
    loadingAssets = false;
    assets.value = recentAssets;
    this.albumIndex = albumIndex;

  }

}