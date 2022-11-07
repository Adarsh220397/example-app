import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

class LocationService {
  LocationService._internal();
  static LocationService instance = LocationService._internal();

  Future<String> getLocation() async {
    String city = '';
    try {
      await http
          .get(Uri.parse(
        'http://ip-api.com/json',
      ))
          .then((value) async {
        city = json.decode(value.body)['city'].toString();
      });
    } catch (err) {
      print(err);
    }
    return city;
  }

  Future<String> getIpAddress() async {
    String ipv4 = await Ipify.ipv4();

    return ipv4;
  }
}
