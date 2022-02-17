import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final _database = FirebaseDatabase.instance.reference();

  Future updateUserData(String email, String password) async {
    Map<String, dynamic> userData = {
      'Email': email,
      'Password': password,
    };
    return await _database.child("Users").child("$uid").update(userData);
  }
}
