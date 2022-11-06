import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  /// Singleton instance
  CommonUtils._internal();

  static CommonUtils instance = CommonUtils._internal();

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  String getDeviceType() {
    if (Platform.isAndroid) {
      return AppConstants.deviceTypeAndroid;
    } else if (Platform.isIOS) {
      return AppConstants.deviceTypeIOS;
    } else {
      return "";
    }
  }

  // Future<String> getDeviceID() async {
  //   String deviceId = "";
  //   try {
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       deviceId = androidInfo.androidId!;
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       deviceId = iosInfo.identifierForVendor!;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   print("DEVICE ID : " + deviceId);
  //   return deviceId;
  // }

  void showSnackBar(BuildContext context, String message, [String type = "N"]) {
    final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        content: Wrap(
          children: [
            Center(
              child:
                  Text(message, style: Theme.of(context).textTheme.subtitle1),
            ),
          ],
        ),
        backgroundColor: type == "P" ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  bool isSameDate(DateTime? other) {
    return DateTime.now().year == other?.year &&
        DateTime.now().month == other?.month &&
        DateTime.now().day == other?.day;
  }
}
