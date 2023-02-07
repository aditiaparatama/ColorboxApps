import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';

class FirebaseService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('userToken');

  Future<void> addUserToFireStore(UserModel userModel) async {
    return await _collectionReference
        .doc(userModel.email)
        .set(userModel.toFireStore());
  }

  Future<DocumentSnapshot> retriveData(String email) async {
    return await _collectionReference.doc(email).get();
  }

  Future<void> updateToken(UserModel userModel) async {
    return await _collectionReference
        .doc(userModel.email)
        .update(userModel.toFireStore());
  }
}
