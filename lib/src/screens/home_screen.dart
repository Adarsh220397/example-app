// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:example_app/src/services/location/location.dart';
import 'package:example_app/src/utils/progress_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:example_app/src/screens/login_details_screen.dart';
import 'package:example_app/src/screens/mobile_number_screen.dart';
import 'package:example_app/src/services/auth/auth.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/user/user.dart';
import '../utils/button_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

import '../utils/circle_shaped_widget.dart';
import '../utils/triangle_shaped_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Common Variables
  late ThemeData themeData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  String? date;

  ByteData? data;

  Random random = Random();
  int randomNumber = 0;
  String location = '';
  String ipAddress = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    randomNumber = random.nextInt(90000) + 10000;

    _fetchData();
  }

  void setLoadingState(bool status) {
    if (mounted) {
      setState(() {
        isLoading = status;
      });
    }
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: const Color(0xFF000000),
        emptyColor: Colors.white,
      ).toImage(300);
      data = await image.toByteData(format: ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } catch (e) {
      print('----$e');
    }
    return data!.buffer.asUint8List();
  }

  UserModel user = UserModel(
      uuid: AppConstants.userModel.uuid,
      ipAddress: '',
      location: '',
      currentDate: DateTime.now(),
      dialCode: '+91',
      generatedQRCode: '',
      qrCodePath: '',
      mobileNumber: AppConstants.userModel.mobileNumber);

  Future<void> _fetchData() async {
    setLoadingState(true);
    ipAddress = await LocationService.instance.getIpAddress();
    city = await LocationService.instance.getLocation();

    user.ipAddress = ipAddress;
    user.location = city;

    setLoadingState(false);
    setState(() {});
    await setData();
  }

  Future setData() async {
    date = await UserService.instance.addUserInformation(user);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: SafeArea(
          child: KeyboardDismissOnTap(
            child: ProgressWidget(
                isShow: isLoading,
                color: Colors.black,
                opacity: 1,
                child: homeScreenBodyUI()),
          ),
        ));
  }

  Widget homeScreenBodyUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          right: 15,
          child: InkWell(
              child: const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              onTap: () {
                AuthService.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MobileNumberScreen()));
              }),
        ),
        Positioned(
          top: 0,
          right: 50,
          child: CustomPaint(
            painter: OpenPainter(),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: homeScreenBody()),
        Positioned(
          top: MediaQuery.of(context).size.height / 12,
          left: MediaQuery.of(context).size.width / 2.7,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text(
              'PLUGIN',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height / 2.5,
            left: MediaQuery.of(context).size.width / 8,
            child: stackContainer()),
        Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: MediaQuery.of(context).size.width / 3.7,
            child: qrImageUI()),
        Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 3.5,
            child: generatedNum())
      ],
    );
  }

  Widget generatedNum() {
    return Column(
      children: [
        const Text(
          'Generated Number',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          randomNumber.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ],
    );
  }

  Widget homeScreenBody() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
          ),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                    text:
                        'Last login at Today, ${DateFormat('hh:mm a').format(DateTime.now())}',
                    onClicked: navigateToLoginDetails,
                    isSecondary: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                      text: 'SAVE',
                      onClicked: () async {
                        Uint8List qrImg =
                            await toQrImageData(randomNumber.toString());
                        final tempDir =
                            await getApplicationDocumentsDirectory();
                        File file =
                            await File('${tempDir.path}/image.png').create();
                        file.writeAsBytesSync(qrImg, flush: true);

                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child("/ExampleApp/image_${DateTime.now()}.jpg");

                        UploadTask uploadTask = ref.putFile(file);

                        await uploadTask.then((res) async {
                          String imageURL = await res.ref.getDownloadURL();

                          await UserService.instance.updateUserInformation(
                            AppConstants.userModel.uuid,
                            AppConstants.userModel.mobileNumber,
                            imageURL,
                            randomNumber,
                            date!,
                          );
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget qrImageUI() {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height / 3.6,
        width: MediaQuery.of(context).size.width / 2.2,
        child: QrImage(data: randomNumber.toString()));
  }

  Widget stackContainer() {
    return Stack(children: [
      SizedBox(
        height: 150,
        width: 310,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 1, 16, 39),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      CustomPaint(painter: DrawTriangle()),
    ]);
  }

  navigateToLoginDetails() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginDetails()),
    );
  }
}
