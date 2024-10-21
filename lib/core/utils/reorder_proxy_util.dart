import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReOrderProxyUtil extends StatefulWidget {
  final Widget child;
  const ReOrderProxyUtil({Key? key, required this.child}) : super(key: key);

  @override
  State<ReOrderProxyUtil> createState() => _ReOrderProxyUtilState();
}

class _ReOrderProxyUtilState extends State<ReOrderProxyUtil> {

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: widget.child,
    );
  }
}
