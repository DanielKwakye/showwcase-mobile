import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/series/data/models/series_model.dart';
import 'package:showwcase_v3/features/shows/data/models/show_model.dart';
import 'package:showwcase_v3/features/threads/data/models/thread_model.dart';

part 'shared_link_preview_meta_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedLinkPreviewMetaModel extends Equatable {

  final String? title;
  final String? description;
  final String? url;
  final List<String?>? images;
  final String? favicon;
  final String? type;
  final ShowModel? project;
  final SeriesModel? series;
  final ThreadModel? thread;

  @JsonKey(name: 'community')
  final CommunityModel? communityModel;

  const SharedLinkPreviewMetaModel({
    this.title,
    this.description,
    this.url,
    this.images,
    this.favicon,
    this.type,
    this.project,
    this.thread,
    this.series,
    this.communityModel
  });

  factory SharedLinkPreviewMetaModel.fromJson(Map<String, dynamic> json) => _$SharedLinkPreviewMetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharedLinkPreviewMetaModelToJson(this);

  @override
  List<Object?> get props => [title, url, type,];

}

//class LinkPreviewMeta extends Equatable {
//   const LinkPreviewMeta({
//     this.title,
//     this.description,
//     this.url,
//     this.images,
//     this.favicon,
//     this.type,
//     this.project,
//     this.thread,
//     this.series,
//     this.communityModel
//   });
//
//   final String? title;
//   final String? description;
//   final String? url;
//   final List<String?>? images;
//   final String? favicon;
//   final String? type;
//   final ShowsResponse? project;
//   final SeriesResponse? series;
//   final ThreadsResponse? thread;
//   final CommunityModel? communityModel;
//
//   factory LinkPreviewMeta.fromJson(Map<String, dynamic> json) =>
//       LinkPreviewMeta(
//         title: json["title"],
//         description: json["description"],
//         url: json["url"],
//         images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x ?? '')),
//         favicon: json["favicon"],
//         type: json["type"],
//         project: json["project"] == null ? null : ShowsResponse.fromJson(
//             json["project"]),
//         series: json["series"] == null ? null : SeriesResponse.fromJson(
//             json["series"]),
//         thread: json["thread"] == null ? null : ThreadsResponse.fromJson(
//             json["thread"]),
//         communityModel: json["community"] == null ? null : CommunityModel.fromJson(json["community"]),
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         "title": title,
//         "description": description,
//         "url": url,
//         "images": images != null ? List<String>.from(images!.map((x) => x)) : null,
//         "favicon": favicon,
//         "type": type,
//         "project": project != null ? project!.toJson() : null,
//         "thread": thread != null ? thread!.toJson() : null,
//         "series": series != null ? series!.toJson() : null,
//         "community": communityModel == null ? null : communityModel!.toJson(),
//       };
//
//   @override
//   List<Object?> get props => [title, description, url];
// }