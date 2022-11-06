import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/src/services/model/cloud_user.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _isFirebaseLoaded = false;
  static User? _user;
  static Future Function(UserModel? user)? _startUpListener;

  static Future Function(UserModel user)? _changeListener;

  Future<void> _updateCurrentUserInApp(currentUserId) async {
    print('authStateChanges: the user id is $currentUserId');

    try {
      DocumentReference profileRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);

      var documentSnapshot = await profileRef.get();
      if (!documentSnapshot.exists) {
        return;
      } else {
        CloudUser cloudUser = CloudUser.fromJson(documentSnapshot.data());

        _changeListener!(UserModel(
          uuid: cloudUser.uuid,
          dialCode: cloudUser.dialCode,
          ipAddress: '',
          location: '',
          generatedQRCode: '',
          qrCodePath: '',
          // countryCode: cloudUser.countryCode,
          // countryName: cloudUser.countryName,
          mobileNumber: cloudUser.mobileNumber,
          currentDate: DateTime.now(),
          // firstName: cloudUser.firstName,
          // lastName: cloudUser.lastName,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  AuthService._internal() {
    _auth.authStateChanges().listen((User? user) async {
      _isFirebaseLoaded = true;
      _user = user;
      if (user == null) {
        print('AUTH --- The user is not yet logged in');
        // PreferenceManager.instance.clearAll();
      } else {
        print('AUTH --- The user login details are ${_user!.phoneNumber}');
        //await PreferenceManager.instance.setMobileNumber(_user!.phoneNumber!);

        await _updateCurrentUserInApp(_user!.uid);
      }
      _notifyClient(user);
    });
  }
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  static notifyUserInfo(Future Function(UserModel? user)? startUpListener) {
    _startUpListener = startUpListener;

    if (_startUpListener == null) return;

    if (_isFirebaseLoaded) _notifyClient(_user);
  }

  static _notifyClient(User? user) async {
    if (_isFirebaseLoaded == false) return;
    if (_startUpListener == null) return;

    if (user == null) {
      _startUpListener!(null);
      return;
    }

    UserModel model = UserModel(
      uuid: _user!.uid,
      // firstName: '',
      // lastName: '',
      // countryCode: '',
      // countryName: '',
      generatedQRCode: '',
      qrCodePath: '',
      ipAddress: '',
      location: '',
      dialCode: '+91',
      mobileNumber: _user!.phoneNumber!,
      currentDate: DateTime.now(),
    );

    await _startUpListener!(model);
  }

  static setChangeListener(Future Function(UserModel user)? changeListener) {
    _changeListener = changeListener;
  }

  static logout() async {
    await _auth.signOut();
  }
}
