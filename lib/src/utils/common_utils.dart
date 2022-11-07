import 'dart:io';
import 'package:connectivity/connectivity.dart';
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
}
