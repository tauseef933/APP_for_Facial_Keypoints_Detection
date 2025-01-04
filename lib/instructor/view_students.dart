import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/instructor/instructor_services/database.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/play_quiz.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';

//import 'package:myapp/reusable_widgets/loading.dart';

class ViewStudents extends StatefulWidget {
  ViewStudents({required this.instructorId, super.key});

  final String? instructorId;
  late final InstructorDatabaseService dbs =
      InstructorDatabaseService(uid: instructorId);

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  final InstructorAuthService _auth = InstructorAuthService();

  late Stream studentsStream;

  Widget studentsList() {
    return Container(
      child: StreamBuilder(
        stream: studentsStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                      child: StudentsTile(
                        name: snapshot.data.docs[index]["firstName"],
                        email: snapshot.data.docs[index]["email"],
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
    widget.dbs.getStudents().then((val) {
      setState(() {
        studentsStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var instructorUser = Provider.of<InstructorUser>(context);

    // return StreamBuilder<StudentUserData>(
    //     stream: InstructorDatabaseService(uid: instructorUser.instructorId)
    //         .studentsData,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         print("snapshot has data");
    //         StudentUserData? studentUserData = snapshot.data;

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 63, 255)),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "assets/images/stdlogo-2.png",
            fit: BoxFit.fitWidth,
            width: 240,
            height: 240,
            // color: Colors.white,
          ),
          const SizedBox(
            height: 30,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Students ',
                      style: TextStyle(
                          color: Color.fromARGB(239, 215, 107, 215),
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: 'Enrolled',
                      style: TextStyle(
                          color: Color.fromARGB(255, 211, 32, 211),
                          fontWeight: FontWeight.bold)),
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          Expanded(child: studentsList()),
        ]),
      ),
    );
    // } else {
    //   print("Snapshot has no data");
    //   return const Loading();
    // }
  }
}

class StudentsTile extends StatelessWidget {
  final String name;
  final String email;
  // final String quizId;
  //final String? studentId;

  const StudentsTile({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
          title: Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1))),
          subtitle: Text(email, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.forward_rounded,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
