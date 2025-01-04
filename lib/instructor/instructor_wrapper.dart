import 'package:flutter/material.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/instructor/instructor_home.dart';
import 'package:myapp/instructor/instructor_register.dart';
import 'package:myapp/instructor/instructor_sign_in_screen.dart';
import 'package:provider/provider.dart';

class InstructorWrapper extends StatefulWidget {
  const InstructorWrapper({super.key, required this.goBack});

  final void Function() goBack;

  @override
  State<InstructorWrapper> createState() => _InstructorWrapperState();
}

class _InstructorWrapperState extends State<InstructorWrapper> {
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
    final instructorUser = Provider.of<InstructorUser?>(context);
    // print(instructorUser);

    //return either home or authentication
    if (instructorUser == null) {
      if (showSignIn) {
        return InstructorSignIn(toggleView, goBack: widget.goBack);
      } else {
        return InstructorRegister(toggleView, goBack: widget.goBack);
      }
    } else {
      print("should goinstructor home");
      return InstructorHome();
    }
  }
}
