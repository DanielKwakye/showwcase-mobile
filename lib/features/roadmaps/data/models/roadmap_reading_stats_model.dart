
class RoadMapReadingStatsModel {
 final int? time;
 final String? text;

 const RoadMapReadingStatsModel({
    this.time,
    this.text,
  });

  factory RoadMapReadingStatsModel.fromJson(Map<String, dynamic> json) => RoadMapReadingStatsModel(
    time: json["time"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "text": text,
  };
}