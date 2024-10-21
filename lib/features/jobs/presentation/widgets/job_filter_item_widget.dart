import 'package:flutter/material.dart';
import 'package:showwcase_v3/core/utils/theme.dart';

class JobFilterItemWidget extends StatelessWidget {

  final String filterName;
  const JobFilterItemWidget({Key? key, required this.filterName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5),
      margin: const EdgeInsets.only(
          right: 5),
      decoration: BoxDecoration(
          color:
          kAppBlue.withOpacity(0.3),
          borderRadius:
          BorderRadius.circular(4)),
      child: Row(
        children: [
          Text(
            filterName,
            style: const TextStyle(
                color: kAppBlue),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.close,
            size: 12,
            color: kAppBlue,
          )
        ],
      ),
    );
  }
}
