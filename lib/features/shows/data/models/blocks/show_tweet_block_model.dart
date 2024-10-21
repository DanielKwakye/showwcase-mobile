
import 'package:json_annotation/json_annotation.dart';

part 'show_tweet_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowTweetBlockModel {
  const ShowTweetBlockModel({
    this.url,
  });

  final String? url;

  factory ShowTweetBlockModel.fromJson(Map<String, dynamic> json) => _$ShowTweetBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowTweetBlockModelToJson(this);

}