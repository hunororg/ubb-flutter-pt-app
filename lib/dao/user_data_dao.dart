import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/model/store/userdata.dart';

class UserDataDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  Future<List<UserData>> getAllUsers() async {
    final querySnapshot = await _db.collection(_usersCollection).get();
    return querySnapshot.docs.map((doc) => UserData.fromDocument(doc)).toList();
  }

  Future<UserData?> getUserData(String email, AuthMethod authMethod) async {
    try {
      final querySnapshot = await _db
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .where('authMethod', isEqualTo: authMethod.value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return UserData.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserData(UserData userData) async {
     await _db.collection(_usersCollection).add({
      'email': userData.email,
      'authMethod': userData.authMethod.value,
      'userRole': userData.userRole.value,
    });
  }
}