import 'package:flutter/material.dart';

const _chooseOne = "Select ";

class CustomDropdownWidget extends StatelessWidget {
  final List<String> items ;
  final String hintText ;
  final String? label;
  final ValueChanged<String?> onChanged ;
  final String value ;
  final bool showChooseOneOption;
  const CustomDropdownWidget({
    Key? key, required this.items,
    required this.hintText,
    this.label,
    this.showChooseOneOption = true,
    required this.onChanged, required this.value}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modifiedItems = [...items];
    if(showChooseOneOption){
      modifiedItems.insert(0, _chooseOne); // Let the first item in the list be empty...
      // so that if the user doesn't select anything, the dropdown can have a value of empty
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if(label != null && label != '') ...{
          Text(
            label ?? '',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10,),
        },
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: theme.colorScheme.outline, width: 1),
            color: theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
          ),
          child: DropdownButton(
            value: value ,
            padding: const EdgeInsets.symmetric(vertical: 10),
            isExpanded: true,
            elevation: 0,
            isDense: true,
            items: modifiedItems.map((value) =>
                DropdownMenuItem(
                  value: value ==  _chooseOne ? '' : value,
                  child: Text(value,),
                )).toList(),
            onChanged: onChanged,
            underline: const SizedBox.shrink(),
            icon:  Icon(Icons.keyboard_arrow_down_outlined,color: theme.colorScheme.onBackground.withOpacity(0.5), ),
            hint:  Text(hintText,
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
          ),
        ),
      ],
    );
  }
}
