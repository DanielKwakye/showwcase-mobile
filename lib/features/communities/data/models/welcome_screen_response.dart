import 'dart:convert';


List<WelcomeScreenResponse> welcomeScreenResponseFromJson(String str) => List<WelcomeScreenResponse>.from(json.decode(str).map((x) => WelcomeScreenResponse.fromJson(x)));

String welcomeScreenResponseToJson(List<WelcomeScreenResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WelcomeScreenResponse {
  SectionName? sectionName;
  String? description;
  String? id;

  WelcomeScreenResponse({
    this.sectionName,
    this.description,
    this.id,
  });

  factory WelcomeScreenResponse.fromJson(Map<String, dynamic> json) => WelcomeScreenResponse(
    sectionName: json["sectionName"] == null ? null : SectionName.fromJson(json["sectionName"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "sectionName": sectionName?.toJson(),
    "description": description,
  };
}

class SectionName {
  String? emoji;
  String? title;

  SectionName({
    this.emoji,
    this.title,
  });

  factory SectionName.fromJson(Map<String, dynamic> json) => SectionName(
    emoji: json["emoji"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "emoji": emoji,
    "title": title,
  };
}
