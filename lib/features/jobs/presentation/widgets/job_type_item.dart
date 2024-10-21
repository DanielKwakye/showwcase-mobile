import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class JopTypeItem extends StatefulWidget {
  final UserModel user ;
  final String displayText ;
  final  String value ;
  final VoidCallback? onTap;
  const JopTypeItem({super.key, required this.user, required this.displayText, required this.value, this.onTap});

  @override
  State<JopTypeItem> createState() => _JopTypeItemState();
}

class _JopTypeItemState extends State<JopTypeItem> {
  late ValueNotifier<String> _checkBoxValue ;
  @override
  void initState() {
    _checkBoxValue  = ValueNotifier<String>(widget.value);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: (){
        widget.onTap?.call();
        // _checkBoxValue.notifyListeners();
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border:  Border.all(color: theme.colorScheme.outline)
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              ValueListenableBuilder(
                valueListenable: _checkBoxValue,
                builder: (BuildContext context, String value, Widget? child) {
                 return Container(
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(100.0), // Adjust the value to control the corner radius
                       color: (widget.user.settings?.jobPreferences?.types?.contains(value) ?? false) ? kAppBlue : Colors.transparent,
                       border:  (widget.user.settings?.jobPreferences?.types?.contains(value) ?? false) ? null
                           : Border.all(color: theme.colorScheme.onBackground)
                   ),
                   width: 25,
                   height: 25,
                   child: Checkbox(
                     key: UniqueKey(),
                     value: widget.user.settings?.jobPreferences?.types?.contains(value) ?? false,
                     onChanged: (v) => widget.onTap!(),
                     fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
                     side: MaterialStateBorderSide.resolveWith(
                           (states) => const BorderSide(width: 1.0, color: Colors.transparent),
                     ),
                     checkColor: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(4.0), // Adjust the value to match the parent container's corner radius
                     ),
                   ),
                 );
                },
              ),
              const SizedBox(width: 20,),
              Expanded(child: Text(widget.displayText, style: theme.textTheme.bodyMedium,))
            ],
          )

      ),
    );
  }
}
