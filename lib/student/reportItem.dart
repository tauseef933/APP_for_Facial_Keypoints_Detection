import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/ReportItemView.dart';
import 'package:myapp/student/calibrationpage.dart';
import 'package:myapp/student/play_quiz.dart';
import 'package:myapp/student/reportItem.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';

//import 'package:myapp/reusable_widgets/loading.dart';

class ReportsItem extends StatefulWidget {
  ReportsItem({
    required this.studentId,
    required this.instructorId,
    required this.reportId,
  });

  final String? studentId;
  late final StudentDatabaseService dbs =
      StudentDatabaseService(uid: studentId);
  final String? instructorId;

  final String reportId;

  @override
  State<ReportsItem> createState() => _ReportItem();
}

class _ReportItem extends State<ReportsItem> {
  late Stream reportsItemStream;

  String name = "";

  var imgUrls = [
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpg",
    "assets/images/5.jpg",
    "assets/images/1.webp",
    "assets/images/6.avif"
  ];

  // Future<String> studentName() async {
  //   StudentDatabaseService sds = StudentDatabaseService(uid: widget.studentId);
  //   DocumentSnapshot<Object?> snap =
  //       await sds.studentsCollection.doc(widget.studentId).get();
  //   String studentName = snap["firstName"];
  //   String lastName = snap["lastName"];
  //   print("student name : $studentName $lastName");

  //   name = "$studentName $lastName";

  //   return "$studentName $lastName";
  // }

  Widget reportItemList() {
    return Container(
      child: StreamBuilder(
        stream: reportsItemStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
                      child: ReportItemTile(
                        imageUrl: snapshot.data.docs[index]["imageUrl"],
                        message: snapshot.data.docs[index]["message"],
                        timeStamp: snapshot.data.docs[index]["timeStamp"],
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
    widget.dbs.getReportsData(widget.reportId).then((val) {
      setState(() {
        reportsItemStream = val;

        // studentName();
      });
    });

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
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(155, 216, 67, 184),
                  Color.fromARGB(193, 116, 39, 248),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 197, 170, 188).withOpacity(0.2),
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
                  widget.instructorId.toString(),
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.reportId,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(155, 35, 153, 127),
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
                  " ${widget.instructorId}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'details reports are below:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
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
                  "Detail Report",
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
          Expanded(child: reportItemList()),
        ]),
      ),
    );
  }
}

class ReportItemTile extends StatefulWidget {
  String imageUrl;
  String message;
  String timeStamp;

  ReportItemTile({
    required this.imageUrl,
    required this.message,
    required this.timeStamp,
  });

  @override
  State<ReportItemTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportItemTile> {
  @override
  void initState() {
    super.initState();
  }

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
                builder: (context) => ReportItemView(
                      imageUrl: widget.imageUrl,
                      message: widget.message,
                      timeStamp: widget.timeStamp,
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
          leading: const Icon(Icons.error_outline_rounded,
              color: Color.fromRGBO(255, 255, 255, 1)),
          title: Text(widget.message,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 1))),
          subtitle: Text(widget.timeStamp,
              style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.forward_rounded,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
