class InviteResponse {
  InviteResponse({
    this.invited,
    this.failed,
  });

  List<Invited?>? invited;
  Map<String, dynamic>? failed;

  factory InviteResponse.fromJson(Map<String, dynamic> json) => InviteResponse(
    invited: json["invited"] == null ? [] : List<Invited?>.from(json["invited"]!.map((x) => Invited.fromJson(x))),
    failed: json["failed"],
  );

  Map<String, dynamic> toJson() => {
    "invited": invited == null ? [] : List<dynamic>.from(invited!.map((x) => x!.toJson())),
    "failed": failed,
  };
}



class Invited {
  Invited({
    this.id,
    this.userId,
    this.email,
    this.updatedAt,
    this.createdAt,
  });

  int? id;
  int? userId;
  String? email;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Invited.fromJson(Map<String, dynamic> json) => Invited(
    id: json["id"],
    userId: json["userId"],
    email: json["email"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "email": email,
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };
}
