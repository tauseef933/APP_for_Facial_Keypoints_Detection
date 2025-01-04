import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/instructor/instructor_wrapper.dart';
import 'package:myapp/questions.dart';
import 'package:myapp/results_screen.dart';
import 'package:myapp/start_screen.dart';
import 'package:myapp/student/common/utils/screen_size_util.dart';
import 'package:myapp/student/student_wrapper.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:provider/provider.dart';

import 'student/common/utils/custom_snackbar.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  int userCheck = 0;

  Widget? activeScreen;
  List<String> selectedAnswers = [];

  @override
  void initState() {
    activeScreen =
        StartScreen(switchScreen, goToInstructor, goToStudent, goBack: goBack);
    super.initState();
  }

  void goToInstructor() {
    setState(() {
      activeScreen = InstructorWrapper(goBack: goBack);
      userCheck = 1;
    });
  }

  void goToStudent() {
    setState(() {
      activeScreen = StudentWrapper(goBack: goBack);
      userCheck = 2;
    });
  }

  void switchScreen() {
    setState(() {
      activeScreen = QuestionsScreen(chosenAnswer);
    });
  }

  void chosenAnswer(String selectedAnswer) {
    selectedAnswers.add(selectedAnswer);

    if (questions.length == selectedAnswers.length) {
      setState(() {
        activeScreen = ResultScreen(selectedAnswers, goBack, "");
        selectedAnswers = [];
      });
    }
  }

  void goBack() {
    setState(() {
      activeScreen = StartScreen(
        switchScreen,
        goToInstructor,
        goToStudent,
        goBack: goBack,
      );
    });
  }

  @override
  Widget build(context) {
    initializeUtilContexts(context);
    if (userCheck == 1) {
      print("usercheckk 1");
      return StreamProvider<InstructorUser?>.value(
        value: InstructorAuthService().user,
        initialData: null,
        child: MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 26, 12, 52),
                    Color.fromARGB(255, 84, 62, 123),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: activeScreen,
            ),
          ),
        ),
      );
    } else if (userCheck == 2) {
      print("usercheckk 2");
      return StreamProvider<StudentUser?>.value(
        value: StudentAuthService().user,
        initialData: null,
        child: MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 26, 12, 52),
                    Color.fromARGB(255, 84, 62, 123),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: activeScreen,
            ),
          ),
        ),
      );
    } else {
      print("usercheck 0 orsomein");
      return MaterialApp(
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 26, 12, 52),
                  Color.fromARGB(255, 84, 62, 123),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: activeScreen,
          ),
        ),
      );
    }
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }
}
