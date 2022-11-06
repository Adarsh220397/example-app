import 'package:example_app/src/services/model/user_model.dart';

abstract class AppConstants {
  static const String appName = "FirstPoster";
  static const String deviceTypeAndroid = "android";
  static const String deviceTypeIOS = "ios";
  static const String deviceTypeWeb = "web";

  static UserModel userModel = UserModel(
    uuid: "",
    // firstName: "",
    // lastName: "",
    // countryCode: "",
    // countryName: "",
    generatedQRCode: '',
    qrCodePath: '',
    ipAddress: '',
    location: '',
    dialCode: "",
    mobileNumber: "", currentDate: DateTime.now(),
  );
}
