
class RoadmapsCareerModel {
  final String? label;
  final String? percentage;

 const RoadmapsCareerModel({
    this.label,
    this.percentage,
  });

  factory RoadmapsCareerModel.fromJson(Map<String, dynamic> json) => RoadmapsCareerModel(
    label: json["label"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "percentage": percentage,
  };
}