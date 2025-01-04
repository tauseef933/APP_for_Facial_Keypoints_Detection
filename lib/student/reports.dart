import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/calibrationpage.dart';
import 'package:myapp/student/play_quiz.dart';
import 'package:myapp/student/reportItem.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';

//import 'package:myapp/reusable_widgets/loading.dart';

class Reports extends StatefulWidget {
  Reports({required this.studentId, required this.userType, super.key});

  final String? studentId;
  final int userType;
  late final StudentDatabaseService dbs =
      StudentDatabaseService(uid: studentId);

  @override
  State<Reports> createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<Reports> {
  late Stream reportsStream;

  String name = "";

  var imgUrls = [
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpg",
    "assets/images/5.jpg",
    "assets/images/1.webp",
    "assets/images/6.avif"
  ];

  Widget reportList() {
    return Container(
      child: StreamBuilder(
        stream: reportsStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                      child: ReportTile(
                        studentId: widget.studentId.toString(),
                        reportId: snapshot.data.docs[index]["reportId"],
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
    if (widget.userType == 0) {
      print("user type student");
      widget.dbs.getReports(widget.studentId, widget.userType).then((val) {
        setState(() {
          reportsStream = val;
        });
      });
    } else {
      print("user i");
      widget.dbs.getReports(widget.studentId, widget.userType).then((val) {
        setState(() {
          reportsStream = val;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          // Image.asset(
          //   "assets/images/stdlogo-2.png",
          //   fit: BoxFit.fitWidth,
          //   width: 240,
          //   height: 240,
          //   // color: Colors.white,
          // ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(155, 236, 56, 125),
                  Color.fromARGB(193, 116, 39, 248),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reports",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: reportList()),
        ]),
      ),
    );
  }
}

class ReportTile extends StatefulWidget {
  final String? instructorId;
  final String? reportId;
  final String studentId;

  ReportTile(
      {required this.instructorId,
      required this.reportId,
      required this.studentId});

  @override
  State<ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportTile> {
  // Future<void> studentName(String id) async {
  //   print("Student name equals = ${widget.studentName} ");
  //   StudentDatabaseService sds = StudentDatabaseService(uid: id);
  //   DocumentSnapshot<Object?> snap =
  //       await sds.studentsCollection.doc(id).get().then(
  //     (value) {
  //       setState(() {
  //         String studentName = value["firstName"];
  //         String lastName = value["lastName"];
  //         print("student name : $studentName $lastName");

  //         widget.studentName = "$studentName $lastName";
  //       });
  //       return value;
  //     },
  //   );

  //   String studentName = snap["firstName"];
  //   String lastName = snap["lastName"];
  //   print("student name : $studentName $lastName");

  //   widget.studentName = "$studentName $lastName";
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.obtainedMarks = "${widget.obtainedMarks} / ${widget.totalMarks}";
  //   studentName(widget.studentId).then(
  //     (value) {
  //       setState(() {});
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportsItem(
                      instructorId: widget.instructorId,
                      studentId: widget.studentId,
                      reportId: widget.reportId.toString(),
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 12, 78, 64),
              Color.fromARGB(255, 107, 39, 152),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.notifications_active,
              color: Color.fromRGBO(255, 255, 255, 1)),
          title: Text(widget.instructorId.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1))),
          trailing: const Icon(Icons.forward_rounded,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
