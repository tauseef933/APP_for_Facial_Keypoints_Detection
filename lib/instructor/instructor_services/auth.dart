//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/instructor/instructor_services/database.dart';
//import 'package:myapp/question_identifier.dart';

class InstructorAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create userObject based on firebase user
  InstructorUser? _userFromFirebase(User? user) {
    print(user?.uid);
    return user != null ? InstructorUser(user.uid) : null;
  }

  //auth change user stream
  Stream<InstructorUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user));
  }

  //sign in ann

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      User? user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //attempt to create user and return UserCredentials
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      //firebase user from UserCredentials
      User? user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //register email pass

  Future registerWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      //attempt to create user and return UserCredentials
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //firebase user from UserCredentials
      User? user = result.user;

      //register instructor to database
      print("adding User auth file");
      await InstructorDatabaseService(uid: user?.uid)
          .updateInstructorData(firstName, lastName, email);

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
