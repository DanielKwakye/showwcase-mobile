import 'package:flutter/material.dart';
import 'package:showwcase_v3/features/shows/data/models/show_block_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';


class ShowStatisticsBlockWidget extends StatelessWidget {

  final ShowBlockModel block;
  final ShowModel show;
  const ShowStatisticsBlockWidget({
    required this.block,
    required this.show,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    if(block.statisticsBlock?.data?.indicators == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[

        ...block.statisticsBlock!.data!.indicators!.map((indicator) {
          return ListTile(
            // dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title:  Text(indicator.label ?? ""),
            trailing: Text("${indicator.value}"),
          );
        })

      ],
    );
  }
}
