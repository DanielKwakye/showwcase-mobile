import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:separated_column/separated_column.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_social_link_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class SocialLinkItemWidget extends StatefulWidget {

  final List<SharedSocialLinkIconModel> allSocialIcons;
  final Function(String?)? onDelete;
  final Map<String, dynamic> initialValue;
  final Function(Map<String, dynamic>)? onChange;
  final bool showTooltip ;
  const SocialLinkItemWidget({Key? key, required this.initialValue, required this.allSocialIcons, this.onDelete, this.onChange,required this.showTooltip }) : super(key: key);

  @override
  SocialLinkItemWidgetController createState() => SocialLinkItemWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _SocialLinkItemWidgetView extends WidgetView<SocialLinkItemWidget, SocialLinkItemWidgetController> {

  const _SocialLinkItemWidgetView(SocialLinkItemWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Column(
       children: [
         /// Header toolbar
         Row(
           children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(100),
               child:  Container(
                 width: 35,
                 height: 35,
                 color: theme.colorScheme.outline,
                 child: IconButton(
                   icon: Icon(Icons.menu_rounded, size: 16, color: theme.colorScheme.onBackground,),
                   onPressed: () {
                   },
                 ),
               ),
             ),
             const SizedBox(width: 10,),
            if(widget.showTooltip) ValueListenableBuilder<bool>(valueListenable: state.toolTipIsEmpty, builder: (ctx, toolTipIsEmpty, __) {
               return ClipRRect(
                 borderRadius: BorderRadius.circular(100),
                 child:  Container(
                   width: 35,
                   height: 35,
                   color: toolTipIsEmpty ? theme.colorScheme.outline : Colors.green,
                   child: IconButton(
                     icon: Icon(Icons.info_outline, size: 16, color: toolTipIsEmpty ? theme.colorScheme.onBackground: kAppWhite,),
                     onPressed: () {
                       FocusScope.of(context).unfocus();
                       showAddToolTip(context);
                       Future.delayed(const Duration(milliseconds: 375,), (){
                         state.toolTipFocusNode.requestFocus();
                       });
                     },
                   ),
                 ),
               );
             }),
             const SizedBox(width: 10,),
             ClipRRect(
               borderRadius: BorderRadius.circular(100),
               child:  Container(
                 width: 35,
                 height: 35,
                 color: theme.colorScheme.outline,
                 child: IconButton(
                   icon: Icon(Icons.delete_sweep_outlined, size: 16, color: theme.colorScheme.onBackground,),
                   onPressed: () {
                     widget.onDelete?.call(widget.initialValue['id']);
                   },
                 ),
               ),
             ),
           ],
         ),
         const SizedBox(height: 10,),
         Row(
            children: [
               ValueListenableBuilder<SharedSocialLinkIconModel>(valueListenable: state.selectedIcon, builder: (_, selectedIcon, __) {
                 return GestureDetector(
                   behavior: HitTestBehavior.opaque,
                   onTap: () {
                     showIconList(context);
                   },
                   child: Container(
                     height: 48,
                     padding: const EdgeInsets.symmetric(horizontal: 12),
                     decoration: BoxDecoration(
                       color:  theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                       borderRadius: BorderRadius.circular(5),
                       border: Border.all(color: theme.colorScheme.outline)
                     ),
                     child: UnconstrainedBox(
                       child: Row(
                          children: [
                            SvgPicture.network(Uri.encodeFull(ApiConfig.socialImageUrl(selectedIcon.name ?? '') ?? ''),
                              // colorBlendMode: BlendMode.difference,
                              colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                              width: 20,
                              placeholderBuilder: (BuildContext
                              context) => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),),
                            ),
                            const SizedBox(width: 0,),
                            const Icon(Icons.keyboard_arrow_down_outlined)
                          ],
                       ),
                     ),
                   ),
                 );
               }),
               const SizedBox(width: 5,),
               Expanded( flex: 1, child: Builder(builder: (ctx){
                 return CustomTextFieldWidget(
                   placeHolder: 'eg. https://example.com',
                   controller: state.linkTextEditingController,
                   textCapitalization: TextCapitalization.none,
                   onChange: state.onLinkTextChange,
                 );
               })),
            ],
         )
       ],
    );

  }

  void showAddToolTip(BuildContext context) {
    final theme = Theme.of(context);
    final ch = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 0, bottom: kToolbarHeight),
        child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: Row(
                   children: [
                     SvgPicture.network(Uri.encodeFull(ApiConfig.socialImageUrl(state.selectedIcon.value.name ?? '') ?? ''),
                       // colorBlendMode: BlendMode.difference,
                       colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                       width: 20,
                       placeholderBuilder: (BuildContext
                       context) => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),),
                      ),
                      const SizedBox(width: 20,),
                      Text(state.selectedIcon.value.label ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),),
                     const Spacer(),
                     TextButton(onPressed: () {
                       pop(context);
                     }, child: const Text('Done', style: TextStyle(color: kAppBlue),))
                   ],
                ),
              ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: CustomTextFieldWidget(
                 label: 'Tooltip', placeHolder: '', controller: state.toolTipTextEditingController,
                 focusNode: state.toolTipFocusNode,
                 onChange: state.onToolTipChange,
                 maxLines: 4,
               ),
             ),
           ],
        ),
      ),
    );
    showCustomBottomSheet(context, child: ch);
  }

  void showIconList(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final size  = MediaQuery.of(ctx).size;
    final ch = ValueListenableBuilder<SharedSocialLinkIconModel>(valueListenable: state.selectedIcon, builder: (_, selectedIcon, __){
      return SizedBox(
        height: size.height * 0.7,
        child:  SingleChildScrollView(
          child: SeparatedColumn(
            mainAxisSize: MainAxisSize.min,
            separatorBuilder: (BuildContext context, int index) {
              return const CustomBorderWidget();
            },
            children: widget.allSocialIcons.map((e) => ListTile(
              dense: true,
              minLeadingWidth: 0,
              leading:  SvgPicture.network(Uri.encodeFull(ApiConfig.socialImageUrl(e.name ?? '') ?? ''),
                // colorBlendMode: BlendMode.difference,
                colorFilter: ColorFilter.mode(theme.colorScheme.onBackground, BlendMode.srcIn),
                width: 20,
                placeholderBuilder: (BuildContext
                context) => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kAppBlue, strokeWidth: 2,),),
              ),
              title: Text(e.label ?? ''),
              trailing: e == selectedIcon ? const Icon(Icons.check, color: Colors.green, size: 20,) : null,
              onTap: () {
                state.selectedIcon.value = e;
                state.value['icon'] = e;
                widget.onChange?.call(state.value);
                pop(ctx);
              },
            )).toList(),
          ),
        ),
      );
    });
    showCustomBottomSheet(ctx, child: ch, showDragHandle: true);
  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class SocialLinkItemWidgetController extends State<SocialLinkItemWidget> {

  late ValueNotifier<SharedSocialLinkIconModel> selectedIcon;
  final TextEditingController linkTextEditingController = TextEditingController();
  final TextEditingController toolTipTextEditingController = TextEditingController();
  final ValueNotifier<bool> toolTipIsEmpty = ValueNotifier(true);
  final FocusNode toolTipFocusNode = FocusNode();
  late Map<String, dynamic> value;


  @override
  Widget build(BuildContext context) => _SocialLinkItemWidgetView(this);

  @override
  void initState() {
    super.initState();
    selectedIcon = ValueNotifier(widget.initialValue["icon"] as SharedSocialLinkIconModel);
    value = widget.initialValue;

  }

  void onToolTipChange(String? text) {
    EasyDebounce.debounce(
        'tooltip-change-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

            value["toolTip"] = text;
            widget.onChange?.call(value);

            if(text.isNullOrEmpty()) {
              toolTipIsEmpty.value = true;
              return;
            }

            toolTipIsEmpty.value = false;


        }
    );
  }

  void onLinkTextChange(String? text) {
    EasyDebounce.debounce(
        'link-text-change-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(milliseconds: 500),    // <-- The debounce duration
            () async {                             // <-- The target method

          value["link"] = text;
          widget.onChange?.call(value);

        }
    );
  }


  @override
  void dispose() {
    super.dispose();
    linkTextEditingController.dispose();
    toolTipTextEditingController.dispose();
  }

}