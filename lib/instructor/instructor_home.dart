import 'package:flutter/material.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/instructor/create_quiz.dart';
import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/instructor/instructor_services/database.dart';
import 'package:myapp/instructor/view_students.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/reports.dart';
import 'package:provider/provider.dart';
//import 'package:myapp/reusable_widgets/loading.dart';

class InstructorHome extends StatelessWidget {
  InstructorHome({super.key});

  final InstructorAuthService _auth = InstructorAuthService();

  @override
  Widget build(BuildContext context) {
    final instructorUser = Provider.of<InstructorUser>(context);

    return StreamBuilder<InstructorUserData>(
        stream: InstructorDatabaseService(uid: instructorUser.instructorId)
            .instructorData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshot has data");
            InstructorUserData? instructorUserData = snapshot.data;

            return Scaffold(
              
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(250, 26, 12, 54),
                title: reusableappBar(context),
                actions: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 63, 255),
                          fontSize: 16),
                    ),
                    icon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 255, 63, 255),
                    ),
                  ),
                ],
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                      child: Column(
                        children: <Widget>[
                          logoWidget("assets/images/logo1.png"),
                          const SizedBox(
                            height: 30,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            spacing: 20,
                            children: [
                              SizedBox(
                                width: 180,
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    print(instructorUserData?.firstName);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewStudents(
                                                  instructorId: instructorUser
                                                      .instructorId,
                                                )));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 181, 29, 181),
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 189, 255),
                                  ),
                                  icon: const Icon(Icons.group_add_rounded),
                                  label: const Text('Students'),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CreateQuiz(
                                                instructorId: instructorUser
                                                    .instructorId)));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 181, 29, 181),
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 189, 255),
                                  ),
                                  icon: const Icon(Icons.add_box_sharp),
                                  label: const Text('Add Quiz'),
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 181, 29, 181),
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 189, 255),
                                  ),
                                  icon: const Icon(Icons.add_task_sharp),
                                  label: const Text('Add Assignment'),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Reports(
                                                  studentId: instructorUser
                                                      .instructorId,
                                                  userType: 1,
                                                )));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 181, 29, 181),
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 189, 255),
                                  ),
                                  icon: const Icon(
                                      Icons.report_gmailerrorred_sharp),
                                  label: const Text('Check Reports'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            print("Snapshot has no data");
            return const Loading();
          }
        });
  }
}
