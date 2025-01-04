import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Models/quiz_question.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/questions.dart';
import 'package:myapp/results_screen.dart';
import 'package:myapp/student/calibrationpage.dart';
//import 'package:myapp/student/student_home.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:camera/camera.dart';

class PlayQuiz extends StatefulWidget {
  PlayQuiz(
      {required this.quizId,
      required this.studentId,
      required this.upload,
      super.key});

  final String quizId;
  final String? studentId;
  final Future<void> Function() upload;

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  Widget? activeScreen;
  List<String> selectedAnswers = [];

  @override
  void initState() {
    questions.clear();
    QuerySnapshot questionsSnapshot;
    StudentDatabaseService dbs = StudentDatabaseService(uid: widget.studentId);
    dbs.getQuizData(widget.quizId).then((value) {
      questionsSnapshot = value;
      questionsSnapshot.docs != null
          ? questionsSnapshot.docs.forEach((element) {
              List<String> answers = [
                element["option1"],
                element["option2"],
                element["option3"],
                element["option4"]
              ];
              questions.add(QuizQuestion(element["question"], answers));
            })
          : print("questionssap empty");

      print("${widget.quizId}");
      print("${questions}waddyo");

      setState(() {
        /////
        ///
        ///add calibration page here
        ///when done change active screen to questions screen
        ///or add camera in this widget the web or your own start running the
        activeScreen = QuestionsScreen(
            chosenAnswer); //cant add logic for webview in questions screen
      });
    });

    super.initState();
  }

  void goBack() {
    setState(() {
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (BuildContext context) => StudentHome()));
      Navigator.pop(context);
    });
  }

  void chosenAnswer(String selectedAnswer) async {
    selectedAnswers.add(selectedAnswer);

    if (questions.length == selectedAnswers.length) {
      // final List<Map<String, Object>> summary = [];

      // for (var i = 0; i < selectedAnswer.length; i++) {
      //   summary.add(
      //     {
      //       "question_index": i,
      //       "question": questions[i].text,
      //       'correct_answer': questions[i].answers[0],
      //       'user_answer': selectedAnswer[i],
      //     },
      //   );
      // }
      // final numTotalQuestions = questions.length;
      // final numCorrectQuestions = summary.where((data) {
      //   return data['user_answer'] == data['correct_answer'];
      // }).length;

      // StudentDatabaseService dbs =
      //     StudentDatabaseService(uid: widget.studentId);

      // print("Correct $numCorrectQuestions");
      // print("total $numTotalQuestions");

      setState(() {
        activeScreen = ResultScreen(selectedAnswers, goBack, widget.studentId);
        selectedAnswers = [];
        shouldGen = true;
      });
      // await dbs.reportsCollection
      //     .doc(reportID)
      //     .update({'totalMarks': numTotalQuestions});
      // await dbs.reportsCollection
      //     .doc(reportID)
      //     .update({'obtainedMarks': numCorrectQuestions});
    }

    await widget.upload();
  }

//add webview logic here upon condition to show web view or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
