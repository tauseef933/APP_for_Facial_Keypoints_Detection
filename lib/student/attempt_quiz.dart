import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/calibrationpage.dart';
import 'package:myapp/student/play_quiz.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';

//import 'package:myapp/reusable_widgets/loading.dart';

class AttemptQuiz extends StatefulWidget {
  AttemptQuiz({required this.studentId, super.key});

  final String? studentId;
  late final StudentDatabaseService dbs =
      StudentDatabaseService(uid: studentId);

  @override
  State<AttemptQuiz> createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> {
  final StudentAuthService _auth = StudentAuthService();

  late Stream quizStream;

  var imgUrls = [
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpg",
    "assets/images/5.jpg",
    "assets/images/1.webp",
    "assets/images/6.avif"
  ];

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                      child: QuizTile(
                        studentId: widget.studentId,
                        quizId: snapshot.data.docs[index]["quizId"],
                        title: snapshot.data.docs[index]["quizTitle"],
                        desc: snapshot.data.docs[index]["quizDescription"],
                        instructorId: snapshot.data.docs[index]["instructorId"],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    widget.dbs.getQuizzes().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var studentUser = Provider.of<StudentUser>(context);

    return StreamBuilder<StudentUserData>(
        stream: StudentDatabaseService(uid: studentUser.studentId).studentData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshot has data");
            StudentUserData? studentUserData = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                    color: Color.fromARGB(255, 255, 63, 255)),
                backgroundColor: const Color.fromARGB(250, 26, 12, 54),
                elevation: 0.0,
                title: reusableappBar(context),
              ),
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/stdlogo-2.png",
                        fit: BoxFit.fitWidth,
                        width: 240,
                        height: 240,
                        // color: Colors.white,
                      ),
                      _showGuidelines
                          ? _buildGuidelines()
                          : Expanded(child: quizList()),
                    ]),
              ),
            );
          } else {
            print("Snapshot has no data");
            return const Loading();
          }
        });
  }

  bool _showGuidelines = true;

  void _hideGuidelines() {
    setState(() {
      _showGuidelines = false;
    });
  }

  Widget _buildGuidelines() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Guidelines for Quiz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '1. Ensure you have a stable internet connection.\n\n'
            '2. Keep your camera on at all times.\n\n'
            '3. Make sure you stay centered while attempting quiz.\n\n'
            '4. Do not switch to other applications during the quiz.\n\n'
            '5. Going back while attempting quiz will lead to cancellation of quiz'
            '6. Any suspicious activity will be flagged.\n\n'
            '7. Answer all questions to the best of your ability.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _hideGuidelines,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(255, 233, 14, 211), // background color
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title;
  final String desc;
  final String quizId;
  final String? studentId;
  final String? instructorId;

  const QuizTile(
      {required this.desc,
      required this.title,
      required this.quizId,
      required this.studentId,
      required this.instructorId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                ////go to callibration page here
//
//
//
                // builder: (context) => PlayQuiz(
                //       studentId: studentId,
                //       quizId: quizId,
                //     )));
                builder: (context) => CalibrationPage(
                      studentId: studentId,
                      quizId: quizId,
                      instructorId: instructorId,
                      quizTitle: title,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 140, 17, 81),
              Color.fromARGB(255, 107, 39, 152),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.notifications_active,
              color: Color.fromRGBO(255, 255, 255, 1)),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1))),
          subtitle: Text(desc, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.forward_rounded,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
