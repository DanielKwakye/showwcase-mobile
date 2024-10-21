import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_linear_loading_indicator_widget.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_cubit.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_enums.dart';
import 'package:showwcase_v3/features/spaces/data/bloc/spaces_state.dart';
import '../../../shared/presentation/widgets/custom_inner_page_sliver_app_bar.dart';

class SpacesEditorPage extends StatefulWidget {

  const SpacesEditorPage({Key? key}) : super(key: key);

  @override
  SpacesEditorPageController createState() => SpacesEditorPageController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SpacesEditorPageView extends WidgetView<SpacesEditorPage, SpacesEditorPageController> {

  const _SpacesEditorPageView(SpacesEditorPageController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        body: SafeArea(
          child: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              CustomInnerPageSliverAppBar(pageTitle: "Create your space", actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton(onPressed: () {
                    state.handleCreateSpace();
                  }, child: const Text("Create", style: TextStyle(color: kAppBlue, fontWeight: FontWeight.bold),)),
                )
              ],),
              SliverToBoxAdapter(
                child: BlocBuilder<SpacesCubit, SpacesState>(
                  builder: (context, spaceState) {
                    if(spaceState.status == SpacesStatus.createNewSpaceInProgress) {
                      return const CustomLinearLoadingIndicatorWidget();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              )
            ];
          }, body: SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: threadSymmetricPadding, vertical: threadSymmetricPadding),
                child: Column(
                   children: [
                     TextField(
                       inputFormatters: [
                         LengthLimitingTextInputFormatter(80),
                       ],
                       controller: state.titleController,
                       textCapitalization: TextCapitalization.sentences,
                       cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
                       style: TextStyle(
                           color: theme.colorScheme.onBackground,
                           fontSize: 17,
                           fontWeight: FontWeight.bold
                       ),
                       maxLines: null, // makes text field grow downwards
                       decoration: const InputDecoration(
                           enabledBorder: InputBorder.none,
                           focusedBorder: InputBorder.none,
                           hintText:  'What do you want to talk about?',
                           hintStyle: TextStyle(
                             fontSize: 17,
                           ),
                           // contentPadding: const EdgeInsets.only(top: 0),
                           // contentPadding: EdgeInsets.zero,


                       ),

                     )
                   ],
                ),
              ),
            ),
          ),

          ),
        )
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SpacesEditorPageController extends State<SpacesEditorPage> {

  final TextEditingController titleController = TextEditingController();
  late SpacesCubit spacesCubit;
  late StreamSubscription<SpacesState> spacesStateStreamSubscription;

  @override
  Widget build(BuildContext context) => _SpacesEditorPageView(this);

  @override
  void initState() {
    spacesCubit = context.read<SpacesCubit>();
    spacesStateStreamSubscription = spacesCubit.stream.listen((event) {
      if(event.status == SpacesStatus.createNewSpaceFailed) {
        context.showSnackBar(event.message);
      }
      if(event.status == SpacesStatus.createNewSpaceSuccessful) {
        pop(context);
      }
    });
    super.initState();
  }

  void handleCreateSpace() {
    if(titleController.text.isEmpty) {
      context.showSnackBar("Title required");
      return;
    }
    spacesCubit.createNewSpace(title: titleController.text);
  }


  @override
  void dispose() {
    titleController.dispose();
    spacesStateStreamSubscription.cancel();
    super.dispose();
  }

}