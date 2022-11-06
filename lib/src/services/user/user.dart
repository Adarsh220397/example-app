import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/src/services/model/cloud_user.dart';
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
    // Which user? it is current user
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    print('the user id is $currentUserId');
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

  Future<String> addUser(UserModel userModel) async {
    // DateTime date = DateTime.now();
    String currentDate = DateFormat('hh:mm:ss').format(DateTime.now());
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      print('------------');
      print(userModel.location);
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

  Future<void> updateUser(String uid, String mobileNumber, String imageUrl,
      num qrCode, String date) async {
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
      print(list.first.currentDate);
      print(list.last.currentDate);
      print(
          '--------$uid---$mobileNumber-------${list.first.currentDate}---$qrCode--$imageUrl');
      await userCollection.doc(uid).collection(mobileNumber).doc(date).update({
        'generatedQRCode': qrCode.toString(),
        'qrCodePath': imageUrl,
      });
    } catch (e) {
      print(e);
    }
  }
  // Future<List<CloudUserHouse>> getHouseInfoList(String uid) async {
  //   List<CloudUserHouse> userHouseList = [];

  //   try {
  //     CollectionReference userCollection = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('fpUserHouse');

  //     await userCollection.get().then(
  //       (QuerySnapshot querySnapshot) {
  //         for (var house in querySnapshot.docs) {
  //           CloudUserHouse userHouse = CloudUserHouse.fromJson(house);

  //           userHouseList.add(userHouse);
  //         }
  //       },
  //     );

  //     return userHouseList;
  //   } catch (e) {
  //     print('--no house in users-------$e');
  //   }
  //   return userHouseList;
  // }

  // Future<bool> updateUserInfo(
  //     String firstName, String lastName, String uuid, String contact) async {
  //   try {
  //     List<CloudUserHouse> userHouseList = [];
  //     var batch = FirebaseFirestore.instance.batch();

  //     CollectionReference userCollection =
  //         FirebaseFirestore.instance.collection('users');
  //     batch.update(userCollection.doc(uuid),
  //         {'firstName': firstName, 'lastName': lastName});

  //     CollectionReference userCollectionRef =
  //         userCollection.doc(uuid).collection('fpUserHouse');

  //     await userCollectionRef.get().then(
  //       (QuerySnapshot querySnapshot) {
  //         for (var house in querySnapshot.docs) {
  //           CloudUserHouse userHouse = CloudUserHouse.fromJson(house);

  //           userHouseList.add(userHouse);
  //         }
  //       },
  //     );

  //     for (var house in userHouseList) {
  //       CollectionReference updateHouseKYCRef =
  //           FirebaseFirestore.instance.collection('houseKYC');

  //       batch.update(updateHouseKYCRef.doc(house.houseCode),
  //           {'firstName': firstName, 'lastName': lastName});

  //       CollectionReference updateHouseUserRef = FirebaseFirestore.instance
  //           .collection('houseUser')
  //           .doc(house.houseCode)
  //           .collection('fpHouseUserRole');

  //       batch.update(updateHouseUserRef.doc(uuid),
  //           {'firstName': firstName, 'lastName': lastName});

  //       CollectionReference invitationRef = FirebaseFirestore.instance
  //           .collection('invitations')
  //           .doc(house.houseCode)
  //           .collection('houseInvited');

  //       var documentSnapshot = await invitationRef.doc(contact).get();
  //       if (documentSnapshot.exists) {
  //         batch.update(invitationRef.doc(contact),
  //             {'firstName': firstName, 'lastName': lastName});
  //       }

  //       batch.update(userCollectionRef.doc(house.houseCode),
  //           {'firstName': firstName, 'lastName': lastName});
  //     }

  //     batch.commit().then((value) async {
  //       await PreferenceManager.instance.setFirstName(firstName);
  //       await PreferenceManager.instance.setLastName(lastName);
  //       AppConstants.userModel.firstName = firstName;
  //       AppConstants.userModel.lastName = lastName;
  //     });
  //   } catch (e) {
  //     print('-----user name update--------$e');
  //   }
  //   return true;
  // }
}
