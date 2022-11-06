import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:example_app/src/utils/progress_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:example_app/src/screens/login_details_screen.dart';
import 'package:example_app/src/screens/mobile_number_screen.dart';
import 'package:example_app/src/services/auth/auth.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:example_app/src/utils/circular_progress_indicator_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/user/user.dart';
import '../utils/button_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Common Variables
  late ThemeData themeData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  bool isLoading = false;
  String? date;
  // final Key _renderObjectKey = Key();
  ByteData? data;
  late final File file;
  bool bCanAddMovie = true;
  Random random = Random();
  int randomNumber = 0;
  String location = '';
  String ipAddress = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    randomNumber = random.nextInt(90000) + 10000;
//DateFormat('hh:mm a').format(DateTime.now());

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
        color: Color(0xFF000000),
        emptyColor: Colors.white,
      ).toImage(300);
      data = await image.toByteData(format: ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } catch (e) {
      print('----$e');
    }
    return data!.buffer.asUint8List();
  }

  Future<String> getLocation() async {
    try {
      await http
          .get(Uri.parse(
        'http://ip-api.com/json',
      ))
          .then((value) async {
        city = json.decode(value.body)['city'].toString();
        // print(json.decode(value.body)['city'].toString());
        print('-----$city');
      });
    } catch (err) {
      //handleError

      print(err);
    }
    return city;
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
    ipAddress = await onSave();
    await getLocation();

    user.ipAddress = ipAddress;
    user.location = city;

    setLoadingState(false);
    setState(() {});
    await setData();
  }

  Future setData() async {
    print('--${user.ipAddress}----${user.location}-------');
    date = await UserService.instance.addUser(user);
    print('------------$date');
    setState(() {});
  }

  Future<String> onSave() async {
    String ipv4 = await Ipify.ipv4();
    // print(ipv4); // 98.207.254.136

    final ipv6 = await Ipify.ipv64();
    // print(ipv6); // 98.207.254.136 or 2a00:1450:400f:80d::200e

    final ipv4json = await Ipify.ipv64(format: Format.JSON);
    //{"ip":"98.207.254.136"} or {"ip":"2a00:1450:400f:80d::200e"}

    // The response type can be text, json or jsonp
    return ipv4;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   titleSpacing: 5,
        //   backgroundColor: Colors.black,
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.menu,
        //   //       size: SizeUtils.get(SizeUtils.screenWidth < 800
        //   //           ? 7
        //   //           : 4)), // change this size and style
        //   //   onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        //   // ),
        //   // title: Align(
        //   //   alignment: Alignment.centerLeft,
        //   //   child: Image.asset(IconConstants.icFirstposterNameLogo,
        //   //       width: SizeUtils.get(30)),
        //   // ),
        //   actions: [
        //     ButtonWidget(
        //         text: 'LOGOUT',
        //         onClicked: () {
        //           AuthService.logout();
        //           Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) =>
        //                       const MobileNumberScreen()));
        //         })
        //   ],
        // ),

        body: SafeArea(
          child: KeyboardDismissOnTap(
            child: ProgressWidget(
                isShow: isLoading,
                color: Colors.black,
                opacity: 1,
                child: body()),
          ),
        ));
  }

  Widget body() {
    return Container(
      // padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            right: 15,
            child: InkWell(
                child: Text(
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
              // left: 90,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: homeScreenBody()),
          //  Positioned(top: 70, left: 60, child: welcomeText()),
          Positioned(
            top: MediaQuery.of(context).size.height / 12,
            left: MediaQuery.of(context).size.width / 2.7,
            // width: 100,
            //   height: MediaQuery.of(context).size.height / 15,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
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
      ),
    );
  }

  Widget generatedNum() {
    return Column(
      children: [
        Text(
          'Generated Number',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          randomNumber.toString(),
          style: TextStyle(color: Colors.white, fontSize: 25),
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
          //

          // Column(
          //   children: [qrImageUI()],
          // ),
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
                        print('---qrImg----$qrImg');

                        await uploadTask.then((res) async {
                          String imageURL = await res.ref.getDownloadURL();
                          print('-------imageURL---${imageURL}');

                          await UserService.instance.updateUser(
                            AppConstants.userModel.uuid,
                            AppConstants.userModel.mobileNumber,
                            imageURL,
                            randomNumber,
                            date!,
                          );
                          //setLoadingState(false);
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

  // Future<String> storeImage() async {
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("/ExampleApp/image_" + DateTime.now().toString() + ".jpg");
  //   UploadTask uploadTask = ref.putFile(imageFile);

  // //  String imageURL = StringConstants.defaultPostarUrl;
  //   await uploadTask.then((res) async {
  //     imageURL = await res.ref.getDownloadURL();

  //     setLoadingState(false);
  //   });

  //   return imageURL;
  // }
  Widget qrImageUI() {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height / 3.6,
        width: MediaQuery.of(context).size.width / 2.2,
        child: QrImage(data: randomNumber.toString()));
  }

  Widget stackContainer() {
    return Stack(children: [
      Container(
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
    print(DateFormat('hh:mm a').format(DateTime.now()));
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginDetails()),
    );
  }
}

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, 10);
    path.lineTo(290, 150);
    path.lineTo(0, 150);

    path.close();
    canvas.drawPath(path, Paint()..color = Color.fromARGB(220, 0, 0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
