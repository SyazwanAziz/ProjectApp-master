import 'package:flutter_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/updateUser.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future updateUserData(
      String name, String phoneNum, String address, int userType) async {
    return await brewCollection.document(uid).setData({
      'name': name,
      'phoneNum': phoneNum,
      'address': address,
      'userType': userType,
    });
  }

  // brew list from snapshot
  List<CustData> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return CustData(
        name: doc.data['name'] ?? '',
        phoneNum: doc.data['phoneNum'] ?? '0',
        address: doc.data['address'] ?? '',
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      phoneNum: snapshot.data['phoneNum'],
      address: snapshot.data['address'],
    );
  }

  // get brews stream
  Stream<List<CustData>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

// get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
