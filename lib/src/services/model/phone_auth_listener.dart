import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneAuthListener {
  void onCodeSent(String verificationId, int? resendToken);
  void onCodeAutoRetrievalTimeout(String verificationId);
  void onVerificationFailed(FirebaseAuthException error);
  void onVerificationCompleted(String? otp);
  Future<void> onAuthenticationSuccess(User? firebaseUser);
  void onAuthenticationFail(FirebaseAuthException error);
}
