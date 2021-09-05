import 'package:assyifa_admin/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String adminUid = 'OT9j91hxBDNY2ylxtObFSyJZE2H3';

  // create user model object based on FirebaseUser
  UserModel _userFromFirebaseUser(FirebaseUser user) {
    return UserModel(uid: user.uid);
  }

  // auth change user stream
  Stream<UserModel> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if (user.uid == adminUid) return _userFromFirebaseUser(user);
      else {
        await _auth.signOut();
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}