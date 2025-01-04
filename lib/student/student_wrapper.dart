import 'package:flutter/material.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/student_home.dart';
import 'package:myapp/student/student_register.dart';
import 'package:myapp/student/student_sign_in_screen.dart';
import 'package:provider/provider.dart';

class StudentWrapper extends StatefulWidget {
  const StudentWrapper({super.key, required this.goBack});

  final void Function() goBack;

  @override
  State<StudentWrapper> createState() => _StudentWrapperState();
}

class _StudentWrapperState extends State<StudentWrapper> {
  bool showSignIn = true;

  void toggleView() {
    //print("in toggle");

    setState(() {
      // print(showSignIn);
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<StudentUser?>(context);

    print('${studentUser} got student');

    //return either home or authentication
    if (studentUser == null) {
      if (showSignIn) {
        return StudentSignIn(toggleView, goBack: widget.goBack);
      } else {
        return StudentRegister(toggleView, goBack: widget.goBack);
      }
    } else {
      print("should go student home");
      return StudentHome();
    }
  }
}
