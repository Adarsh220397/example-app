import 'dart:async';

import 'package:example_app/src/screens/home_screen.dart';
import 'package:example_app/src/services/auth/firebase_phone_auth.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:example_app/src/utils/button_widget.dart';
import 'package:example_app/src/utils/circle_shaped_widget.dart';
import 'package:example_app/src/utils/common_utils.dart';
import 'package:example_app/src/utils/progress_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../services/model/phone_auth_listener.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen>
    implements PhoneAuthListener {
  //Common Variables
  late ThemeData themeData;

  // Controllers
  final TextEditingController _mobileNumberCodeController =
      TextEditingController();

  final TextEditingController _otpCodeController = TextEditingController();

  String verificationId = '';
  num? resendToken = 0;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool requestInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: KeyboardDismissOnTap(
          child: ProgressWidget(
              isShow: isShowLoading,
              color: Colors.black,
              opacity: 1,
              child: loginScreenBodyUI()),
        ),
      ),
    );
  }

  Widget loginScreenBodyUI() {
    return Stack(
      children: <Widget>[
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
            child: formUI()),
        Positioned(
          top: MediaQuery.of(context).size.height / 12,
          left: MediaQuery.of(context).size.width / 2.5,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text(
              'LOGIN',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget formUI() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Container(
        //   height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              textUI('Phone number'),
              const SizedBox(height: 5),
              mobileNumberInput(),
              const SizedBox(height: 30),
              textUI('OTP'),
              const SizedBox(height: 5),
              otp(),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonWidget(
                  text: 'LOGIN',
                  onClicked: _validateOtpInputs,
                  bFullContainerButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget manageText() {
    return Text(
      "Manage your movie releases with us.",
      style: themeData.textTheme.subtitle1!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Widget textUI(String text) {
    return Text(
      text,
      style: themeData.textTheme.titleMedium!.copyWith(color: Colors.white),
      textAlign: TextAlign.left,
    );
  }

  Widget mobileNumberInput() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 15,
              alignment: Alignment.center,
              child: TextFormField(
                controller: _mobileNumberCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.send,
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (value) {
                  _mobileNumberCodeController.text = value;
                  _validateMobileInputs();
                },
                onSaved: (value) {
                  _mobileNumberCodeController.text = value!;
                },
              ),
            ),
          ),
        ]);
  }

  Widget otp() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _otpCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (value) {
                  _otpCodeController.text = value;
                },
                onSaved: (value) {
                  _otpCodeController.text = value!;
                },
              ),
            ),
          ),
        ]);
  }

  void setLoadingState(bool status) {
    if (mounted) {
      setState(() {
        isShowLoading = status;
      });
    }
  }

  void _validateMobileInputs() async {
    requestInProgress = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setLoadingState(true);
      FirebasePhoneAuth(context, this)
          .startPhoneAuth("+" + '91' + _mobileNumberCodeController.text, null);
    }
  }

  @override
  void onAuthenticationFail(FirebaseAuthException error) {
    setLoadingState(false);
    print("Mobile Number Page : onAuthenticationFail");
  }

  @override
  void onCodeAutoRetrievalTimeout(String veriId) {
    setLoadingState(false);
    verificationId = veriId;

    print("Mobile Number Page : onCodeAutoRetrievalTimeout");
  }

  @override
  void onCodeSent(String verificationKey, int? resendTokenKey) {
    setLoadingState(false);
    verificationId = verificationKey;
    resendToken = resendTokenKey;

    CommonUtils.instance.showSnackBar(context, "OTP sent successfully", "P");
    print("OTP Page : onCodeSent");
  }

  @override
  void onVerificationCompleted(String? otp) {
    setLoadingState(false);
    print("OTP Page : onVerificationCompleted");
  }

  @override
  void onVerificationFailed(FirebaseAuthException error) {
    setLoadingState(false);
    print("OTP Page : onVerificationFailed");
  }

  @override
  Future<void> onAuthenticationSuccess(User? firebaseUser) async {
    setLoadingState(false);
    print('auth success');
    await checkForUserRegistration(firebaseUser);
  }

  Future<void> checkForUserRegistration(User? firebaseUser) async {
    // await PreferenceManager.instance.setUserId(firebaseUser!.uid);
    AppConstants.userModel.uuid = firebaseUser!.uid;
    AppConstants.userModel.mobileNumber = _mobileNumberCodeController.text;
    print(AppConstants.userModel.uuid);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }

  void _validateOtpInputs() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_otpCodeController.text.isNotEmpty &&
        _otpCodeController.text.length == 6) {
      _formKey.currentState!.save();

      setLoadingState(true);

      UserModel user = UserModel(
          uuid: AppConstants.userModel.uuid,
          ipAddress: '',
          location: '',
          currentDate: DateTime.now(),
          generatedQRCode: '',
          qrCodePath: '',
          dialCode: '+91',
          mobileNumber: _mobileNumberCodeController.text);

      FirebasePhoneAuth(context, this)
          .signInWithPhoneNumber(_otpCodeController.text, verificationId, user);
    } else {
      CommonUtils.instance.showSnackBar(context, "Please enter OTP");
    }
  }
}
