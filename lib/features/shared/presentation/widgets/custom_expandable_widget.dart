///
/// expandable_group_widget.dart
/// Purpose: Supply boilerplate for expandable list
/// Description:
/// Created: Aug 11th 2020
/// Copyright (C) 2020 Liem Vo.
///
import 'package:flutter/material.dart';

class CustomExpandableWidget extends StatefulWidget {
  /// optional property control the expanded or collapsed list
  ///
  /// Default value is false
  final bool isExpanded;

  /// required widget and display the header of each group
  ///
  ///
  final Widget header;

  /// required list `ListTile` widget for group items
  ///
  ///
  final Widget content;

  /// optional widget for expanded Icon.
  ///
  /// Default value is `Icon(Icons.keyboard_arrow_down)`
  final Widget? expandedIcon;

  /// optional widget for collapse Icon.
  ///
  /// Default value is `Icon(Icons.keyboard_arrow_right)`
  final Widget? collapsedIcon;

  /// option value for header EdgeInsets
  ///
  /// Default value will `EdgeInsets.only(left: 0.0, right: 16.0)`
  final EdgeInsets? headerEdgeInsets;

  /// background color of header
  ///
  /// Default value `Theme.of(context).appBarTheme.color`
  final Color? headerBackgroundColor;

  final Function(String)? onExpand;

  final String index;

  const CustomExpandableWidget({
    Key? key,
    this.isExpanded = false,
    required this.header,
    required this.content,
    required this.index,
    this.expandedIcon,
    this.collapsedIcon,
    this.headerEdgeInsets,
    this.onExpand,
    this.headerBackgroundColor})
      : super(key: key);

  @override
  State<CustomExpandableWidget> createState() => _CustomExpandableWidgetState();
}

class _CustomExpandableWidgetState extends State<CustomExpandableWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _updateExpandState(widget.isExpanded);
  }

  void _updateExpandState(bool isExpanded){
    setState(() {
      _isExpanded = isExpanded;
      if(_isExpanded && widget.onExpand != null){
        widget.onExpand!(widget.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isExpanded ? _buildListItems(context) : _wrapHeader(context);
  }

  Widget _wrapHeader(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> children = [];
    if (!widget.isExpanded) {
      children.add(const Divider());
    }

    children.add(
        Container (
            width: double.infinity,
            decoration: BoxDecoration (
                color: _isExpanded ? theme.colorScheme.outline : Colors.transparent
            ),
//            contentPadding: widget.headerEdgeInsets != null
//                  ? widget.headerEdgeInsets
//                  : EdgeInsets.only(left: 0.0, right: 16.0)
            child: ListTile(
              title: widget.header,
              trailing: _isExpanded
                  ? widget.expandedIcon ?? const Icon(Icons.keyboard_arrow_down)
                  : widget.collapsedIcon ?? const Icon(Icons.keyboard_arrow_right),
              onTap: () => _updateExpandState(!_isExpanded),
            )
        )
    );
    return Ink(
      color: widget.headerBackgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItems(BuildContext context) {
    return Column(
      children: [
        _wrapHeader(context),
        const Divider(),
        Container(
          margin: widget.headerEdgeInsets,
          child: widget.content,
        )
      ],
    );
  }
}
