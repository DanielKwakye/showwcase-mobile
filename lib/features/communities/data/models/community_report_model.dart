
class CommunityReportModel {
  CommunityReportModel({
    required this.message,
    required this.communityId,
  });

  String message;
  int communityId;

  factory CommunityReportModel.fromJson(Map<String, dynamic> json) => CommunityReportModel(
    message: json["message"],
    communityId: json["communityId"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "communityId": communityId,
  };
}