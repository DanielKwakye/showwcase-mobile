import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanoid/nanoid.dart';
import 'package:showwcase_v3/core/utils/reorder_proxy_util.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_cubit.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_enum.dart';
import 'package:showwcase_v3/features/shared/data/bloc/shared_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/social_link_item_widget.dart';

/// listener param's structure -> array<id: String, icon:SocialLinkIconModel, link:String, toolTip:String>
class SocialLinkListWidget extends StatefulWidget {

  final Function(List<Map<String, dynamic>>)? listener;
  final bool showTooltip ;
  const SocialLinkListWidget({Key? key, this.listener,  this.showTooltip = true}) : super(key: key);

  @override
  SocialLinkListWidgetController createState() => SocialLinkListWidgetController();

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SocialLinksWidgetView extends WidgetView<SocialLinkListWidget, SocialLinkListWidgetController> {

  const _SocialLinksWidgetView(SocialLinkListWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocBuilder<SharedCubit, SharedState>(
      buildWhen: (_, next){
        return next.status == SharedStatus.fetchSocialLinksSuccessful;
      },
      builder: (context, sharedState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [

             /// header ----
             Row(
               children: [
                 Text("Add links", style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
                 const Spacer(),
                 if(sharedState.status == SharedStatus.fetchSocialLinksInProgress) ... {
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),
                    )
                 }else if(sharedState.status == SharedStatus.fetchSocialLinksSuccessful) ...{
                   ClipRRect(
                     borderRadius: BorderRadius.circular(100),
                     child:  Container(
                       width: 35,
                       height: 35,
                       color: theme.colorScheme.outline,
                       child: IconButton(
                         icon: Icon(Icons.add, size: 16, color: theme.colorScheme.onBackground,),
                         onPressed: state.handleAddLinkAction,
                       ),
                     ),
                   ),
                 }
               ],
             ),

             // const SizedBox(height: 5,),

             ValueListenableBuilder<List<Map<String, dynamic>>>(valueListenable: state.addedSocialLinkValues, builder: (_, addedSocialLinkValues, __) {

               if(addedSocialLinkValues.length < 2){
                 return const SizedBox(height: 5,);
               }

               return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text('Long press to select item and then drag to arrange', style: TextStyle(color: kAppBlue, fontSize: 12) ,),
                    ),
                    SizedBox(height: 15,),
                  ],
               );

             }),

             /// body -----
             ValueListenableBuilder<List<Map<String, dynamic>>>(valueListenable: state.addedSocialLinkValues, builder: (_, addedSocialLinkValues, __) {
               return ReorderableListView.builder(itemBuilder:  (c, i) {
                 final item = addedSocialLinkValues[i];
                 return Padding(
                     key: ValueKey(item["id"]),
                     padding: EdgeInsets.only(bottom: (i != addedSocialLinkValues.length - 1) ? 15 : 0),
                     child: SocialLinkItemWidget(
                        initialValue: item,
                        showTooltip: widget.showTooltip,
                        allSocialIcons: sharedState.socialLinkIcons, onDelete: state.handleLinkItemDeleteAction,
                        onChange: state.onLinkItemValuesChanged,
                   ),
                 );

               }, itemCount: addedSocialLinkValues.length,
                   onReorder: (oldIndex, newIndex) => state.onReOrder(addedSocialLinkValues, oldIndex, newIndex),
               shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                 proxyDecorator: (widget, _, __){
                    return ReOrderProxyUtil(child: widget);
                 },


               );
             })
           ],
        );
      },
    );
    
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SocialLinkListWidgetController extends State<SocialLinkListWidget> {

  late SharedCubit sharedCubit;
  late StreamSubscription<SharedState> sharedStateStreamSubscription;
  final ValueNotifier<List<Map<String, dynamic>>> addedSocialLinkValues = ValueNotifier(const []);

  @override
  Widget build(BuildContext context) => _SocialLinksWidgetView(this);

  @override
  void initState() {
    super.initState();
    sharedCubit = context.read<SharedCubit>();
    sharedCubit.fetchSocialLinkIcons();

    if(sharedCubit.state.socialLinkIcons.isNotEmpty){
      addedSocialLinkValues.value = [{
        "id" : nanoid(),
        "icon" :  sharedCubit.state.socialLinkIcons.firstOrNull,
        "toolTip": "",
        "link": "",
      }];
    }

    sharedStateStreamSubscription = sharedCubit.stream.listen((event) {
      if(event.status == SharedStatus.fetchSocialLinksSuccessful){

          if(addedSocialLinkValues.value.isEmpty){
            addedSocialLinkValues.value = [{
              "id" : nanoid(),
              "icon" :  event.socialLinkIcons.firstOrNull,
              "toolTip": "",
              "link": "",
            }];
          }

      }
    });

  }

  void onLinkItemValuesChanged(Map<String, dynamic> value){

    final copiedArray = [...addedSocialLinkValues.value];
    final addedItemIndex = copiedArray.indexWhere((element) => element['id'] == value['id']);
    if(addedItemIndex < 0){
      return;
    }
    copiedArray[addedItemIndex] = value;
    addedSocialLinkValues.value = copiedArray;

    debugPrint("customLog: onLinkItemValuesChanged -> ${addedSocialLinkValues.value}");
    widget.listener?.call(addedSocialLinkValues.value);


  }

  void handleLinkItemDeleteAction(String? id) {
    if(id == null) {
      return;
    }
    final updatedTemplates = [...addedSocialLinkValues.value];
    updatedTemplates.removeWhere((element) => element["id"] == id);
    addedSocialLinkValues.value = updatedTemplates;
    widget.listener?.call(addedSocialLinkValues.value);
  }


  void handleAddLinkAction() {

    final updatedTemplates = [...addedSocialLinkValues.value];
    updatedTemplates.add({
      "id" : nanoid(),
      "icon" :  sharedCubit.state.socialLinkIcons.firstOrNull,
      "toolTip": "",
      "link": "",
    });
    addedSocialLinkValues.value = updatedTemplates;

  }

  void onReOrder(List<Map<String, dynamic>> items , int oldIndex, int newIndex){
    if (oldIndex < newIndex) {
    newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    addedSocialLinkValues.value = [...items];
    widget.listener?.call(addedSocialLinkValues.value);

  }

  @override
  void dispose() {
    super.dispose();
    sharedStateStreamSubscription.cancel();
  }



}