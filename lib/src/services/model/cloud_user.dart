class CloudUser {
  String uuid;
  String firstName;
  String lastName;
  String countryCode;
  String countryName;
  String dialCode;
  String mobileNumber;

  CloudUser(
      {required this.uuid,
      required this.firstName,
      required this.lastName,
      required this.countryCode,
      required this.countryName,
      required this.dialCode,
      required this.mobileNumber});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['countryCode'] = countryCode;
    data['countryName'] = countryName;
    data['dialCode'] = dialCode;
    data['mobileNumber'] = mobileNumber;

    return data;
  }

  factory CloudUser.fromJson(dynamic json) {
    return CloudUser(
      uuid: json['uuid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
      dialCode: json['dialCode'] as String,
      mobileNumber: json['mobileNumber'] as String,
    );
  }
}
