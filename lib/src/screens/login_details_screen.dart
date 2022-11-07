import 'package:example_app/src/screens/mobile_number_screen.dart';
import 'package:example_app/src/services/auth/auth.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:example_app/src/utils/button_widget.dart';
import 'package:example_app/src/utils/progress_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/user/user.dart';
import '../utils/circle_shaped_widget.dart';

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  late ThemeData themeData;
  bool isLoading = false;
  List<UserModel> list = [];
  List<UserModel> todayLoginList = [];
  List<UserModel> yesterdayLoggedList = [];
  List<UserModel> otherList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    list = await UserService.instance
        .getCurrentUserLoginDetails(AppConstants.userModel.mobileNumber);

    for (UserModel model in list) {
      num value = calculateDifferenceBtwDates(model.currentDate);

      if (value == 0) {
        todayLoginList.add(model);
      } else if (value == -1) {
        yesterdayLoggedList.add(model);
      } else {
        otherList.add(model);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: KeyboardDismissOnTap(
              child: ProgressWidget(
                  isShow: isLoading,
                  color: Colors.black,
                  opacity: 1,
                  child: loginDetailsScreenBodyUI()),
            ),
          )),
    );
  }

  Widget loginDetailsScreenBodyUI() {
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
            // left: 90,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: tabBarUI()),
        //  Positioned(top: 70, left: 60, child: welcomeText()),
        Positioned(
          top: MediaQuery.of(context).size.height / 12,
          right: MediaQuery.of(context).size.width / 3,
          // width: 100,
          //   height: MediaQuery.of(context).size.height / 15,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text(
              'Last Login',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget tabBarUI() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: themeData.textTheme.titleMedium,
                unselectedLabelStyle: themeData.textTheme.titleSmall!
                    .copyWith(color: Colors.grey),
                tabs: const [
                  Tab(
                    text: 'TODAY',
                  ),
                  Tab(
                    text: 'Yesterday',
                  ),
                  Tab(
                    text: 'Other',
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              children: <Widget>[
                tabUI(todayLoginList),
                tabUI(yesterdayLoggedList),
                tabUI(otherList),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tabUI(List<UserModel> list) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (UserModel user in list) loginScreenUI(user),
                ],
              ),
            ),
          ),

          // the save button can be implemented if required

          // list.isNotEmpty
          //     ? Container(
          //         padding: EdgeInsets.only(
          //             left: MediaQuery.of(context).size.width / 10,
          //             right: MediaQuery.of(context).size.width / 10),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: ButtonWidget(text: 'SAVE', onClicked: () {}),
          //         ))
          //     : const SizedBox()
        ],
      ),
    );
  }

  int calculateDifferenceBtwDates(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Widget loginScreenUI(UserModel user) {
    return Stack(
      children: [
        user.qrCodePath.isNotEmpty
            ? Positioned(right: 30, child: qrImageUI(user.generatedQRCode))
            : const SizedBox(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 25, bottom: 10, top: 10, right: 25),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(user.currentDate),
                          style: themeData.textTheme.subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          'IP:  ${user.ipAddress.toString()}',
                          style: themeData.textTheme.subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          user.location.toString().toUpperCase(),
                          style: themeData.textTheme.subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget qrImageUI(String qrCode) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 80,
        width: 80,
        child: QrImage(data: qrCode));
  }
}
