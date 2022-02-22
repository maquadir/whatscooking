class Profile {
  String userName;
  String suburb;
  String poCode;
  String country;

  Profile({
    required this.userName,
    required this.suburb,
    required this.poCode,
    required this.country,
  });

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        userName: json['user_name'],
        suburb: json['suburb'],
        poCode: json['po_code'],
        country: json['country'],
      );

  static Profile empty() =>
      Profile(userName: "", suburb: "", poCode: "", country: "");

  static bool isValid(Profile profile) =>
      profile.userName.isNotEmpty &&
          profile.suburb.isNotEmpty &&
          profile.poCode.isNotEmpty &&
          profile.country.isNotEmpty;

  static bool isValidLocation(Profile profile) =>
          profile.suburb.isNotEmpty &&
          profile.poCode.isNotEmpty &&
          profile.country.isNotEmpty;
}
