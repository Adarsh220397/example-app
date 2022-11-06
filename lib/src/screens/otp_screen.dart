import 'dart:async';
import 'package:example_app/src/screens/home_screen.dart';
import 'package:example_app/src/services/auth/firebase_phone_auth.dart';
import 'package:example_app/src/services/model/phone_auth_listener.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:example_app/src/utils/app_constants.dart';
import 'package:example_app/src/utils/button_widget.dart';
import 'package:example_app/src/utils/common_utils.dart';
import 'package:example_app/src/utils/progress_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class OtpScreen extends StatefulWidget {
  //Data variables
  String verificationId;
  int? resendToken;

  OtpScreen({
    Key? key,
    required this.verificationId,
    required this.resendToken,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> implements PhoneAuthListener {
  //Common Variables
  late ThemeData themeData;
  String otpCode = "";
  String resendMessage = "Didn't get the OTP? Resend OTP in 60s";
  bool enableResend = false;
  late Timer _timer;
  int _start = 60;
  bool isShowLoading = false;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    enableResend = false;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
              enableResend = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              enableResend = false;
              _start--;
              resendMessage = "Didn't get the OTP? Resend OTP in $_start" "s";
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back))),
            Expanded(child: otpVerificationBody()),
          ],
        ),
      ),
    )));
  }

  Widget otpVerificationBody() {
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        // peopleGraphics(),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //  firstPosterLogo(),
                  SizedBox(height: 17),
                  otpVerificationText(),
                  SizedBox(height: 30),
                  enterOtpUI(), //enterNumberTitle(),
                  enterOtpTextUI(),
                  SizedBox(height: 7),
                  //   otpInput(),
                  SizedBox(height: 10),

                  ButtonWidget(
                    text: 'Verify',
                    onClicked: _validateOtpInputs,
                    bFullContainerButton: true,
                  ),
                  SizedBox(height: 10),
                  resendOtp(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget otpVerificationText() {
    return Text(
      "OTP Verification",
      style: themeData.textTheme.headline4!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Widget enterOtpUI() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        //  text: "Please enter the OTP sent to " + '\n',
        style: themeData.textTheme.subtitle2,
        children: <TextSpan>[
          TextSpan(
            text: '+91' + " " + AppConstants.userModel.mobileNumber,
            style: themeData.textTheme.subtitle1!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget enterOtpTextUI() {
    return Text(
      "Enter the OTP sent on above mobile number ",
      style: themeData.textTheme.subtitle2,
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: Colors.amber), color: Colors.grey);
  }

  InputDecoration get inputDecoration {
    return const InputDecoration(
        filled: false,
        labelStyle: TextStyle(color: Colors.transparent),
        hintStyle: TextStyle(color: Colors.transparent),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.transparent)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.transparent)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.transparent)));
  }

  // Widget otpInput() {
  //   return PinPut(
  //     eachFieldWidth: 15,
  //     eachFieldHeight: 15,
  //     inputDecoration: inputDecoration,
  //     fieldsCount: 6,
  //     autovalidateMode: AutovalidateMode.always,
  //     focusNode: _pinPutFocusNode,
  //     controller: _pinPutController,
  //     animationCurve: Curves.easeIn,
  //     withCursor: false,
  //     smartQuotesType: SmartQuotesType.enabled,
  //     submittedFieldDecoration: _pinPutDecoration.copyWith(
  //       borderRadius: BorderRadius.circular(5),
  //       border: Border.all(color: Colors.amber, width: 2),
  //     ),
  //     selectedFieldDecoration: _pinPutDecoration.copyWith(
  //       borderRadius: BorderRadius.circular(5),
  //       border: Border.all(color: Colors.amber, width: 2),
  //     ),
  //     followingFieldDecoration: _pinPutDecoration.copyWith(
  //       borderRadius: BorderRadius.circular(5),
  //       border: Border.all(color: Colors.white10, width: 2),
  //     ),
  //     onChanged: (String pin) {
  //       otpCode = pin;
  //     },
  //     onSubmit: (String pin) {
  //       otpCode = pin;
  //     },
  //   );
  // }

  Widget resendOtp() {
    return enableResend
        ? InkWell(
            onTap: () async {
              print("Country Code : " + '+91');
              print("Mobile Number : " + AppConstants.userModel.mobileNumber);
              setLoadingState(true);
              FirebasePhoneAuth(context, this).startPhoneAuth(
                  '+91' + AppConstants.userModel.mobileNumber,
                  widget.resendToken);

              if (mounted) {
                setState(() {
                  enableResend = false;
                  _start = 60;
                  resendMessage =
                      "Didn't get the OTP? Resend OTP in $_start" "s";
                  startTime();
                });
              }
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Didn't get the OTP? ",
                style: themeData.textTheme.subtitle2,
                children: const <TextSpan>[
                  TextSpan(
                      text: 'RESEND OTP',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
            ),
          )
        : Text(resendMessage,
            style: themeData.textTheme.subtitle2, textAlign: TextAlign.center);
  }

  void _validateOtpInputs() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (otpCode.isNotEmpty && otpCode.length == 6) {
      _formKey.currentState!.save();
      print("OTP is => " + otpCode);
      setLoadingState(true);

      UserModel user = UserModel(
          uuid: AppConstants.userModel.uuid,
          ipAddress: '',
          location: '',
          // firstName: AppConstants.userModel.firstName,
          // lastName: AppConstants.userModel.lastName,
          // countryCode: AppConstants.userModel.countryCode,
          // countryName: AppConstants.userModel.countryName,
          generatedQRCode: '',
          qrCodePath: '',
          dialCode: AppConstants.userModel.dialCode,
          mobileNumber: AppConstants.userModel.mobileNumber,
          currentDate: DateTime.now());

      FirebasePhoneAuth(context, this)
          .signInWithPhoneNumber(otpCode, widget.verificationId, user);
    } else {
      CommonUtils.instance.showSnackBar(context, "Please enter OTP");
    }
  }

  @override
  void onAuthenticationFail(FirebaseAuthException error) {
    setLoadingState(false);
    print("Mobile Number Page : onAuthenticationFail ${error.code}");
    // to do -- split error msg
    if (error.code == 'network-request-failed') {
      CommonUtils.instance.showSnackBar(
          context, "No network connection. Please try again.", "N");
    } else {
      CommonUtils.instance.showSnackBar(
          context, "Invalid OTP. Please enter valid OTP or try again.");
    }
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
    // await PreferenceManager.instance.setIsLogin(true);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  void onCodeAutoRetrievalTimeout(String verificationId) {
    setLoadingState(false);
    widget.verificationId = verificationId;
    print("OTP Page : onCodeAutoRetrievalTimeout");
  }

  @override
  void onCodeSent(String verificationKey, int? resendTokenKey) {
    setLoadingState(false);
    widget.verificationId = verificationKey;
    widget.resendToken = resendTokenKey;
    //CommonUtils.instance.showSnackBar(context, "OTP sent successfully", "P");
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

  void setLoadingState(bool status) {
    if (mounted) {
      setState(() {
        isShowLoading = status;
      });
    }
  }
}
