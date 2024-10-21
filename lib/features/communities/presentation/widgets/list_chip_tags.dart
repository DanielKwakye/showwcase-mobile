// ignore_for_file: implementation_imports

library flutter_chip_tags;

import 'package:flutter/material.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_enums.dart';


class ListChipTags extends StatefulWidget {
  const  ListChipTags({
    Key? key,
    this.iconColor,
    this.chipColor,
    this.textColor,
    this.decoration,
    this.keyboardType,
    this.separator,
    this.createTagOnSubmit = false,
    this.chipPosition = ChipPosition.below,
    required this.selectedTags,
    this.onChanged,
    required this.suggestedTags,required this.onChangedText,
  }) : super(key: key);

  ///sets the remove icon Color
  final Color? iconColor;

  ///sets the chip background color
  final Color? chipColor;

  ///sets the color of text inside chip
  final Color? textColor;

  ///container decoration
  final InputDecoration? decoration;

  ///set keyboradType
  final TextInputType? keyboardType;

  ///customer symbol to seprate tags by default
  ///it is " " space.
  final String? separator;

  /// list of String to display
  final List<String> selectedTags;

  /// list of String suggestions for users
  final List<String?> suggestedTags ;

  final ChipPosition chipPosition;

  /// Default `createTagOnSumit = false`
  /// Creates new tag if user submit.
  /// If true they separtor will be ignored.
  final bool createTagOnSubmit;

  /// Callback when a tag is added or removed.
  final ValueChanged<List<String>>? onChanged;

  /// Callback when a new text is typed is tags or removed.
  final ValueChanged<String>? onChangedText;

  @override
  State<ListChipTags> createState() => _ListChipTagsState();
}

class _ListChipTagsState extends State<ListChipTags>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  ///Form key for TextField
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
            visible: widget.chipPosition == ChipPosition.above,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _chipListPreview(),
                const SizedBox(height: 20,),
              ],
            )),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _inputController,
                decoration: widget.decoration ??
                    InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: widget.createTagOnSubmit
                          ? "Submit text to create Tags"
                          : "Separate Tags with '${widget.separator ?? 'space'}'",
                    ),
                keyboardType: widget.keyboardType ?? TextInputType.text,
                textInputAction: TextInputAction.done,
                focusNode: _focusNode,
                onSubmitted: widget.createTagOnSubmit
                    ? (value) {
                  widget.selectedTags.add(value);

                  ///setting the controller to empty
                  _inputController.clear();

                  ///resetting form
                  _formKey.currentState!.reset();

                  ///refersing the state to show new data
                  setState(() {});
                  _focusNode.requestFocus();
                }
                    : null,
                onChanged: widget.createTagOnSubmit
                    ? null
                    : (value) {
                  ///check if user has send separator so that it can break the line
                  ///and add that word to list
                  widget.onChangedText?.call(value ??'');

                  addTags(value);
                },
              ),
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(6),
                    color: theme.colorScheme.primary,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 15, spreadRadius: 1)
                    ]
                ),
                child: Column(
                  children: [
                    ...widget.suggestedTags.map((value) => ListTile(
                        onTap: () {
                          ///check if user has send separator so that it can break the line
                          ///and add that word to list
                          if (value != widget.separator && !widget.selectedTags.contains(value)) {
                            _inputController.clear();
                            widget.selectedTags.add(value ??'');
                            widget.onChanged?.call(widget.selectedTags);
                            widget.suggestedTags.clear();
                            setState(() {});
                          }
                          // Navigator.pop(context);
                        },
                        title: Text(value ??'', style: TextStyle(color: widget.textColor),)) )
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: widget.chipPosition == ChipPosition.below,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _chipListPreview(),
                const SizedBox(height: 20,),
              ],
            )),
      ],
    );
  }

  void addTags(String value) {
    print(value);
    ///check if user has send separator so that it can break the line
    ///and add that word to list
    if (value.endsWith(widget.separator ?? " ")) {
      ///check for ' ' and duplicate tags
      if (value != widget.separator && !widget.selectedTags.contains(value.trim())) {
        widget.selectedTags.add(value.replaceFirst(widget.separator ?? " ", '').trim());
        widget.onChanged?.call(widget.selectedTags);
      }

      ///setting the controller to empty
      _inputController.clear();

      ///resetting form
      _formKey.currentState!.reset();

      ///refersing the state to show new data
      setState(() {});
    }
  }

  Visibility _chipListPreview() {
    return Visibility(
      //if length is 0 it will not occupy any space
      visible: widget.selectedTags.isNotEmpty,
      child: Wrap(
        ///creating a list
        runSpacing: 10,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        ///creating a list
        children: widget.selectedTags.map((text) {
          return GestureDetector(
            onTap: () {
              widget.selectedTags.remove(text);
              setState(() {});
            },
            child: FittedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.chipColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.only(top:10),
                padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 7),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: widget.textColor ?? Colors.white),
                    ),
                    const SizedBox(width: 5,),
                    Icon(Icons.clear,
                        color: widget.iconColor ?? Colors.white, size: 15),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
