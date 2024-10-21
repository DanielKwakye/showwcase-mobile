
class RoadmapSalaryModel {
 final String? label;
 final String? range;

 const RoadmapSalaryModel({
    this.label,
    this.range,
  });

  factory RoadmapSalaryModel.fromJson(Map<String, dynamic> json) => RoadmapSalaryModel(
    label: json["label"],
    range: json["range"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "range": range,
  };
}