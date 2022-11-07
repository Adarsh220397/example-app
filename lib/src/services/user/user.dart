import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/src/services/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserService {
  UserService._internal();
  static UserService instance = UserService._internal();
  factory UserService() {
    return instance;
  }

  Future<List<UserModel>> getCurrentUserLoginDetails(
      String mobileNumber) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    List<UserModel> list = [];
    try {
      CollectionReference profileRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection(mobileNumber);

      QuerySnapshot stateCollectionRef = await profileRef.get();

      if (stateCollectionRef.docs.isEmpty) {
        return list;
      }
      list = stateCollectionRef.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      list.removeWhere((element) => element.ipAddress.isEmpty);
    } catch (e) {
      print('------error-$e');
      return list;
    }
    return list;
  }

  Future<String> addUserInformation(UserModel userModel) async {
    String currentDate = DateFormat('hh:mm:ss').format(DateTime.now());
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      await userCollection
          .doc(userModel.uuid)
          .collection(userModel.mobileNumber)
          .doc(currentDate)
          .set(userModel.toJson());
    } catch (e) {
      print(e);
    }
    return currentDate;
  }

  Future<void> updateUserInformation(String uid, String mobileNumber,
      String imageUrl, num qrCode, String date) async {
    List<UserModel> list = [];
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot docRef =
          await userCollection.doc(uid).collection(mobileNumber).get();

      if (docRef.docs.isNotEmpty) {
        list = docRef.docs
            .map(
                (doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      }

      list.sort(((a, b) => b.currentDate.compareTo(a.currentDate)));

      await userCollection.doc(uid).collection(mobileNumber).doc(date).update({
        'generatedQRCode': qrCode.toString(),
        'qrCodePath': imageUrl,
      });
    } catch (e) {
      print(e);
    }
  }
}
