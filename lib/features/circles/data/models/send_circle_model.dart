class SendCircleModel {
  const SendCircleModel({this.userId, this.reason, this.note, this.action});

  final int? userId;
  final String? reason;
  final String? note;
  final String? action;

  factory SendCircleModel.fromJson(Map<String, dynamic> json) =>
      SendCircleModel(
        userId: json["userId"],
        reason: json["reason"],
        note: json["note"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        if (reason != null) "reason": reason,
        if (note != null) "note": note,
        if (action != null) "action": action,
      };
}
