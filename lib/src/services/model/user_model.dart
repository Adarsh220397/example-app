import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uuid;
  String generatedQRCode;
  String qrCodePath;
  String dialCode;
  String mobileNumber;
  String ipAddress;
  String location;
  DateTime currentDate;

  UserModel({
    required this.uuid,
    required this.generatedQRCode,
    required this.qrCodePath,
    required this.dialCode,
    required this.mobileNumber,
    required this.ipAddress,
    required this.location,
    required this.currentDate,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      uuid: json['userId'] == null ? '' : json['userId'] as String,
      location: json['location'] == null ? '' : json['location'] as String,
      ipAddress: json['ipAddress'] == null ? '' : json['ipAddress'] as String,
      generatedQRCode: json['generatedQRCode'] == null
          ? ''
          : json['generatedQRCode'] as String,
      qrCodePath:
          json['qrCodePath'] == null ? '' : json['qrCodePath'] as String,
      dialCode: json['dialCode'] as String,
      mobileNumber:
          json['mobileNumber'] == null ? '' : json['mobileNumber'] as String,
      currentDate: (json['currentDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['location'] = location;
    data['ipAddress'] = ipAddress;
    data['generatedQRCode'] = generatedQRCode;
    data['qrCodePath'] = qrCodePath;
    // data['countryCode'] = countryCode;
    data['currentDate'] = currentDate;
    data['dialCode'] = dialCode;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
