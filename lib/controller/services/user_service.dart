import 'package:carpool/models/database_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carpool/models/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<CarPoolUser?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
        Query query = usersRef.orderByChild('email').equalTo(user.email);

        DataSnapshot snapshot = await query.get();
        if (snapshot.exists && snapshot.value != null) {
          Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
          if (data != null && data.containsKey(user.uid)) {
            var userData = data[user.uid] as Map<dynamic, dynamic>;
            return CarPoolUser.fromMap(Map<String, dynamic>.from(userData));
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }



}