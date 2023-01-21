class AppUser {
  String? id;
  String name;
  String email;
  bool isTailor;

  AppUser(
      {this.id,
      required this.name,
      required this.email,
      required this.isTailor});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'is_tailor': isTailor,
      };
}
