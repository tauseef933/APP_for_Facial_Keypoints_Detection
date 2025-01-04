//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/student_services/database.dart';
//import 'package:myapp/question_identifier.dart';

class StudentAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create userObject based on firebase user
  StudentUser? _userFromFirebase(User? user) {
    print('${user?.uid} here');
    return user != null ? StudentUser(user.uid) : null;
  }

  //auth change user stream
  Stream<StudentUser?> get user {
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
      String firstName,
      String lastName,
      String email,
      String password,
      String? image,
      FaceFeatures? faceFeatures) async {
    try {
      print("register with email called");
      //attempt to create user and return UserCredentials
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //firebase user from UserCredentials
      User? user = result.user;

      //register instructor to database
      print("adding student User auth file");
      await StudentDatabaseService(uid: user?.uid)
          .updateStudentData(firstName, lastName, email, image, faceFeatures);

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
