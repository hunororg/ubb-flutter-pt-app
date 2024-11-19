import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubb_flutter_pt_app/model/login_method.dart';
import 'package:ubb_flutter_pt_app/model/user_role.dart';

class UserData {
  final String email;
  final AuthMethod authMethod;
  final UserRole userRole;

  UserData(this.email, this.authMethod, this.userRole);

  UserData.fromDocument(DocumentSnapshot doc)
      : email = doc['email'] as String,
        authMethod = AuthMethod.values.byName(doc['authMethod'] as String),
        userRole = UserRole.values.byName(doc['userRole'] as String);
}