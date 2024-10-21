import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/users/data/models/user_tag_model.dart';

class ProfileTagWidget extends StatefulWidget {
  final UserTagModel tag;
  final Function(bool)? onSelect;
  final bool selectable;
  final bool selected;
  const ProfileTagWidget({
    required this.tag,
    this.onSelect,
    this.selectable = true,
    this.selected = false,
    Key? key}) : super(key: key);

  @override
  State<ProfileTagWidget> createState() => _ProfileTagWidgetState();
}

class _ProfileTagWidgetState extends State<ProfileTagWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selected = widget.selected;
    debugPrint("customLog: selected -> $selected");

    Widget icon = const SizedBox.shrink();
    Widget space =  const SizedBox.shrink();
    Color color = theme.colorScheme.onBackground;

      var itemIndex = profileTagIcons.indexWhere((element) => (element['name'] as String).toLowerCase().contains(widget.tag.icon!.toLowerCase()));
      if(itemIndex < 0){
        itemIndex = 0;
      }
      // the color is  of the format  #XXXYYY
      // so we take off the #
      if(widget.tag.color != null){
        final hasRemovedFromColor = widget.tag.color!.replaceAll('#', "");
        try{
          color = Color(int.parse("0xff$hasRemovedFromColor"));
        }catch(e){
          debugPrint(e.toString());
          color = kAppBlue;
        }
      }
      icon = SvgPicture.asset((profileTagIcons[itemIndex]['icon'] as String) ,
        colorFilter: ColorFilter.mode(widget.selected ? kAppWhite : color, BlendMode.srcIn),
        placeholderBuilder: (ctx) {
          return SvgPicture.asset((profileTagIcons[0]['icon'] as String),
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          );
        },
      );
      space = const SizedBox(width: 10,);

    return GestureDetector(
      onTap: widget.selectable ? (){
        widget.onSelect?.call(!widget.selected);
      } : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          //color: backgroundColor,
            color: widget.selected ? kAppBlue : null,
          border: widget.selected ? null : Border.all(color: theme.colorScheme.outline)
        ),
        padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.verified, color: kAppBlue,),
            icon,
            space,
            Text(widget.tag.name!, style: TextStyle(
                color: widget.selected ? kAppWhite : theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: (defaultFontSize - 2)),)
          ],
        ),
      ),
    );
  }
}
