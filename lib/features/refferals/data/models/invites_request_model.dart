class InviteRequest {
  InviteRequest({
    this.emails,
  });

  List<String?>? emails;

  factory InviteRequest.fromJson(Map<String, dynamic> json) => InviteRequest(
    emails: json["emails"] == null ? [] : List<String?>.from(json["emails"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "emails": emails == null ? [] : List<dynamic>.from(emails!.map((x) => x)),
  };
}
