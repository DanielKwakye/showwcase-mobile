import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/injector.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_cubit.dart';
import 'package:showwcase_v3/features/spaces/data/models/space_model.dart';
import 'package:showwcase_v3/features/spaces/data/repositories/spaces_repository.dart';

class ActiveSpacePage extends StatefulWidget {

  final SpaceModel space;
  const ActiveSpacePage({Key? key, required this.space}) : super(key: key);

  @override
  ActiveSpacePageController createState() => ActiveSpacePageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _ActiveSpacePageView extends WidgetView<ActiveSpacePage, ActiveSpacePageController> {

  const _ActiveSpacePageView(ActiveSpacePageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final currentUser = AppStorage.currentUserSession!;
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: CloseButton(color: theme.colorScheme.onBackground,),
          actions: [
            if(currentUser.username == widget.space.creator.username) ... {
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(onPressed: () {
                  state.spacesCubit.closeSpace(spaceModel: widget.space, localVideo: state._localRenderer);
                }, child: const Text("End space", style: TextStyle(color: kAppRed, fontWeight: FontWeight.bold),)),
              )
            }
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child:  CustomBorderWidget(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Text("Participants", style: theme.textTheme.titleLarge,),
                const SizedBox(height: 0,),
                 Expanded(child: Row(
                   children: [
                     Expanded(child: RTCVideoView(state._localRenderer, mirror: true)),
                     Expanded(child: RTCVideoView(state._remoteRenderer, mirror: true,)),
                   ],
                 ))
             ],
          ),
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class ActiveSpacePageController extends State<ActiveSpacePage> {

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late SpacesCubit spacesCubit;

  @override
  Widget build(BuildContext context) => _ActiveSpacePageView(this);

  @override
  void initState() {
    spacesCubit = context.read<SpacesCubit>();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    sl<SpacesRepository>().openUserMedia(_localRenderer, _remoteRenderer);
    super.initState();
  }


  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }



}