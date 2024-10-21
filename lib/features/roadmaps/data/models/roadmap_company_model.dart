
class RoadmapCompanyModel {
 final String? label;
 final String? total;

 const RoadmapCompanyModel({
    this.label,
    this.total,
  });

  factory RoadmapCompanyModel.fromJson(Map<String, dynamic> json) => RoadmapCompanyModel(
    label: json["label"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "total": total,
  };
}